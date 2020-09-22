`timescale 1ns / 1ps
`include "defines.vh"

module fetch (
         input                      clk,
         input                      rst,
         input                      stallF,
         input [`WORD_WIDTH]        npc,

         output reg[`WORD_WIDTH]    pcF,
         output wire [`WORD_WIDTH]  instrF
       )
         ;

// if模块内部使用的pc线
wire [`WORD_WIDTH] pc;

PC PC(
     .clk(clk),
     .rst(rst),
     .stallF(stallF),
     .npc(npc),

     .pc(pc)
   );

instruction_memory instruction_memory(
                     .instr_addr(pc[11:2]),

                     .instrF(instrF)
                   );

// 传给模块id的pc
assign pcF = pc;

endmodule
