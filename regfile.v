`include "defines.v"
module regfile(
    input wire                  clk,
    input wire                  rst,

    // writing
    input wire                  we,
    input wire[`RegAddrBus]     waddr,
    input wire[`RegBus]         wdata,

    // reading 1
    input wire                  re1,
    input wire[`RegAddrBus]     raddr1,
    output reg[`RegBus]         rdata1,

    // reading 2
    input wire                  re2,
    input wire[`RegAddrBus]     raddr2,
    output reg[`RegBus]         rdata2
);

/*
    stage 1. define a 32 length 32 bits
*/

reg[`RegBus] regs[0: `RegNum - 1];

/*
    stage 2. WRITING operation
*/

    always @(posedge clk) begin
        // $0 can only be 0
        if(rst == `RstDisable && we == `WriteEnable && waddr != 0)
            regs[waddr] <= wdata;
    end

/*
    stage 3. READING operation 1
*/

    always @(*) begin
        if(rst == `RstEnable || re1 == `ReadDisable) rdata1 <= `ZeroWord;
        else if(raddr1 == 0) rdata1 <= `ZeroWord; 
        // if writing / reading address are the same, connect it
        else if(raddr1 == waddr && we == `WriteEnable) rdata1 <= wdata;
        else rdata1 <= regs[raddr1];
    end

/*
    stage 4. READING operation 2
*/

always @(*) begin
        if(rst == `RstEnable || re2 == `ReadDisable) rdata2 <= `ZeroWord;
        else if(raddr2 == 0) rdata2 <= `ZeroWord; 
        else if(raddr2 == waddr && we == `WriteEnable) rdata2 <= wdata;
        else rdata2 <= regs[raddr2];
    end

endmodule