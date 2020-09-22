`timescale 1ns / 1ps
`include "defines.vh"
module PC(
         input                    clk,
         input                    rst,
         
         input                    stallF,
         input     [`WORD_WIDTH]  npc,
         output reg  [`WORD_WIDTH]  pc
       );

always @(posedge clk)
  begin
    if (!rst) 
      begin
        pc <= `PC_BASE;
      end
    else if(stallF == 1'b1)
      begin
        pc <= pc;
      end
    else
      begin
        pc <= npc;
      end
  end

endmodule
