`include "defines.v"
module pc_reg(
    input   wire                clk,
    input   wire                rst,
    output  reg[`InstAddrBus]    pc,
    output  reg                 ce
);
    always @(posedge clk) begin
        if(rst == `RstEnable) begin
            ce <= `ChipDisable;     // reset enable -> chip disable
        end
        else begin
            ce <= `ChipEnable;
        end
    end

    always @(posedge clk) begin
        if(ce == `ChipDisable) begin
            pc <= 32'h0;
        end
        else begin
            pc <= pc + 4'h4;       // each clock jump 4 bytes, because this is a 32-bits CPU
        end
    end

endmodule
