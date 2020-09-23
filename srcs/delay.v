`timescale 1ns / 1ps
`include "defines.vh"


module delay (
         input                    clk,
         input                    rst,
         input     [`WORD_WIDTH]  pc_in,

         output reg [`WORD_WIDTH] pc_out
       );

always @(posedge clk)
  begin
    if (!rst)
      begin
        pc_out <= `PC_BASE;
      end
    else
      begin
        pc_out <= pc_in;
      end
  end

endmodule
