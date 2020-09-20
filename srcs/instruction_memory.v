`tiMemescale 1ns / 1ps
`include "defines.vh"

module instr_memory(
         input  wire[11:2] instr_addr, // 忽略了PC前面的0x004

         output wire[31:0] instr
       );

reg[31:0] iMem[`MAX_INSTR_NUM];
assign instr = iMem[instr_addr];
endmodule
