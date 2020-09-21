`timescale 1ns / 1ps
`include "defines.vh"

module if (
         input                    clk,
         input                    rst,
         input                    stallF,
         input [`WORD_WIDTH]      npc,

         output reg[`WORD_WIDTH]  pcD,
         output wire[`WORD_WIDTH] instr
       )
         ;

// if模块内部使用的pc线
wire [`WORD_WIDTH] pc;

pc pc(
     .clk(clk),
     .rst(rst),
     .stallF(stallF),
     .npc(npc),

     .pc(pc)
   );

instruction_memory instruction_memory(
                     .instr_addr(pc),

                     .instr(instr)
                   );

// 传给模块id的pc
assign pcD = pc;

endmodule
