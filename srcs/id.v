`timescale 1ns / 1ps
`include "defines.vh"

module id (
         input       clk,
         input       rst,

         // 其他流水线提供的信号
         input  [`WORD_WIDTH]   instrD,
         input  [`WORD_WIDTH]   pcF,
         input  [`WORD_WIDTH]   pc_direct,

         input                  Regfile_weW,
         input  [`WORD_WIDTH]   wbOut,
         input  [`REG_SIZE]     writeRegAddrW,

         input  [`WORD_WIDTH]   aluOutM,

         // 数据前递信号
         input               forwardAD,
         input               forwardBD,

         output wire [`WORD_WIDTH]          npc,

         // CU输出
         output wire                        Regfile_weD,
         output wire                        DataMem_weD,
         output wire                        extOpD,
         output wire [`ALU_OP_LENGTH]        aluOpD,
         output wire                        aluSrc1_muxD,
         output wire                        aluSrc2_muxD,
         output wire [`REG_SRC_LENGTH]       regSrc_muxD,
         output wire [`REG_DST_LENGTH]       regDst_muxD,
         output wire [`NPC_OP_LENGTH]           npcOpD,

         // 寄存器堆输出
         output [`WORD_WIDTH]       readData1D,
         output [`WORD_WIDTH]       readData2D,


         output [`REG_SIZE]         rsD,
         output [`REG_SIZE]         rtD,
         output [`REG_SIZE]         rdD,
         output [15:0]              imm16D,

         // NPC输出
         output [`WORD_WIDTH]       jal_targetD,

         output                     inst_sram_en
       );

wire [5:0] opcode = instrD[`OP];
wire [5:0] func = instrD[`FUNC];
wire [4:0] rs = instrD[`RS];
wire [4:0] rt = instrD[`RT];
wire [15:0] imm16 = instrD[`IMM];
wire [15:11] rd = instrD[`RD];
wire [25:0] imm26 = instrD[`INSTR_INDEX];
wire [4:0]  sa = instrD[`SA];

assign rsD = rs;
assign rtD = rt;
assign rdD = rd;
assign imm16D = imm16;

wire [`WORD_WIDTH] readData1;
wire [`WORD_WIDTH] readData2;

register_file register_file (
                .clk(clk),
                .reg1_addr(rs),
                .reg2_addr(rt),
                .Regfile_weW(Regfile_weW),
                .writeRegAddrW(writeRegAddrW),
                .writeDataW(wbOut),

                .readData1(readData1),
                .readData2(readData2)
              );

assign readData1D = readData1;
assign readData2D = readData2;

wire [`NPC_OP_LENGTH] npcOp;

wire isRsRtEq;

wire isJump;

// 数据进入branch前进行的前递
wire [`WORD_WIDTH] reg1_data = (forwardAD == 1'b1) ? aluOutM : readData1;
wire [`WORD_WIDTH] reg2_data = (forwardBD == 1'b1) ? aluOutM : readData2;

NPC NPC(
      .pc(pc_direct),
      .imm16(imm16),
      .imm26(imm26),
      .npcOp(npcOp),
      .isRsRtEq(isRsRtEq),
      .reg1Data(reg1_data),

      .npc(npc),
      .jal_target(jal_targetD),
      .isJump(isJump)
    );

assign inst_sram_en = rst & (!isJump);



branch_judge branch_judge(
               .reg1_data(reg1_data),
               .reg2_data(reg2_data),

               .isRsRtEq(isRsRtEq)
             );

wire _Regfile_weD;

control_unit control_unit (
               .rst(rst),
               .opcode(opcode),
               .func(func),
               .isRsRtEq(isRsRtEq),

               .Regfile_weD(_Regfile_weD),
               .DataMem_weD(DataMem_weD),
               .extOpD(extOpD),
               .npcOp(npcOp),
               .aluOpD(aluOpD),
               .aluSrc1_muxD(aluSrc1_muxD),
               .aluSrc2_muxD(aluSrc2_muxD),
               .regSrc_muxD(regSrc_muxD),
               .regDst_muxD(regDst_muxD)
             );

// nop的regfile也不能为1
assign Regfile_weD = _Regfile_weD && (instrD != `ZERO_WORD);

assign npcOpD = npcOp;

endmodule
