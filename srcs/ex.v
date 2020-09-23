`timescale 1ns / 1ps
`include "defines.vh"


module ex(
         input [1:0]                        forwardAE,
         input [1:0]                        forwardBE,
         input [`REG_SIZE]                  rtE,
         input [`REG_SIZE]                  rdE,
         input  [`ALU_OP_LENGTH]            aluOpE,
         input                              aluSrc1_muxE,
         input                              aluSrc2_muxE,
         input [15:0]                       imm16E,
         input wire [`REG_DST_LENGTH]       regDst_muxE,
         input [`WORD_WIDTH]                readData1E,
         input [`WORD_WIDTH]                readData2E,
         input [`WORD_WIDTH]                aluOutM,
         input [`WORD_WIDTH]                wbOut,
         input wire                         extOpE,

         output [`REG_SIZE]                 writeRegAddrE,
         output[`WORD_WIDTH]                aluOutE,
         output[`WORD_WIDTH]                writeDataE
       );
wire [`WORD_WIDTH]              data1;
wire [`WORD_WIDTH]              data2;
wire [`WORD_WIDTH]              data1_tmp;
wire [`WORD_WIDTH]              data2_tmp;

wire [`WORD_WIDTH] extend_immE = extOpE ? {{16{imm16E[15]}},imm16E[15:0]}
     :{{16{1'b0}}, imm16E[15:0]};

wire [`WORD_WIDTH] extend_saE = {{27{1'b0}},imm16E[10:6]};
assign data1_tmp = (forwardAE == 2'b01) ? aluOutM :
       (forwardAE == 2'b10) ? wbOut :
       readData1E;
assign data2_tmp = (forwardBE == 2'b01) ? aluOutM :
       (forwardBE == 2'b10) ? wbOut :
       readData2E;
assign data1 = (aluSrc1_muxE == `ALU_SRC1_MUX_SA) ? extend_saE : data1_tmp;
assign data2 = (aluSrc2_muxE == `ALU_SRC2_MUX_IMM) ? extend_immE :data2_tmp;
assign writeDataE = data2_tmp;
// ALU
ALU ALU(
      .aluOpE(aluOpE),
      .SrcA(data1),
      .SrcB(data2),
      .aluOutE(aluOutE)
    );
// Ð´¼Ä´æÆ÷Ñ¡Ôñ
assign writeRegAddrE = (regDst_muxE == `REG_DST_RT) ? rtE :
       (regDst_muxE == `REG_DST_RD) ? rdE:
       (regDst_muxE == `REG_DST_JAL) ? 5'b11111:
       5'b00000;

endmodule
