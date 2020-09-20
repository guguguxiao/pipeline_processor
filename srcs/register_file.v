`timescale 1ns / 1ps
`include "defines.vh"

module register_file(
         input clk,

         input [`REG_SIZE]          rs,
         input [`REG_SIZE]          rt,
         input                      Regfile_we,
         input [`REG_SIZE]          writeAddr,
         input [`WORD_WIDTH]        writeData,

         output [`WORD_WIDTH]       readData1,
         output [`WORD_WIDTH]       readData2

       );
reg [`WORD_WIDTH] regs[`WORD_WIDTH];

assign readData1 = (rs == 5'b00000) ? `ZERO_WORD:
       (rs == writeAddr && Regfile_we == 1'b1) ? writeData:
       regs[rs];
assign readData2 = (rt == 5'b00000) ? `ZERO_WORD:
       (rt == writeAddr && Regfile_we == 1'b1) ? writeData:
       regs[rt];

always @(posedge clk)
  begin
    if(Regfile_we && writeAddr != 5'b00000)
      begin
        regs[writeAddr] <= writeData;
      end
  end

endmodule
