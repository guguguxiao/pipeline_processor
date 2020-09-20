# pipeline_processor

## 流水线阶段

IF(F) -> IF/ID(D) -> ID -> ID/EXE(E) -> EXE -> EXE/ME(M) -> ME -> ME/WB(W) -> WB

## 接口设计


### IF模块

#### pc
```
module PC(
         input                 clk,
         input                 rst,
         input              stallF,
         input     [`WORD_WIDTH] npc,
         output reg[`WORD_WIDTH]  pc
       );
```

#### alu
```
module Alu(
    input [`ALUSIZE] aluCodeE,
    input [`WORD_WIDTH]    SrcA,
    input [`WORD_WIDTH]    SrcB,
    
    output [`WORD_WIDTH]   aluOutE
    );
```
#### forward_unit
```
module forward_unit(
    input [`REGSIZE] rsD,
    input [`REGSIZE] rtD,
    
    input [`REGSIZE] rsE,
    input [`REGSIZE] rtE,

    input [`REGSIZE] writeRegA,
    input [`REGSIZE] writeRegW,
    
    input Regfile_weA,
    input Regfile_weW,

    output forwardAD,
    output forwardBD,
    output [1:0]forwardAE,
    output [1:0]forwardBE,
    
    );
```
#### Execute_AccessMem
```
module Execute_AccessMem(
    input       clk,
    input       rst,

    input     Regfile_weE,
    input     DataMem_weE,
    input     memToRegE,
    input       [`REGSIZE]  writeRegE,
    input       [`WORD_WIDTH]   aluOutE,
    input       [`WORD_WIDTH]writeDataE,
    input       [`REGSIZE]       rdE, 
    input                     flushA,
    output reg             Regfile_weA,
    output reg             DataMem_weA,
    output reg             memToRegA,
    output reg [`REGSIZE]  writeRegA,
    
    output reg [`WORD_WIDTH]   aluOutA,
    output reg [`WORD_WIDTH] writeDataA,
    output reg [`REGSIZE]        rdA    
);
```
#### DataMem
```
module DataMem(
    input                    clk,
    input             DataMem_we,
    input [`WORD_WIDTH]     addr,
    input [`WORD_WIDTH]writeData,
    output[`WORD_WIDTH] readData
    );
```

### AccessMem_Writeback
```
module AccessMem_Writeback(
    input       clk,
    input       rst,
    input     memToRegA,
    input     Regfile_weA,
    input       [`WORD_WIDTH] readDataA,
    input       [`WORD_WIDTH]   aluOutA,
    input       [`REGSIZE]  writeRegA,
    
    output reg              memToRegW,
    output reg              Regfile_weW,
    output reg [`WORD_WIDTH]    aluOutW,
    output reg [`WORD_WIDTH]  readDataW,
    output reg  [`REGSIZE]  writeRegW
    
);
```
## 支持指令
### 算术运算指令(7条)
- ADDU rd, rs, rt  GPR[rd] ← GPR[rs] + GPR[rt] 
- ADDIU rt, rs, imm  GPR[rt] ← GPR[rs] + sign_extend(imm) 
- SUBU rd, rs, rt  GPR[rd] ← GPR[rs] – GPR[rt] 
- SLT rd, rt, rs  
    if GPR[rs] < GPR[rt] GPR[rd] ← 1  
    else  GPR[rd] ← 0  
- SLTI rt, rs, imm  
    if GPR[rs] < Sign_extend(imm)  GPR[rt] ← 1  
    else GPR[rt] ← 0
- SLTU rd, rs, rt  
    if (0||GPR[rs]31..0) < (0||GPR[rt]31..0) //rs rt中的值进行无符号数比较
    GPR[rd] ← 1  
    else GPR[rd] ← 0
- SLTIU rt, rs, imm  
    if (0||GPR[rs]31..0) < Sign_extend(imm) GPR[rt] ← 1  
    else GPR[rt] ← 0
### 逻辑运算指令（8条）
- AND rd, rs, rt  GPR[rd] ← GPR[rs] & GPR[rt]  
- ANDI rt, rs, imm  GPR[rt] ← GPR[rs] & Zero_extend(imm)  
- LUI rt, imm GPR[rt] ← (imm || 16'h0000)
- NOR rd, rs, rt GPR[rd] ← GPR[rs] nor GPR[rt]
- OR rd, rs, rt GPR[rd] ← GPR[rs] or GPR[rt]
- ORI rt, rs, imm GPR[rt] ← GPR[rs] or Zero_extend(imm)
- XOR rd, rs, rt GPR[rd] ← GPR[rs] xor GPR[rt]
- XORI rt, rs, imm GPR[rt] ← GPR[rs] xor Zero_extend(imm)
### 移位指令（6条）
- SLLV rd, rt, rs GPR[rd] ← GPR[rt] (31-rs)..0||rs'h0   
由寄存器 rs 中的值指定移位量，对寄存器 rt 的值进行逻辑左移，结果写入寄存器 rd 中。
- SLL rd, rt, sa GPR[rd] ← GPR[rt] (31-sa)..0||sa'h0  
由立即数 sa 指定移位量，对寄存器 rt 的值进行逻辑左移，结果写入寄存器 rd 中。
- SRAV rd, rt, rs   
由寄存器 rs 中的值指定移位量，对寄存器 rt 的值进行算术右移，结果写入寄存器 rd 中。
- SRA rd, rt, sa
由立即数 sa 指定移位量，对寄存器 rt 的值进行算术右移，结果写入寄存器 rd 中。
- SRLV rd, rt, rs
由寄存器 rs 中的值指定移位量，对寄存器 rt 的值进行逻辑右移，结果写入寄存器 rd 中。
- SRL rd, rt, sa  
由立即数 sa 指定移位量，对寄存器 rt 的值进行逻辑右移，结果写入寄存器 rd 中。
### 分支跳转指令（3条）
- BEQ rs, rt, offset
- BNE rs, rt, offset
- J target
### 访存指令（2条）
- LW rt, offset(base)
- SW rt, offset(base)




