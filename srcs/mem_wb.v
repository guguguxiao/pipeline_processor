module mem_wb(
    input       clk,
    input       rst,
    input     Regfile_weM,
    input       [`WORD_WIDTH] readDataM,
    input       [`WORD_WIDTH]   aluOutM,
    input       [`REG_SIZE]  wirteRegAddrM,
    
    output reg              Regfile_weW,
    output reg [`WORD_WIDTH]    aluOutW,
    output reg [`WORD_WIDTH]  readDataW,
    output reg  [`REG_SIZE]  wirteRegAddrW
    
);
    always @(posedge clk)begin
        if(rst)begin
            Regfile_weW<= 1'b0;
            aluOutW <= `ZEROWORD;
            readDataW <= `ZEROWORD;
            wirteRegAddrW <= 5'b00000;
        end else begin
            Regfile_weW <= Regfile_weM;
            aluOutW <= aluOutM;
            readDataW <= readDataM;
            wirteRegAddrW <= wirteRegAddrM;
        end
    end
endmodule 