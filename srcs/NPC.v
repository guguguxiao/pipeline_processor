`timescale 1ns / 1ps
`include "defines.vh"

module NPC(
         input  wire [`WORD_WIDTH]           pc,
         input  wire [15:0]                  imm16,      // 16 bit immediate
         input  wire [25:0]                  imm26,      // 26 bit immediate

         input  wire [`NPC_OP_LENGTH]        npcOp,      //
         input  wire                         isRsRtEq,
         input  wire [`WORD_WIDTH]           reg1Data,   // jr指令的rs寄存器的值

         output wire [`WORD_WIDTH]           npc,        // next program counter
         output wire [`WORD_WIDTH]           jal_target,  //

         output                              isJump
       );

wire [`WORD_WIDTH] pc_4;
assign pc_4 = pc + 32'h4;

assign npc = (npcOp == `NPC_OP_JUMP) ? {pc_4[31:28], imm26, 2'b00} :                              // pc = target
       (npcOp == `NPC_OP_BEQ && isRsRtEq) ? {pc + {{14{imm16[15]}}, {imm16, 2'b00}}} - 4:      // pc + 4 + offset,soc此时的PC是下下条指令要减4
       (npcOp == `NPC_OP_BNE && !isRsRtEq) ? {pc + {{14{imm16[15]}}, {imm16, 2'b00}}} - 4:
       (npcOp == `NPC_OP_REG) ? reg1Data :                                                        // ps = [rs]
       pc_4;                                                                                      //  pc + 4


assign jal_target = pc;

// 如果要跳转，则一个周期不取指
assign isJump = ((npcOp == `NPC_OP_JUMP) | (npcOp == `NPC_OP_BEQ && isRsRtEq) | (npcOp == `NPC_OP_REG));

endmodule
