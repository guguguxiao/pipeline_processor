`timescale 1ns / 1ps
`include "defines.vh"

module stall_unit(
         input [`REG_SIZE]  rsD,
         input [`REG_SIZE]  rtD,

         input [`REG_SIZE]  rsE,
         input [`REG_SIZE]  rtE,

         input [`REG_SIZE]  writeRegAddrE,
         input [`REG_SIZE]  writeRegAddrM,
         input [`REG_SIZE]  writeRegAddrW,

         input              Regfile_weE,
         input              Regfile_weM,
         input              Regfile_weW,
         input              memToRegE;

         output             stallF,
         output             stallD,

         output             flushD,
         output             flushE,
         output             flushF
       );

wire lw_stall;
wire branch_stall;

// lw此时在exe阶段，要使用lw结果的指令在id阶段
assign lw_stall = (rsD == rtE || rtD == rtE) && memToRegE && (rtE != 5'b00000);

// 跳转的时候与上一条语句发生数据hazard，此时要stall一个周期
assign branch_stall = ((Regfile_weE) && ((writeRegAddrE == rsD) || (writeRegAddrE == rtD)) && writeRegAddrE != 5'b00000)
       || ((memToRegE) && ((writeRegAddrA == rsD) || (writeRegAddrA == rtD)) && writeRegAddrE != 5'b00000);

assign installF = lw_stall || branch_stall;
assign installD = lw_stall || branch_stall;

assign flushE = lw_stall || branch_stall;