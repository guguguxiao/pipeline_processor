`timescale 1ns / 1ps
`include "defines.vh"

module id_ex(
         input                                  clk,
         input                                  rst,
         input [`REG_SIZE]                      rsD,
         input [`REG_SIZE]                      rtD,
         input [`REG_SIZE]                      rdD,
         input [15:0]                           imm16D,
         input wire                             Regfile_weD,
         input wire                             DataMem_weD,
         input wire                             extOpD,
         input wire [`ALU_OP_LENGTH]            aluOpD,
         input wire                             aluSrc1_muxD,
         input wire                             aluSrc2_muxD,
         input wire [`REG_SRC_LENGTH]           regSrc_muxD,
         input wire [`REG_DST_LENGTH]           regDst_muxD,
         input wire [`WORD_WIDTH]               readData1D,
         input wire [`WORD_WIDTH]               readData2D,
         input                                  flushE,
         input wire [`WORD_WIDTH]               jal_targetD,
         input wire [`WORD_WIDTH]               pcD,

         output reg [`REG_SIZE]                     rsE,
         output reg [`REG_SIZE]                     rtE,
         output reg [`REG_SIZE]                     rdE,
         output reg [15:0]                          imm16E,
         output reg                             Regfile_weE,
         output reg                             DataMem_weE,
         output reg                             extOpE,
         output reg  [`ALU_OP_LENGTH]           aluOpE,
         output reg                             aluSrc1_muxE,
         output reg                             aluSrc2_muxE,
         output reg  [`REG_SRC_LENGTH]          regSrc_muxE,
         output reg  [`REG_DST_LENGTH]          regDst_muxE,
         output reg [`WORD_WIDTH]                   readData1E,
         output reg [`WORD_WIDTH]                   readData2E,
         output reg [`WORD_WIDTH]                    jal_targetE,
         output reg [`WORD_WIDTH]               pcE
       );

always @(posedge clk)
  begin
    if(!rst || flushE == 1'b1)
      begin
        rsE <= 5'b00000;
        rtE <= 5'b00000;
        rdE <= 5'b00000;
        imm16E <= 16'h0000;
        Regfile_weE <= 1'b0;
        DataMem_weE <= 1'b0;
        extOpE <= 1'b0;
        aluOpE <= 4'h0;
        aluSrc1_muxE <= 1'b0;
        aluSrc2_muxE <= 1'b0;
        regSrc_muxE <= 2'b00;
        regDst_muxE <= 2'b00;
        readData1E <= `ZERO_WORD;
        readData2E<= `ZERO_WORD;
        jal_targetE <= `ZERO_WORD;
        pcE <= `ZERO_WORD;
      end
    else
      begin
        rsE <= rsD;
        rtE <= rtD;
        rdE <= rdD;
        imm16E <= imm16D;
        Regfile_weE <= Regfile_weD;
        DataMem_weE <= DataMem_weD;
        extOpE <= extOpD;
        aluOpE <= aluOpD;
        aluSrc1_muxE <= aluSrc1_muxD;
        aluSrc2_muxE <= aluSrc2_muxD;
        regSrc_muxE <= regSrc_muxD;
        regDst_muxE <= regDst_muxD;
        readData1E <= readData1D;
        readData2E <= readData2D;
        jal_targetE <= jal_targetD;
        pcE <= pcD;
      end
  end

endmodule
