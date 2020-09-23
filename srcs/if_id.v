`timescale 1ns / 1ps
`include "defines.vh"

module if_id(
         input       clk,
         input       rst,

         input      [`WORD_WIDTH]   instrF,
         input                      stallD,
         input                      flushD,
         input      [`WORD_WIDTH]   pcF,

         output reg [`WORD_WIDTH]   instrD,
         output reg [`WORD_WIDTH]   pcD
       );

always @(posedge clk)
  begin
    if(!rst || flushD)
      begin
        instrD <= `ZERO_WORD;
        pcD <= `ZERO_WORD;
      end
    else if(stallD == 1'b1)
      begin
        instrD <= instrD;
        pcD <= pcD;
      end
    else
      begin
        instrD <= instrF;
        pcD <= pcF;
      end
  end
endmodule
