`include "defines.v"
module ex(

    input wire                  rst,

    // information from decoding stage
    input wire[`AluOpBus]       aluop_i,
    input wire[`AluSelBus]      alusel_i,
    input wire[`RegBus]         reg1_i,
    input wire[`RegBus]         reg2_i,
    input wire[`RegAddrBus]     wd_i,
    input wire                  wreg_i,

    // result of executing stage
    output reg[`RegAddrBus]     wd_o,
    output reg                  wreg_o,
    output reg[`RegBus]         wdata_o
);

// storing the result of logic computation
reg[`RegBus] logicout;

/*
    stage 1. by aluop_i, indicate the operator. here's only OR
*/

    always @(*) begin
        if(rst == `RstEnable) logicout <= `ZeroWord;

        else begin
            case(aluop_i)
                `EXE_OR_OP: begin
                    logicout <= reg1_i | reg2_i;
                end
                default: begin
                    logicout <= `ZeroWord;
                end
            endcase
        end // end if
    end     // end always

/*
    stage 2. by alusel_i, select a result as the final output. here's only logic result.
*/

    always @(*) begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        case(alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
            default: begin
                wdata_o <= `ZeroWord;
            end
        endcase 
    end

endmodule