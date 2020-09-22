`timescale 1ns / 1ps
`include "defines.vh"

module instruction_memory(
         input  wire [11:2] instr_addr, // ������PCǰ���0x004

         output wire [`WORD_WIDTH] instrF
       );

reg[`WORD_WIDTH] iMem[`INSTR_SIZE];
assign instrF = iMem[instr_addr];
endmodule
