`timescale 1ns/1ps
`include "defines.v"
module openmips_min_sopc_tb();

reg CLOCK_50;
reg rst;

// invert the clk every 10ns. Thus, the period is 20ns. 50MHz
initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
end

// rst Enable for the first 195 ns, then SOPC start
// run for 1000ns
initial begin
    rst = `RstEnable;
    #195 rst = `RstDisable;
    #1000 $stop;
end

// materialize SOPC
openmips_min_sopc openmips_min_sopc0(
    .clk(CLOCK_50),
    .rst(rst)
);

endmodule