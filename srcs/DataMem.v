`timescale 1ns / 1ps
`include "defines.vh"

module  DataMem(
          input                     clk,
          input                     DataMem_we,
          input [`WORD_WIDTH]       addr,
          input [`WORD_WIDTH]       writeData,
          output[`WORD_WIDTH]       readData
        );

reg [7:0] data_ram[0:`DATARAMLINE-1];

// 减去mars中的地址基址
assign addr_offset = addr - `ADDR_BASE;

// read data ram
assign readData = {data_ram[addr_offset+3],data_ram[addr_offset+2],data_ram[addr_offset+1],data_ram[addr_offset]};

// write data ram
always @(posedge clk)
  begin
    if(DataMem_we)
      begin
        data_ram[addr_offset] <= writeData[7:0];
        data_ram[addr_offset+1] <= writeData[15:8];
        data_ram[addr_offset+2] <= writeData[23:16];
        data_ram[addr_offset+3] <= writeData[31:24];
      end
  end


endmodule
