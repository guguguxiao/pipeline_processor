`timescale 1ns / 1ps
`include "defines.vh"

module if_id(
         input       clk,
         input       rst,

         input      [`WORD_WIDTH]   instrF,
         input                      stallD,
         input                      flushD,
         output reg [`WORD_WIDTH]   instrD
       );

always @(posedge clk)
  begin
    if(rst || flushD)
      begin
        instrD <= `ZERO_WORD;
      end
    else if(stallD == 1'b1)
      begin
        instrD <= instrD;
      end
    else
      begin
        instrD <= instrF;
      end
  end
endmodule
