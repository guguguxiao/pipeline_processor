`timescale 1ns / 1ps
`include "defines.vh"

module control_unit(
         input wire                             rst,
         input wire [5:0]                       opcode, // Instruction opcode
         input wire [5:0]                       func,   // R-Type instruction function
         input wire                             isRsRtEq,

         output wire                            Regfile_weD,
         output wire                            DataMem_weD,
         output wire                            extOpD,
         output wire [`NPC_OP_LENGTH]           npcOp,
         output wire [`ALU_OP_LENGTH]           aluOpD,
         output wire                            aluSrc1_muxD,
         output wire                            aluSrc2_muxD,
         output wire [`REG_SRC_LENGTH]          regSrc_muxD,
         output wire [`REG_DST_LENGTH]          regDst_muxD
       );
wire [15:0] controlCode;
assign controlCode =
       (opcode == `OP_ZEROS && func == `FUNC_ADDU) ?   15'b100001000001101 :
       (opcode == `OP_ADDIU)?                          15'b100001000101011 :
       (opcode == `OP_ZEROS && func == `FUNC_SUBU)?    15'b100010110001101 :
       (opcode == `OP_ZEROS && func == `FUNC_SLT)?     15'b100011000001101 :
       (opcode == `OP_SLTI) ?                          15'b100011000101011 :
       (opcode == `OP_ZEROS && func == `FUNC_SLTU)?    15'b100011010001101 :
       (opcode == `OP_SLTIU)?                          15'b100011010101011 :
       (opcode == `OP_LUI)?                            15'b100011100101010 :
       (opcode == `OP_ZEROS && func == `FUNC_AND)?     15'b100001110001100 :
       (opcode == `OP_ANDI)?                           15'b100001110101010 :
       (opcode == `OP_ZEROS && func == `FUNC_NOR)?     15'b100010010001100 :
       (opcode == `OP_ZEROS && func == `FUNC_OR)?      15'b100010100001100 :
       (opcode == `OP_ORI)?                            15'b100010100101010 :
       (opcode == `OP_ZEROS && func == `FUNC_XOR)?     15'b100000010001100 :
       (opcode == `OP_XORI)?                           15'b100000010101010:
       15'b000000000000000;

assign Regfile_weD=controlCode[14];
assign DataMem_weD=controlCode[13];
// TODO:��Ҫ����isRsRteq
assign npcOp=controlCode[12:11];
assign aluOpD=controlCode[10:7];
assign aluSrc1_muxD=controlCode[6];
assign aluSrc2_muxD=controlCode[5];
assign regSrc_muxD=controlCode[4:3];
assign regDst_muxD=controlCode[2:1];

assign extOpD=controlCode[0];
endmodule
