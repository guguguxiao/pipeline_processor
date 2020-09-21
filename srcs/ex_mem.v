`timescale 1ns / 1ps
`include "defines.vh"

module ex_mem(
    input       clk,
    input       rst,
    input     Regfile_weE,
    input     DataMem_weE,
    input       [`REG_SIZE]  writeRegAddrE,
    input       [`WORD_WIDTH]   aluOutE,
    input       [`WORD_WIDTH]writeDataE,
    
    output reg             Regfile_weM,
    output reg             DataMem_weM,
    output reg [`REG_SIZE]  writeRegAddrM,
    
    output reg [`WORD_WIDTH]   aluOutM,
    output reg [`WORD_WIDTH] writeDataM
  
);
    always @(posedge clk)begin
        if(rst)begin
            Regfile_weM <= 1'b0;
            DataMem_weM <= 1'b0;
            writeRegAddrM <= 5'b00000;
            aluOutM <= `ZERO_WORD;
            writeDataM <= `ZERO_WORD;
        end else begin
            Regfile_weM<=Regfile_weE;
            DataMem_weM <=DataMem_weE;
            writeRegAddrM <=writeRegAddrE;
            aluOutM <=aluOutE;
            writeDataM <= writeDataE;
   
        end
    end

endmodule 