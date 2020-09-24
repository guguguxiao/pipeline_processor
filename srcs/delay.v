`timescale 1ns / 1ps
`include "defines.vh"


module delay (
         input                    clk,
         input                    rst,
         input     [`WORD_WIDTH]  pcP,

         output reg [`WORD_WIDTH] pcF
       );

always @(posedge clk)
  begin
    if (!rst)
      begin
        pcF <= `PC_BASE;
      end
    else
      begin
        pcF <= pcP;
      end
  end

endmodule
