`include "defines.v"

module regfile (
    input wire clk, rst,
    
    // write ports
    input wire [`RegBus] wdata,
    input wire [`RegAddrBus] waddr,
    input wire we,

    // read ports 1
    input wire [`RegAddrBus] raddr1,
    input wire re1,
    output reg [`RegBus] rdata1,

    //read ports 2
    input wire [`RegAddrBus] raddr2,
    input wire re2,
    output reg [`RegBus] rdata2
);

// stage 1: define the registers
reg [`RegBus] regs [0:`RegNum-1];

// stage 2: handle write
always @(posedge clk) begin
    if(rst == `RstDisable && we == WriteEnable && waddr != `RegNumLog2'h0) begin
        regs[waddr] <= wdata;
    end
end

// stage 3: handle read1
always @(*) begin
    if(rst == `RstEnable || re1 == `ReadDisable) begin
        rdata1 <= 32'h00000000;
    end else if (raddr1 == `RegNumLog2'h0) begin
        rdata1 <= 32'h00000000;
    end else if (raddr1 == waddr && we == `WriteEnable) begin
        rdata1 <= wdata;
    end else begin
        rdata1 <= regs[raddr1];
    end
end

// stage 4: handle read2
always @(*) begin
    if(rst == `RstEnable || re2 == `ReadDisable) begin
        rdata1 <= 32'h00000000;
    end else if (raddr2 == `RegNumLog2'h0) begin
        rdata1 <= 32'h00000000;
    end else if (raddr2 == waddr && we == `WriteEnable) begin
        rdata2 <= wdata;
    end else begin
        rdata2 <= regs[raddr2];
    end
end
endmodule
