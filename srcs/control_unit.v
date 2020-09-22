`timescale 1ns / 1ps
`include "defines.vh"

module control_unit(
         input wire                             rst,
         input wire [5:0]                       opcode, // Instruction opcode
         input wire [5:0]                       func,   // R-Type instruction function
         input wire                             isRsRtEq,

         output wire                            Regfile_weD,
         output wire                            DataMem_weD,
         output wire            extOpD,
         output wire [`NPC_OP_LENGTH]           npcOp,
         output wire [`ALU_OP_LENGTH]           aluOpD,
         output wire                            aluSrc1_muxD,
         output wire                            aluSrc2_muxD,
         output wire [`REG_SRC_LENGTH]          regSrc_muxD,
         output wire [`REG_DST_LENGTH]          regDst_muxD,
         output wire                            memToRegD // 是否为从内存加载到寄存器中的指令
       );
    wire [15:0] controlCode;
    assign controlCode = 
    (opcode == `OP_ZEROS && func == `FUNC_ADDU) ?  16'b1000010000011001:
    (opcode == `OP_ADDIU)? 16'b1000010001010101 :
    (opcode == `OP_ZEROS && func == `FUNC_SUBU)? 16'b1000101100011001 :
    (opcode == `OP_ZEROS && func == `FUNC_SLT)? 16'b1000110000011001 :
    (opcode == `OP_SLTI) ? 16'b1000110001010101  :
    (opcode == `OP_ZEROS && func == `FUNC_SLTU)? 16'b1000110100011001 :
    (opcode == `OP_SLTIU)? 16'b1000110101010101 :
    (opcode == `OP_LUI)?16'b1000111000011000  :
    (opcode == `OP_ZEROS && func == `FUNC_AND)? 16'b1000011100010100 :
    (opcode == `OP_ANDI)? 16'b1000011101010100 :
    (opcode == `OP_ZEROS && func == `FUNC_NOR)? 16'b1000100100011000 :
    (opcode == `OP_ZEROS && func == `FUNC_OR)? 16'b1000101000011000 :
    (opcode == `OP_ORI)? 16'b1000101001010100 :
    (opcode == `OP_ZEROS && func == `FUNC_XOR)? 16'b1000000100011000 :
    (opcode == `OP_XORI)? 16'b1000000101010100:
    16'h0000;

    assign Regfile_weD=controlCode[15];
    assign DataMem_weD=controlCode[14];
    assign npcOp=controlCode[13:12];
    assign aluOpD=controlCode[11:8];
    assign aluSrc1_muxD=controlCode[7];
    assign aluSrc2_muxD=controlCode[6];
    assign regSrc_muxD=controlCode[5:4];
    assign regDst_muxD=controlCode[3:2];
    assign memToRegD=controlCode[1];
    assign extOpD=controlCode[0];
endmodule
