`timescale 1ns / 1ps
`include "defines.vh"

module stall_unit(
         input [`REG_SIZE] rsD,
         input [`REG_SIZE] rtD,

         input [`REG_SIZE] rsE,
         input [`REG_SIZE] rtE,

         input [`REG_SIZE] wirteRegAddrE,
         input [`REG_SIZE] wirteRegAddrM,
         input [`REG_SIZE] wirteRegAddrW,

         input Regfile_weE,
         input Regfile_weM,
         input Regfile_weW,

         output stallF,
         output stallD,

         output flushD,
         output flushE,
         output flushF
       );

// TODO:memToReg不能丢！
wire lw_stall;
wire branch_stall;
assign lw_stall = (rsD == rtE || rtD == rtE) && memToRegE && (rtE != 5'b00000);
assign branch_stall = ((Regfile_weE) && ((wirteRegAddrE == rsD) || (wirteRegAddrE == rtD)) && wirteRegAddrE != 5'b00000)
       || ((memToRegE) && ((wirteRegAddrA == rsD) || (wirteRegAddrA == rtD)) && wirteRegAddrE != 5'b00000);
assign installF = lw_stall || branch_stall;
assign installD = lw_stall || branch_stall;

assign flushD = isExp;
assign flushA = isExp;
assign flushE = lw_stall || branch_stall || isExp;

assign forwardAD = (rsD != 5'b00000 && rsD == wirteRegAddrA && Regfile_weA);
assign forwardBD = (rtD != 5'b00000 && rtD == wirteRegAddrA && Regfile_weA);

assign forwardAE = (rsE != 5'b00000 && rsE == wirteRegAddrA && Regfile_weA) ? 2'b01:
       (rsE != 5'b00000 && rsE == wirteRegAddrW && Regfile_weW) ? 2'b10:
       2'b00;
assign forwardBE = (rtE != 5'b00000 && rtE == wirteRegAddrA && Regfile_weA) ? 2'b01:
       (rtE != 5'b00000 && rtE == wirteRegAddrW && Regfile_weW) ? 2'b10:
       2'b00;
