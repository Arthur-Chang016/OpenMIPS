`include "defines.v"
module id(
    input wire                  rst,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_i,

    // output to "regfile", "regfile" controller
    output reg                  reg1_read_o,
    output reg                  reg2_read_o,
    output reg[`RegAddrBus]     reg1_addr_o,
    output reg[`RegAddrBus]     reg2_addr_o,

    // value read from "regfile"
    input wire[`RegBus]         reg1_data_i,
    input wire[`RegBus]         reg2_data_i,

    // output for execution stagett
    output reg[`AluOpBus]       aluop_o,
    output reg[`AluSelBus]      alusel_o,
    output reg[`RegBus]         reg1_o,
    output reg[`RegBus]         reg2_o,
    output reg[`RegAddrBus]     wd_o,
    output reg                  wreg_o
);

// operation code
// only need 26 - 31 bit to tell "ori" operation
wire[5:0] op = inst_i[31:26];
wire[4:0] op2 = inst_i[10:6];
wire[4:0] op3 = inst_i[5:0];
wire[5:0] op4 = inst_i[20:16];

// immediate number for storing instruction
reg[`RegBus] imm;

// validity of instruction
reg instvalid;


/*
    stage 1. decode the instruction
*/

    always @(*) begin
        if(rst == `RstEnable) begin
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o <= `NOPRegAddr;
            wreg_o <= `WriteDisable;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= `NOPRegAddr;
            reg2_addr_o <= `NOPRegAddr;
            imm <= 32'h0;
        end
        else begin
            aluop_o <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o <= inst_i[15:11];
            wreg_o <= `WriteDisable;
            instvalid <= `InstInvalid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            // default : passing reg_addr
            reg1_addr_o <= inst_i[25:21];
            reg2_addr_o <= inst_i[20:16];
            imm <= `ZeroWord;

            case(op)
                `EXE_ORI: begin
                    // ori : need to write into reg, so-> WriteEnable
                    wreg_o <= `WriteEnable;

                    // "OR" type computation
                    aluop_o <= `EXE_OR_OP;

                    // "logic" type computation
                    alusel_o <= `EXE_RES_LOGIC;

                    // need regfile READ 1
                    reg1_read_o <= 1'b1;

                    // NOT need regfile READ 2, the other source num is imm
                    reg2_read_o <= 1'b0;

                    // immediate num : extended to 32 bits
                    imm <= {16'h0, inst_i[15:0]};

                    // addr of the result
                    wd_o <= inst_i[20:16];

                    // ori is valid instruction
                    instvalid <= `InstValid;
                end
                default : begin
                end
            endcase // case end
        end         // end if
    end             // end always

/*
    stage 2. ensure the source number 1
*/

    always @(*) begin
        if(rst == `RstEnable) reg1_o <= `ZeroWord;
        else if(reg1_read_o == 1'b1) reg1_o <= reg1_data_i;
        else if(reg1_read_o == 1'b0) reg1_o <= imm;
        else reg1_o <= `ZeroWord;
    end
    
/*
    stage 3. ensure the source number 2
*/

    always @(*) begin
        if(rst == `RstEnable) reg2_o <= `ZeroWord;
        else if(reg2_read_o == 1'b1) reg2_o <= reg1_data_i;
        else if(reg2_read_o == 1'b0) reg2_o <= imm;
        else reg2_o <= `ZeroWord;
    end
    
endmodule