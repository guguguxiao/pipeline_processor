`timescale 1ns / 1ps
`include "defines.vh"

module cpu (
         input   resetn,                            // 复位信号（低使能
         input   clk,
         input   [5:0] INT,                         // 中断信号（高使能，本实验中可以忽略）
         input   [`WORD_WIDTH] inst_sram_rdata,     // 读取的指令
         input   [`WORD_WIDTH] data_sram_rdata,     // 读取的数据

         output  inst_sram_en,                      // 指令通道使能
         output  [3:0] inst_sram_wen,               // 是否写数据（总为 4'b0000）
         output  [`WORD_WIDTH] inst_sram_addr,      // 指令地址
         output  [`WORD_WIDTH] inst_sram_wdata,     // 写入的数据（不需要）

         output  data_sram_en,                      // 数据通道使能
         output  [3:0] data_sram_wen,               // 写入地址的有效字节，比如 4'b1111 表示 32 位全有效、 4'b0001 只会写入最低 8 位
         output  [`WORD_WIDTH] data_sram_addr,      // 数据地址
         output  [`WORD_WIDTH] data_sram_wdata,     // 写入的数据（只有 data_sram_wen 为 1 时有意义）

         output  [`WORD_WIDTH] debug_wb_pc,         // 写回级(多周期最后一级)的 PC,因而需要在你的 CPU 里将 PC 一路带到写回级
         output  [`WORD_WIDTH] debug_wb_rf_wen,     // 写回级写寄存器堆(regfiles)的写使能,为字节写使能,如果 mycpu 写 regfiles为单字节写使能,则将写使能扩展成 4 位即可
         output  [`WORD_WIDTH] debug_wb_rf_wnum,    // 写回级写 regfiles 的目的寄存器号
         output  [`WORD_WIDTH] debug_wb_rf_wdata    // 写回级写 regfiles 的写数据
       );

// 取指使能恒为1，stall的时候PC的值会维持不变
assign inst_sram_en = 1'b1;
assign inst_sram_wen = 4'b0000;
assign inst_sram_wdata = `ZERO_WORD;
assign data_sram_wen = 4'b1111;

// soc测试的rst与cpu的rst信号相反
wire rst;
assign rst = !resetn;

wire                        stallF;
wire [`WORD_WIDTH]          npc;
wire [`WORD_WIDTH]          instrF;


wire                        flushD;
wire                        stallD;
wire [`WORD_WIDTH]          instrD;
wire                        Regfile_weW;
wire [`WORD_WIDTH]          wbOut;
wire [`WORD_WIDTH]          aluOutM;
wire                        Regfile_weD;
wire                        DataMem_weD;
wire                        extOpD;
wire [`ALU_OP_LENGTH]       aluOpD;
wire                        aluSrc1_muxD;
wire                        aluSrc2_muxD;
wire [`REG_SRC_LENGTH]      regSrc_muxD;
wire [`REG_DST_LENGTH]      regDst_muxD;
wire [`WORD_WIDTH]          readData1D;
wire [`WORD_WIDTH]          readData2D;
wire [`REG_SIZE]            rsD;
wire [`REG_SIZE]            rtD;
wire [`REG_SIZE]            rdD;
wire [15:0]                 imm16D;
wire                        forwardAD;
wire                        forwardBD;
wire [`NPC_OP_LENGTH]       npcOpD;

wire [`WORD_WIDTH]          jal_targetD;
wire [`WORD_WIDTH]          jal_targetE;
wire [`WORD_WIDTH]          jal_targetM;
wire [`WORD_WIDTH]          jal_targetW;


wire [`REG_SIZE]            rsE;
wire  [`REG_SIZE]           rtE;
wire  [`REG_SIZE]           rdE;
wire  [15:0]                imm16E;
wire                        Regfile_weE;
wire                        DataMem_weE;
wire                        extOpE;
wire [`ALU_OP_LENGTH]       aluOpE;
wire                        aluSrc1_muxE;
wire                        aluSrc2_muxE;
wire [`REG_SRC_LENGTH]      regSrc_muxE;
wire [`REG_DST_LENGTH]      regDst_muxE;
wire  [`WORD_WIDTH]         readData1E;
wire  [`WORD_WIDTH]         readData2E;
wire                        flushE;


wire [1:0]                  forwardAE;
wire [1:0]                  forwardBE;
wire [`REG_SIZE]            writeRegAddrE;
wire [`WORD_WIDTH]          aluOutE;
wire [`WORD_WIDTH]          writeDataE;


wire                        Regfile_weM;
wire                        DataMem_weM;
wire [`REG_SIZE]            writeRegAddrM;
wire [`WORD_WIDTH]          writeDataM;
wire [`REG_SRC_LENGTH]      regSrc_muxM;

wire [`WORD_WIDTH]          readDataM;


wire      [`WORD_WIDTH]     readDataW;
wire      [`REG_SIZE]       writeRegAddrW;
wire     [`WORD_WIDTH]      aluOutW;
wire [`REG_SRC_LENGTH]      regSrc_muxW;

wire      [`WORD_WIDTH]     pc_in;
wire      [`WORD_WIDTH]     pcF;
wire      [`WORD_WIDTH]     pcD;
wire      [`WORD_WIDTH]     pcE;
wire      [`WORD_WIDTH]     pcM;
wire      [`WORD_WIDTH]     pcW;
wire      [`WORD_WIDTH]     pc_delay;

PC PC(
     .clk(clk),
     .rst(rst),
     .stallF(stallF),
     .npc(npc),

     .pc(pc_in)
   );

assign inst_sram_addr = pc_in;

// 延迟pc一个周期才能和传到后面的指令匹配，因为soc相当于是六级流水
delay delay (
        .clk(clk),
        .rst(rst),

        .pc_in(pc_in),
        .pc_out(pcF)
      );

// 采用soc测试的时候，指令从instr rom读出，要等一个周期

if_id if_id(
        .clk(clk),
        .rst(rst),
        .stallD(stallD),
        .instrF(data_sram_rdata),
        .flushD(flushD),
        .pcF(pcF),

        .instrD(instrD),
        .pcD(pcD)
      );

id id(
     .clk(clk),
     .rst(rst),
     .instrD(instrD),
     .pcF(pcF),
     .Regfile_weW(Regfile_weW),
     .wbOut(wbOut),
     .writeRegAddrW(writeRegAddrW),
     .aluOutM(aluOutM),
     .forwardAD(forwardAD),
     .forwardBD(forwardBD),

     .npc(npc),
     .Regfile_weD(Regfile_weD),
     .DataMem_weD(DataMem_weD),
     .extOpD(extOpD),
     .aluOpD(aluOpD),
     .aluSrc1_muxD(aluSrc1_muxD),
     .aluSrc2_muxD(aluSrc2_muxD),
     .regSrc_muxD(regSrc_muxD),
     .regDst_muxD(regDst_muxD),
     .npcOpD(npcOpD),
     .readData1D(readData1D),
     .readData2D(readData2D),
     .rsD(rsD),
     .rtD(rtD),
     .rdD(rdD),
     .imm16D(imm16D),

     .jal_targetD(jal_targetD)
   );



id_ex id_ex(
        .clk(clk),
        .rst(rst),
        .rsD(rsD),
        .rtD(rtD),
        .rdD(rdD),
        .imm16D(imm16D),
        .Regfile_weD(Regfile_weD),
        .DataMem_weD(DataMem_weD),
        .extOpD(extOpD),
        .aluOpD(aluOpD),
        .aluSrc1_muxD(aluSrc1_muxD),
        .aluSrc2_muxD(aluSrc2_muxD),
        .regSrc_muxD(regSrc_muxD),
        .regDst_muxD(regDst_muxD),
        .readData1D(readData1D),
        .readData2D(readData2D),
        .flushE(flushE),
        .jal_targetD(jal_targetD),
        .pcD(pcD),

        .rsE(rsE),
        .rtE(rtE),
        .rdE(rdE),
        .imm16E(imm16E),
        .Regfile_weE(Regfile_weE),
        .DataMem_weE(DataMem_weE),
        .extOpE(extOpE),
        .aluOpE(aluOpE),
        .aluSrc1_muxE(aluSrc1_muxE),
        .aluSrc2_muxE(aluSrc2_muxE),
        .regSrc_muxE(regSrc_muxE),
        .regDst_muxE(regDst_muxE),
        .readData1E(readData1E),
        .readData2E(readData2E),
        .jal_targetE(jal_targetE),
        .pcE(pcE)
      );

ex ex(
     .forwardAE(forwardAE),
     .forwardBE(forwardBE),
     .rtE(rtE),
     .rdE(rdE),
     .aluOpE(aluOpE),
     .aluSrc1_muxE(aluSrc1_muxE),
     .aluSrc2_muxE(aluSrc2_muxE),
     .imm16E(imm16E),
     .regDst_muxE(regDst_muxE),
     .readData1E(readData1E),
     .readData2E(readData2E),
     .aluOutM(aluOutM),
     .wbOut(wbOut),
     .extOpE(extOpE),
     .writeRegAddrE(writeRegAddrE),
     .aluOutE(aluOutE),
     .writeDataE(writeDataE)
   );

ex_mem ex_mem(
         .clk(clk),
         .rst(rst),
         .Regfile_weE(Regfile_weE),
         .DataMem_weE(DataMem_weE),
         .writeRegAddrE(writeRegAddrE),
         .aluOutE(aluOutE),
         .writeDataE(writeDataE),
         .regSrc_muxE(regSrc_muxE),
         .jal_targetE(jal_targetE),
         .pcE(pcE),

         .Regfile_weM(Regfile_weM),
         .DataMem_weM(data_sram_en),
         .writeRegAddrM(writeRegAddrM),
         .regSrc_muxM(regSrc_muxM),
         .aluOutM(data_sram_addr),
         .writeDataM(data_sram_wdata),
         .jal_targetM(jal_targetM),
         .pcM(pcM)
       );


// MEM


mem_wb mem_wb(
         .clk(clk),
         .rst(rst),
         .Regfile_weM(Regfile_weM),
         .readDataM(data_sram_rdata),
         .aluOutM(aluOutM),
         .writeRegAddrM(writeRegAddrM),
         .regSrc_muxM(regSrc_muxM),
         .jal_targetM(jal_targetM),
         .pcM(pcM),

         .Regfile_weW(Regfile_weW),
         .aluOutW(aluOutW),
         .regSrc_muxW(regSrc_muxW),
         .readDataW(readDataW),
         .writeRegAddrW(writeRegAddrW),
         .jal_targetW(jal_targetW),
         .pcW(pcW)
       );

assign wbOut=(regSrc_muxW == `REG_SRC_ALU) ? aluOutW :
       (regSrc_muxW == `REG_SRC_MEM) ? readDataW :
       (regSrc_muxW==`REG_SRC_JAL) ? jal_targetW :
       `ZERO_WORD;

assign debug_wb_rf_wnum = writeRegAddrW;
assign debug_wb_rf_wdata = wbOut;
assign debug_wb_rf_wen = Regfile_weW ? 4'b1111 : 4'b0000;
assign debug_wb_pc = pcW;

forward_unit forward_unit(
               .rsD(rsD),
               .rtD(rtD),
               .rsE(rsE),
               .rtE(rtE),
               .writeRegAddrM(writeRegAddrM),
               .writeRegAddrW(writeRegAddrW),
               .Regfile_weM(Regfile_weM),
               .Regfile_weW(Regfile_weW),
               .forwardAD(forwardAD),
               .forwardBD(forwardBD),
               .forwardAE(forwardAE),
               .forwardBE(forwardBE)
             );

stall_unit stall_unit(
             .rsD(rsD),
             .rtD(rtD),
             .rtE(rtE),
             .writeRegAddrE(writeRegAddrE),
             .writeRegAddrM(writeRegAddrM),
             .Regfile_weE(Regfile_weE),
             .regSrc_muxE(regSrc_muxE),
             .npcOpD(npcOpD),

             .stallF(stallF),
             .stallD(stallD),
             .flushD(flushD),
             .flushE(flushE)
           );

endmodule
