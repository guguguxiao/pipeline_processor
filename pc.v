`timescale 1ns / 1ps
`include "defines.vh"
module PC(
         input                 clk,
         input                 rst,
         input            installF,
         input     [`WORDSIZE] npc,
         output reg[`WORDSIZE]  pc,
       );

always @(posedge clk)
  begin
    if(rst)
      begin
        pc <= `PCBASE;
      end
    else if(installF == 1'b1)
      begin
        pc <= pc;
      end
    else
      begin
        pc <= npc;
      end
  end

assign exceptionF = (pc[1:0] == 2'b00) ? 9'h000:9'h002;
endmodule
