`timescale 1ns / 1ps
`include "defines.vh"

module fetch (
         input                      clk,
         input                      rst,
         input                      stallF,
         input [`WORD_WIDTH]        npc,

         output [`WORD_WIDTH]    pcF,
         output [`WORD_WIDTH]  instrF
       );

// ifģ���ڲ�ʹ�õ�pc��
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

// ����ģ��id��pc
assign pcF = pc;

endmodule
