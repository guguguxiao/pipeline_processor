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
wire [`CTRL_CODE_LEN] controlCode;
assign controlCode =
       (opcode == `OP_ZEROS && func == `FUNC_ADD) ?    16'b1000001000001101 :
       (opcode == `OP_ADDI)?                           16'b1000001000101011 :
       (opcode == `OP_ZEROS && func == `FUNC_ADDU) ?   16'b1000001000001101 :
       (opcode == `OP_ADDIU)?                          16'b1000001000101011 :
       (opcode == `OP_ZEROS && func == `FUNC_SUB)?     16'b1000010110001101 :
       (opcode == `OP_ZEROS && func == `FUNC_SUBU)?    16'b1000010110001101 :
       (opcode == `OP_ZEROS && func == `FUNC_SLT)?     16'b1000011000001101 :
       (opcode == `OP_SLTI) ?                          16'b1000011000101011 :
       (opcode == `OP_ZEROS && func == `FUNC_SLTU)?    16'b1000011010001101 :
       (opcode == `OP_SLTIU)?                          16'b1000011010101011 :

       (opcode == `OP_LUI)?                            16'b1000011100101010 :
       (opcode == `OP_ZEROS && func == `FUNC_AND)?     16'b1000001110001100 :
       (opcode == `OP_ANDI)?                           16'b1000001110101010 :
       (opcode == `OP_ZEROS && func == `FUNC_NOR)?     16'b1000010010001100 :
       (opcode == `OP_ZEROS && func == `FUNC_OR)?      16'b1000010100001100 :
       (opcode == `OP_ORI)?                            16'b1000010100101010 :
       (opcode == `OP_ZEROS && func == `FUNC_XOR)?     16'b1000000010001100 :
       (opcode == `OP_XORI)?                           16'b1000000010101010 :

       (opcode == `OP_ZEROS && func == `FUNC_SLLV)?    16'b1000000110001101:
       (opcode == `OP_ZEROS && func == `FUNC_SLL)?     16'b1000000111001101:
       (opcode == `OP_ZEROS && func == `FUNC_SRAV)?    16'b1000001011001101:
       (opcode == `OP_ZEROS && func == `FUNC_SRA)?     16'b1000001011001101:
       (opcode == `OP_ZEROS && func == `FUNC_SRLV)?    16'b1000001101001101:
       (opcode == `OP_ZEROS && func == `FUNC_SRL)?     16'b1000001101001101:


       (opcode == `OP_BEQ)?                            16'b0001000000000000 :
       (opcode == `OP_BNE)?                            16'b0010000000000000 :
       (opcode == `OP_J)?                              16'b0000100000000000 :
       (opcode == `OP_JAL)?                            16'b1000100000011110 :
       (opcode == `OP_ZEROS && func==`FUNC_JR)?        16'b0001100000000000 :

       (opcode == `OP_SW)?                             16'b0100001000100001 :
       (opcode == `OP_LW)?                             16'b1000001000110011 :
       16'b000000000000000;

assign Regfile_weD=controlCode[15];
assign DataMem_weD=controlCode[14];
assign npcOp=controlCode[13:11];
assign aluOpD=controlCode[10:7];
assign aluSrc1_muxD=controlCode[6];
assign aluSrc2_muxD=controlCode[5];
assign regSrc_muxD=controlCode[4:3];
assign regDst_muxD=controlCode[2:1];

assign extOpD=controlCode[0];
endmodule
