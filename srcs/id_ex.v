`timescale 1ns / 1ps
`include "defines.vh"

module id_ex(
         input clk,
         input rst,
         input [`REG_SIZE]                  rsD,
         input [`REG_SIZE]                  rtD,
         input [`REG_SIZE]                  rdD,
         input [15:0]                       imm16D,
         input [4:0]                        saD,
         input wire                         Regfile_weD,
         input wire                         DataMem_weD,
         input wire[`EXT_OP_LENGTH]         extOp,
         input wire[`ALU_OP_LENGTH]         aluOpD,
         input wire                         aluSrc_muxD,
         input wire[`REG_SRC_LENGTH]        regSrc_muxD,
         input wire[`REG_DST_LENGTH]        regDst_muxD,
         input [`WORD_WIDTH]                readData1D,
         input [`WORD_WIDTH]                readData2D,
         input                              flushE,

         output [`REG_SIZE]                 rsE,
         output [`REG_SIZE]                 rtE,
         output [`REG_SIZE]                 rdE,
         output [15:0]                      imm16E,
         output [4:0]                       saE,
         output wire                        Regfile_weE,
         output wire                        DataMem_weE,
         output wire[`EXT_OP_LENGTH]        extOE,
         output wire[`ALU_OP_LENGTH]        aluOpE,
         output wire                        aluSrc_muxE,
         output wire[`REG_SRC_LENGTH]       regSrc_muxE,
         output wire[`REG_DST_LENGTH]       regDst_muxE,
         output [`WORD_WIDTH]               readData1E,
         output [`WORD_WIDTH]               readData2E,
       );

always @(posedge clk)
  begin
    if(rst || flushE == 1'b1)
      begin
        rsE <= 5'b00000;
        rtE <= 5'b00000;
        rdE <= 5'b00000;
        imm16E <= 16'h0000;
        saE <= 5'b00000;
        Regfile_weE <= 1'b0;
        DataMem_weE <= 1'b0;
        extOE <= 2'b00;
        aluOpE <= 4'h0;
        aluSrc_muxE <= 1'b0;
        regSrc_muxE <= 2'b00;
        regDst_muxE <= 2'b00;
        readData1E <= `ZERO_WORD;
        readData2E<= `ZERO_WORD;
      end
    else
      begin
        rsE <= rsD;
        rtE <= rtD;
        rdE <= rdD;
        imm16E <= imm16D;
        saE <= saD;
        Regfile_weE <= Regfile_weD;
        DataMem_weE <= DataMem_weD;
        extOE <= extOD;
        aluOpE <= aluOpD;
        aluSrc_muxE <= aluSrc_muxD;
        regSrc_muxE <= regSrc_muxD;
        regDst_muxE <= regDst_muxD;
        readData1E <= readData1D;
        readData2E <= readData2D;
      end
  end

endmodule
