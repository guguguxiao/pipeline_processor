`timescale 1ns / 1ps
`include "defines.vh"

module soc (
         input clk,
         input rst
       );

wire                resetn;
wire                clk;
wire  [5:0]         INT;
wire  [`WORD_WIDTH] inst_sram_rdata;
wire  [`WORD_WIDTH] data_sram_rdata;
wire                inst_sram_en;
wire  [3:0]         inst_sram_wen;
wire  [`WORD_WIDTH] inst_sram_addr;
wire  [`WORD_WIDTH] inst_sram_wdata;
wire                data_sram_en;
wire  [3:0]         data_sram_wen;
wire  [`WORD_WIDTH] data_sram_addr;
wire  [`WORD_WIDTH] data_sram_wdata;
wire  [`WORD_WIDTH] debug_wb_pc;
wire  [`WORD_WIDTH] debug_wb_rf_wen;
wire  [`WORD_WIDTH] debug_wb_rf_wnum;
wire  [`WORD_WIDTH] debug_wb_rf_wdata;

assign resetn = !rst;

cpu cpu(
      .resetn(resetn),
      .clk(clk),
      .INT(INT),
      .inst_sram_rdata(inst_sram_rdata),
      .data_sram_rdata(data_sram_rdata),

      .inst_sram_en(inst_sram_en),
      .inst_sram_wen(inst_sram_wen),
      .inst_sram_addr(inst_sram_addr),
      .inst_sram_wdata(inst_sram_wdata),
      .data_sram_en(data_sram_en),
      .data_sram_wen(data_sram_wen),
      .data_sram_addr(data_sram_addr),
      .data_sram_wdata(data_sram_wdata),
      .debug_wb_pc(debug_wb_pc),
      .debug_wb_rf_wen(debug_wb_rf_wen),
      .debug_wb_rf_wnum(debug_wb_rf_wnum),
      .debug_wb_rf_wdata(debug_wb_rf_wdata)
    );

instruction_memory instruction_memory (
    .instr_addr(inst_sram_addr),

    .instrF(inst_sram_rdata)
);

DataMem DateMem(
    .clk(clk),
    .DataMem_we(data_sram_en),
    .addr(data_sram_addr),
    .writeData(data_sram_wdata),

    .readData(inst_sram_rdata)
);

endmodule
