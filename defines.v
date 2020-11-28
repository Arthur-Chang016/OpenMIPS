// *** overall macro defines ***
`define RstEnable       1'b1
`define RstDisable      1'b0
`define ZeroWord        32'h0
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define AluOpBus        7:0
`define AluSelBus       2:0
`define InstValid       1'b0
`define InstInvalid     1'b1
`define True_v          1'b1
`define False_v         1'b0
`define ChipEnable      1'b1
`define ChipDisable     1'b0


// *** Concrete instructions related macro defines ***
`define EXE_ORI         6'b001101   // ori instruction
`define EXE_NOP         6'b000000

// AluOp
`define EXE_OR_OP       8'b00100101
`define EXE_NOP_OP      8'b00000000

// AluSel
`define EXE_RES_LOGIC   3'b001

`define EXE_RES_NOP     3'b000


// *** Instruction ROM related macro defines ***
`define InstAddrBus     31:0
`define InstBus         31:0
`define InstMemNum      131071      // ROM : 128kB -> 128 * 1024 = 131072
`define InstMemNumLog2  17


// *** GPRs related macro defines ***
`define RegAddrBus      4:0         // width of bus address   2 ^ 5 = 32
`define RegBus          31:0        // width of bus
`define RegWidth        32
`define DoubleRegWidth  64
`define DoubleRegBus    63:0
`define RegNum          32
`define RegNumLog2      5
`define NOPRegAddr      5'b00000