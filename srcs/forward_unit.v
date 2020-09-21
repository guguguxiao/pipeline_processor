`timescale 1ns / 1ps
`include "defines.vh"

module forward_unit(
    input [`REG_SIZE] rsD,
    input [`REG_SIZE] rtD,
    
    input [`REG_SIZE] rsE,
    input [`REG_SIZE] rtE,

    input [`REG_SIZE] writeRegAddrM,
    input [`REG_SIZE] writeRegAddrW,
    
    input Regfile_weM,
    input Regfile_weW,

    output forwardAD,
    output forwardBD,
    output [1:0]forwardAE,
    output [1:0]forwardBE,
    
    );
    assign forwardAD = (rsD != 5'b00000 && rsD == writeRegAddrM && Regfile_weM);
    assign forwardBD = (rtD != 5'b00000 && rtD == writeRegAddrM && Regfile_weM);
    
    assign forwardAE = (rsE != 5'b00000 && rsE == writeRegAddrM && Regfile_weM) ? 2'b01:
                       (rsE != 5'b00000 && rsE == writeRegAddrW && Regfile_weW) ? 2'b10:
                       2'b00;
    assign forwardBE = (rtE != 5'b00000 && rtE == writeRegAddrM && Regfile_weM) ? 2'b01:
                       (rtE != 5'b00000 && rtE == writeRegAddrW && Regfile_weW) ? 2'b10:
                       2'b00;  
    
endmodule