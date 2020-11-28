`include "defines.v"
module if_id(
    input wire                  clk,
    input wire                  rst,

    // from pc stage
    input wire[`InstAddrBus]    if_pc,
    input wire[`InstBus]        if_inst,

    // for decoding stage
    output reg[`InstAddrBus]    id_pc,
    output reg[`InstBus]        id_inst
);

    always @(posedge clk) begin
        if(rst == `RstEnable) begin
            id_pc <= `ZeroWord;   // pc = 0
            id_inst <= `ZeroWord; // inst = 0
        end
        else begin
            id_pc <= if_pc;       // forward the value from pc stage
            id_inst <= id_inst;
        end
    end

endmodule