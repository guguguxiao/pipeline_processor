`timescale 1ns / 1ps
`include "defines.vh"

module npc(
         input  wire[`WORD_WIDTH]           pc,
         input  wire[15:0]                  imm16,     // 16 bit immediate
         input  wire[25:0]                  imm26,     // 26 bit immediate

         input  wire[`NPC_OP_LENGTH]        npcOp,     // 跳转控制信号

         output wire[`WORD_WIDTH]           npc       // next program counter
       );

wire[`WORD_WIDTH] pc_4;
assign pc_4 = pc + 32'h4;

assign npc = (npcOp == `NPC_OP_JUMP  ) ? {pc_4[31:28], imm26, 2'b00} :                  // pc = target
       (npcOp == `NPC_OP_OFFSET) ? {pc_4 + {{14{imm16[15]}}, {imm16, 2'b00}}} : // pc + 4 + offset
       pc_4;                                                                        // fallback mode: pc + 4
endmodule
