`timescale 1ns / 1ps
`include "defines.vh"

module stall_unit(
         input [`REG_SIZE]  rsD,
         input [`REG_SIZE]  rtD,

         input [`REG_SIZE]  rtE,

         input [`REG_SIZE]  writeRegAddrE,
         input [`REG_SIZE]  writeRegAddrM,
         input              Regfile_weE,

         input [`REG_SRC_LENGTH]  regSrc_muxE,

         output             stallF,
         output             stallD,

         output             flushD,
         output             flushE
       );

wire lw_stall;
wire branch_stall;

// lw��ʱ��exe�׶Σ�Ҫʹ��lw�����ָ����id�׶�
assign lw_stall = (rsD == rtE || rtD == rtE) && (regSrc_muxE == `REG_SRC_MEM) && (rtE != 5'b00000);

// ��ת��ʱ������һ����䷢������hazard����ʱҪstallһ������
assign branch_stall = ((Regfile_weE) && ((writeRegAddrE == rsD) || (writeRegAddrE == rtD)) && writeRegAddrE != 5'b00000)
       || ((regSrc_muxE == `REG_SRC_MEM) && ((writeRegAddrM == rsD) || (writeRegAddrM == rtD)) && writeRegAddrE != 5'b00000);

assign stallF = lw_stall || branch_stall;
assign stallD = lw_stall || branch_stall;

assign flushE = lw_stall || branch_stall;

assign flushD = lw_stall || branch_stall;

endmodule
