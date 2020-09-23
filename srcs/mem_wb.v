`timescale 1ns / 1ps
`include "defines.vh"

module mem_wb(
         input       clk,
         input       rst,
         input     Regfile_weM,
         input       [`WORD_WIDTH] readDataM,
         input       [`WORD_WIDTH]   aluOutM,
         input       [`REG_SIZE]  writeRegAddrM,
         input [`REG_SRC_LENGTH]       regSrc_muxM,
         input [`WORD_WIDTH]      jal_targetM,
         input [`WORD_WIDTH]      pcM,

         output reg              Regfile_weW,
         output reg [`WORD_WIDTH]    aluOutW,
         output reg [`REG_SRC_LENGTH]       regSrc_muxW,
         output reg [`WORD_WIDTH]  readDataW,
         output reg  [`REG_SIZE]  writeRegAddrW,
         output reg [`WORD_WIDTH]      jal_targetW,
         output reg [`WORD_WIDTH]   pcW
       );
always @(posedge clk)
  begin
    if (!rst)
      begin
        Regfile_weW<= 1'b0;
        aluOutW <= `ZERO_WORD;
        readDataW <= `ZERO_WORD;
        writeRegAddrW <= 5'b00000;
        regSrc_muxW <= 2'b00;
        jal_targetW <=  `ZERO_WORD;
        pcW <= `ZERO_WORD;
      end
    else
      begin
        Regfile_weW <= Regfile_weM;
        aluOutW <= aluOutM;
        readDataW <= readDataM;
        writeRegAddrW <= writeRegAddrM;
        regSrc_muxW <=regSrc_muxM;
        jal_targetW <=  jal_targetM;
        pcW <= pcM;
      end
  end
endmodule
