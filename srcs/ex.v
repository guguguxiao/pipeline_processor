`timescale 1ns / 1ps
`include "defines.vh"


module ex(
    input [1:0]              forwardAE,
    input [1:0]              forwardBE,
    input [`REGSIZE]               rsE,
    input [`REGSIZE]               rtE,
    input [`REGSIZE]               rdE,
    input  [`ALU_OP_LENGTH]         aluOpE,
    input                      alusrc1_muxE,
    input                      alusrc2_muxE, 
    input [15:0]                      imm16E,
    input wire[`REG_SRC_LENGTH]       regSrc_muxE,
    input wire[`REG_DST_LENGTH]       regDst_muxE,
    input [`WORD_WIDTH]       readData1E,
    input [`WORD_WIDTH]       readData2E,
    input [`WORD_WIDTH]        databackA,
    input [`WORD_WIDTH]        databackW,  
    input [4:0]                       saE,
    input wire[`EXT_OP_LENGTH]        extOPE,
    output [`REG_SIZE]        writeRegAddrE,
    output[`WORD_WIDTH]          aluOutE,
    output[`WORD_WIDTH]       writeDataE
    );
    wire [`WORD_WIDTH] data1;
    wire [`WORD_WIDTH] data2;
    wire [`WORD_WIDTH] data1_tmp;
    wire [`WORD_WIDTH] data2_tmp;

    assign extend_immE={{16{imm16E[15]}},imm16E[15:0]};
    assign extend_saE={{27{saE[4]}},saE[4:0]};
    assign data1_tmp = (forwardAE == 2'b01) ? databackA :
                   (forwardAE == 2'b10) ? databackW :
                    readData1E;
    assign data2_tmp = (forwardBE == 2'b01) ? databackA :
                       (forwardBE == 2'b10) ? databackW :
                        readDataE2;
    assign data1= (alusrc2_muxE == 1'b1) ? extend_saE : data1_tmp;
    assign data2 = (alusrc2_muxE == 1'b1) ? extend_immE :data2_tmp;
    assign writeDataE = data2_tmp;
    // ALU
    Alu Alu(
        .aluOpE(aluOpE),
        .SrcA(data1),
        .SrcB(data2),
        .aluOutE(aluOutE)
    );
    // 写寄存器选择
    assign writeRegAddrE = (regDst_muxE == 1'b1) ? rdE : rtE;
endmodule
