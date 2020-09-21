`timescale 1ns / 1ps
`include "defines.vh"

module register_file(
         input clk,

         input [`REG_SIZE]          rs,
         input [`REG_SIZE]          rt,
         input                      Regfile_weW,
         input [`REG_SIZE]          writeRegAddrW,
         input [`WORD_WIDTH]        writeDataW,

         output [`WORD_WIDTH]       readData1D,
         output [`WORD_WIDTH]       readData2D

       );
reg [`WORD_WIDTH] regs[`WORD_WIDTH];

assign readData1D = (rs == 5'b00000) ? `ZERO_WORD:
       (rs == writeRegAddrW && Regfile_weW == 1'b1) ? writeDataW:
       regs[rs];
assign readData2D = (rt == 5'b00000) ? `ZERO_WORD:
       (rt == writeRegAddrW && Regfile_weW == 1'b1) ? writeDataW:
       regs[rt];

always @(posedge clk)
  begin
    if(Regfile_weW && writeRegAddrW != 5'b00000)
      begin
        regs[writeRegAddrW] <= writeDataW;
      end
  end

endmodule
