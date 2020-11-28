`include "defines.v"
module inst_rom(
    input wire                  ce,
    input wire[`InstAddrBus]    addr,
    output reg[`InstBus]        inst
);

// define an array, used to store instructions
reg[`InstBus] inst_mem[0: `InstMemNum - 1];

// using "inst_rom.data" to initialize, used for simulation
initial $readmemh("inst_rom.data", inst_mem);

// giving the corresponding value
    always @(*) begin
        if(ce == `ChipDisable) begin
            inst <= `ZeroWord;
        end
        else begin
            inst <= inst_mem[addr[`InstMemNumLog2 + 1 : 2]]; // divided by 4
        end
    end


endmodule