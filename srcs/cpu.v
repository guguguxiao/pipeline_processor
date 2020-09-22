`timescale 1ns / 1ps
`include "defines.vh"

module cpu(
         input clk,
         input rst
       );

wire stallF;
wire stallD;

wire flushD;

wire [`WORD_WIDTH]      npc;
wire [`WORD_WIDTH]      pcF;
wire [`WORD_WIDTH]      instrF;
wire [`WORD_WIDTH]      instrD;

fetch fetch(
        .clk(clk),
        .rst(rst),
        .stallF(stallF),
        .npc(npc),

        .pcF(pcF),
        .instrF(instrF)
      );

if_id if_id(
        .clk(clk),
        .rst(rst),
        .stallD(stallD),
        .instrF(instrF),
        .flushD(flushD),

        .instrD(instrD)
      );


wire                 Regfile_weW;
wire [`WORD_WIDTH]   wbOut;
wire [`WORD_WIDTH]   aluOutM;

wire                        Regfile_weD;
wire                        DataMem_weD;
wire         extOpD;
wire [`ALU_OP_LENGTH]        aluOpD;
wire                        aluSrc1_muxD;
wire                        aluSrc2_muxD;
wire [`REG_SRC_LENGTH]       regSrc_muxD;
wire [`REG_DST_LENGTH]       regDst_muxD;
wire [`WORD_WIDTH]       readData1D;
wire [`WORD_WIDTH]       readData2D;
wire [`REG_SIZE]         rsD;
wire [`REG_SIZE]         rtD;
wire [`REG_SIZE]         rdD;
wire [15:0]              imm16D;
wire               forwardAD;
wire               forwardBD;
wire [`NPC_OP_LENGTH]           npcOpD;

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
     .imm16D(imm16D)
   );

wire [`REG_SIZE]                 rsE;
wire  [`REG_SIZE]                 rtE;
wire  [`REG_SIZE]                 rdE;
wire  [15:0]                      imm16E;
wire                        Regfile_weE;
wire                        DataMem_weE;
wire         extOpE;
wire [`ALU_OP_LENGTH]        aluOpE;
wire                        aluSrc1_muxE;
wire                        aluSrc2_muxE;
wire [`REG_SRC_LENGTH]       regSrc_muxE;
wire [`REG_DST_LENGTH]       regDst_muxE;
wire  [`WORD_WIDTH]               readData1E;
wire  [`WORD_WIDTH]               readData2E;
wire                            flushE;

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
        .readData2E(readData2E)
      );

wire [1:0]                      forwardAE;
wire [1:0]                      forwardBE;
wire [`REG_SIZE]              writeRegAddrE;
wire [`WORD_WIDTH]             aluOutE;
wire [`WORD_WIDTH]             writeDataE;

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

wire             Regfile_weM;
wire             DataMem_weM;
wire [`REG_SIZE]  writeRegAddrM;
wire [`WORD_WIDTH] writeDataM;
wire [`REG_SRC_LENGTH] regSrc_muxM;

ex_mem ex_mem(
         .clk(clk),
         .rst(rst),
         .Regfile_weE(Regfile_weE),
         .DataMem_weE(DataMem_weE),
         .writeRegAddrE(writeRegAddrE),
         .aluOutE(aluOutE),
         .writeDataE(writeDataE),
         .regSrc_muxE(regSrc_muxE),

         .Regfile_weM(Regfile_weM),
         .DataMem_weM(DataMem_weM),
         .writeRegAddrM(writeRegAddrM),
         .regSrc_muxM(regSrc_muxM),
         .aluOutM(aluOutM),
         .writeDataM(writeDataM)
       );

wire [`WORD_WIDTH] readDataM;

DataMem DataMem(
          .clk(clk),
          .DataMem_we(DataMem_weM),
          .addr(aluOutM),
          .writeData(writeDataM),
          .readData(readDataM)
        );

wire      [`WORD_WIDTH]  readDataW;
wire      [`REG_SIZE]    writeRegAddrW;
wire     [`WORD_WIDTH]    aluOutW;
wire [`REG_SRC_LENGTH]       regSrc_muxW;

mem_wb mem_wb(
         .clk(clk),
         .rst(rst),
         .Regfile_weM(Regfile_weM),
         .readDataM(readDataM),
         .aluOutM(aluOutM),
         .writeRegAddrM(writeRegAddrM),
         .regSrc_muxM(regSrc_muxM),

         .Regfile_weW(Regfile_weW),
         .aluOutW(aluOutW),
         .regSrc_muxW(regSrc_muxW),
         .readDataW(readDataW),
         .writeRegAddrW(writeRegAddrW)
       );

assign wbOut=(regSrc_muxW == `REG_SRC_ALU) ? aluOutW :
       (regSrc_muxW == `REG_SRC_MEM) ? readDataW :
       `ZERO_WORD;

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
