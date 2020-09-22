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


// 算数运算指令
    wire is_addu;
    wire is_addiu;
    wire is_subu;
    wire is_slt;
    wire is_slti;
    wire is_sltu;
    wire is_sltiu;
    wire is_algor_instr;

    assign is_addu = (opcode == `OP_ZEROS && func == `FUNC_ADDU);
    assign is_addiu= (opcode == `OP_ADDIU);
    assign is_subu = (opcode == `OP_ZEROS && func == `FUNC_SUBU);
    assign is_slt  = (opcode == `OP_ZEROS && func == `FUNC_SLT);
    assign is_slti = (opcode == `OP_SLTI);
    assign is_sltu = (opcode == `OP_ZEROS && func == `FUNC_SLTU);
    assign is_sltiu= (opcode == `OP_SLTIU);
    assign is_algor_instr = (is_addu|| is_addiu||is_subu|| is_slt|| is_slti|| is_sltu|| is_sltiu);
    
    //逻辑运算指令
    wire is_lui;
    wire is_and;
    wire is_andi;
    wire is_nor;
    wire is_or;
    wire is_ori;
    wire is_xor;
    wire is_xori;
    wire is_logic_instr;
  
    assign is_lui   = (opcode == `OP_LUI);
    assign is_and   = (opcode == `OP_ZEROS && func == `FUNC_AND);
    assign is_andi  = (opcode == `OP_ANDI);
    assign is_nor   = (opcode == `OP_ZEROS && func == `FUNC_NOR);
    assign is_or    = (opcode == `OP_ZEROS && func == `FUNC_OR);                                        
    assign is_ori   = (opcode == `OP_ORI);
    assign is_xor   = (opcode == `OP_ZEROS && func == `FUNC_XOR);
    assign is_xori  = (opcode == `OP_XORI);
    assign is_logic_instr = (is_xor || is_lui || is_and || is_andi || is_nor||is_or || is_ori ||is_xor || is_xori);
    
    //移位指令
    wire is_sllv;
    wire is_sll;
    wire is_srav;
    wire is_sra;
    wire is_srlv;
    wire is_srl;
    wire is_shift_instr;

    assign is_sllv  = (opcode == `OP_ZEROS && func == `FUNC_SLLV);
    assign is_sll  = (opcode == `OP_ZEROS && func == `FUNC_SLL);
    assign is_srav  = (opcode == `OP_ZEROS && func == `FUNC_SRAV);
    assign is_sra  = (opcode == `OP_ZEROS && func == `FUNC_SRA);
    assign is_srlv  = (opcode == `OP_ZEROS && func == `FUNC_SRLV);
    assign is_srl  = (opcode == `OP_ZEROS && func == `FUNC_SRL);
    assign is_shift_instr = (is_sllv || is_sll || is_srav || is_sra || is_srlv || is_srl);
 
    //分支跳转指令
    wire is_beq;
    wire is_bne;
    wire is_j;

    assign is_beq   = (opcode == `OP_BEQ);
    assign is_bne   = (opcode == `OP_BNE);
    assign is_j     = (opcode == `OP_J);

    //访存指令
    wire is_lw;
    wire is_sw;
    assign is_sw    = (opcode == `OP_SW);
    assign is_lw    = (opcode == `OP_LW);

    assign memToRegD=is_lw;

endmodule
