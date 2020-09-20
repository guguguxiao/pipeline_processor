module ex_mem(
    input       clk,
    input       rst,
    input     Regfile_weE,
    input     DataMem_weE,
    input       [`REG_SIZE]  wirteRegAddrE,
    input       [`WORD_WIDTH]   aluOutE,
    input       [`WORD_WIDTH]writeDataE,
    input       [`REG_SIZE]       rdE, 
    
    output reg             Regfile_weM,
    output reg             DataMem_weM,
    output reg [`REG_SIZE]  wirteRegAddrM,
    
    output reg [`WORD_WIDTH]   aluOutM,
    output reg [`WORD_WIDTH] writeDataM,
    output reg [`REG_SIZE]        rdM    
);
    always @(posedge clk)begin
        if(rst)begin
            Regfile_weM <= 1'b0;
            DataMem_weM <= 1'b0;
            wirteRegAddrM <= 5'b00000;
            aluOutM <= `ZEROWORD;
            writeDataM <= `ZEROWORD;
            rdM <= 5'b00000;
        end else begin
            Regfile_weM<=Regfile_weE;
            DataMem_weM <=DataMem_weE;
            wirteRegAddrM <=wirteRegAddrE;
            aluOutM <=aluOutE;
            writeDataM <= writeDataE;
            rdM <= rdE;
   
        end
    end

endmodule 