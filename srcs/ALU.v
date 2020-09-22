`timescale 1ns / 1ps
`include "defines.vh"

module ALU(
         input [`ALU_OP_LENGTH] aluOpE,
         input [`WORD_WIDTH]    SrcA,
         input [`WORD_WIDTH]    SrcB,
         output [`WORD_WIDTH]   aluOutE
       );
wire  [`WORD_WIDTH] and_res;
wire  [`WORD_WIDTH] sub_res;
wire  [`WORD_WIDTH] add_res;
wire  [`WORD_WIDTH] xor_res;
wire  [`WORD_WIDTH] nor_res;
wire  [`WORD_WIDTH] or_res;
wire  [`WORD_WIDTH] eqb_res;
wire  [`WORD_WIDTH] slt_res;
wire  [`WORD_WIDTH] sltu_res;
wire  [`WORD_WIDTH] ls_left_res;
wire  [`WORD_WIDTH] ls_right_res;
wire  [`WORD_WIDTH] as_right_res;

assign and_res= SrcA&SrcB;
assign sub_res= SrcA-SrcB;
assign add_res= SrcA+SrcB;
assign xor_res= SrcA^SrcB;
assign nor_res=~(SrcA | SrcB);
assign or_res=SrcA | SrcB;
assign eqb_res=SrcA;
assign slt_res=((SrcA[31] == 1'b1 && SrcB[31] == 1'b0 ) || (SrcA[31] == 1'b1 && SrcB[31] == 1'b1 && SrcA > SrcB) || (SrcA[31] == 1'b0 && SrcB[31] == 1'b0 && SrcA < SrcB))?
       32'h00000001: `ZERO_WORD;
assign sltu_res=({1'b0,SrcA} < {1'b0,SrcB}) ? 32'h00000001:`ZERO_WORD;

assign aluOutE = (aluOpE ==`ALU_ADD) ? and_res
       : (aluOpE ==`ALU_SUB) ? sub_res
       : (aluOpE ==`ALU_ADD) ? add_res
       : (aluOpE ==`ALU_XOR) ? xor_res
       : (aluOpE ==`ALU_NOR) ? nor_res
       : (aluOpE ==`ALU_OR)  ? or_res
       : (aluOpE ==`ALU_EQB) ? eqb_res
       : (aluOpE ==`ALU_SLT) ? slt_res
       : (aluOpE ==`ALU_SLTU) ? sltu_res
       : (aluOpE ==`ALU_LS_LEFT) ? (SrcB << (SrcA[4:0]))
       : (aluOpE ==`ALU_LS_RIGHT) ? (SrcB >> (SrcA[4:0]))
       : (aluOpE ==`ALU_AS_RIGHT) ? (({32{SrcB[31]}} << (6'd32-{1'b0,SrcA[4:0]})) | SrcB >> SrcA[4:0])
       : 32'h00000000;

endmodule
