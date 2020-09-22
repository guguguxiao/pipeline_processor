`timescale 1ns / 1ps
`include "defines.vh"

module branch_judge(
         input  wire [`WORD_WIDTH]      reg1_data,
         input  wire [`WORD_WIDTH]      reg2_data,

         output wire                    isRsRtEq       // rs rt是否相等
       );

// rs - rt = diff
wire [32:0] diff = {reg1_data[31], reg1_data} - {reg2_data[31], reg2_data};

assign isRsRtEq = (diff == 0) ? 1'b1 : 1'b0;
endmodule
