`timescale 1ns / 1ps
`include "defines.vh"

module register_file(
         input clk,

         input [`REG_SIZE]          reg1_addr,
         input [`REG_SIZE]          reg2_addr,
         input                      Regfile_weW,
         input [`REG_SIZE]          writeRegAddrW,
         input [`WORD_WIDTH]        writeDataW,

         output [`WORD_WIDTH]       readData1,
         output [`WORD_WIDTH]       readData2

       );
reg [`WORD_WIDTH] regs[`WORD_WIDTH];

assign readData1 = (reg1_addr == 5'b00000) ? `ZERO_WORD:
       (reg1_addr == writeRegAddrW && Regfile_weW == 1'b1) ? writeDataW:
       regs[reg1_addr];
assign readData2 = (reg2_addr == 5'b00000) ? `ZERO_WORD:
       (reg2_addr == writeRegAddrW && Regfile_weW == 1'b1) ? writeDataW:
       regs[reg2_addr];

always @(posedge clk)
  begin
    if(Regfile_weW && writeRegAddrW != 5'b00000)
      begin
        regs[writeRegAddrW] <= writeDataW;
      end
  end

endmodule
