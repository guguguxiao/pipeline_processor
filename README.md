# pipeline_processor

## 流水线阶段

IF(F) -> IF/ID(D) -> ID -> ID/EXE(E) -> EXE -> EXE/ME(M) -> ME -> ME/WB(W) -> WB

## 接口设计


### IF

#### pc
```
module PC(
         input                 clk,
         input                 rst,
         input              installF,
         input     [`WORD_WIDTH] npc,
         output reg[`WORD_WIDTH]  pc,
       );
```

#### Instruction Memory
```
module instruction_memory(
         input  wire[11:2] instr_addr, // PC fetch instruction address

         output wire[31:0] instr       // IM fetch instruction from register
       );
```

### IF/ID
```
module Fetch_Decode(
         input       clk,
         input       rst,

         input      [`WORD_WIDTH] instrF,
         input                 installD,

         output reg [`WORD_WIDTH]  instrD,
       );
```

### ID

#### npc
```
module npc(
         input  wire[31:0]                  pc,
         input  wire[15:0]                  imm16,     // 16 bit immediate
         input  wire[25:0]                  imm26,     // 26 bit immediate

         input  wire[`NPC_OP_LENGTH  - 1:0] cu_npc_op, // NPC control signal
    
         output wire[31:0]                  npc,       // next program counter
         output wire[31:0]                  jmp_dst    // JAL, JAJR jump dst
       );
```

#### Branch Judge
```
module branch_judge(
         input  wire[31:0] reg1_data,
         input  wire[31:0] reg2_data,

         output wire       zero       // Calculate whether rs - rt is zero
       );
```

#### Control Unit
```
module control_unit(
         input wire                         rst,
         input wire[5:0]                    opcode, // Instruction opcode
         input wire[4:0]                    sa,     // Shift operation operand
         input wire[5:0]                    func,   // R-Type instruction function
         input wire                         zero,

         output wire                        en_reg_write,
         output wire                        en_mem_write,
         output wire[`EXT_OP_LENGTH  - 1:0] cu_ext_op,
         output wire                        cu_alu_src,
         output wire[`ALU_OP_LENGTH  - 1:0] cu_alu_op,
         output wire[`REG_SRC_LENGTH - 1:0] cu_reg_src,
         output wire[`REG_DST_LENGTH - 1:0] cu_reg_dst,
         output wire[`NPC_OP_LENGTH  - 1:0] cu_npc_op,
         output wire                        en_lw
       );
```

### ID/EX
```
module Decode_Execute(
         input clk,
         input rst,
         input [`REGSIZE]               rsD,
         input [`REGSIZE]               rtD,
         input [`REGSIZE]               rdD,
         input                    regWriteD,
         input                    ramWriteD,
         input  [`ALUSIZE]         aluCodeD,
         input                      aluSrcD,
         input                      regDstD,
         input                    memToRegD,
         input [`WORDSIZE]       readData1D,
         input [`WORDSIZE]       readData2D,
         //input [`WORDSIZE]      extend_immD,
         //input [3:0]                   wenD,
         //input [4:0]              readTypeD,
         //input                   algor_ecpD,
         //input                    cp0WriteD,
         //input                     cp0ReadD,

         input                       flushE,
    
         //input   [8:0]           exceptionD,
         //input                    isInSlotD,
         //input   [`WORDSIZE]        slotPCD,
    
         output reg[`REGSIZE]           rsE,
         output reg[`REGSIZE]           rtE,
         output reg[`REGSIZE]           rdE,
         output reg               regWriteE,
         output reg               ramWriteE,
         output reg[`ALUSIZE]      aluCodeE,
         output reg                 aluSrcE,
         output reg                 regDstE,
         output reg               memToRegE,
         output reg[`WORDSIZE]   readData1E,
         output reg[`WORDSIZE]   readData2E,
         output reg[`WORDSIZE]  extend_immE,
         //output reg[3:0]               wenE,
         //output reg[4:0]          readTypeE,
         //output reg              algor_ecpE,
         //output reg               cp0WriteE,
         //output reg                cp0ReadE,
         //output reg[8:0]         exceptionE,
    
         //output reg               isInSlotE,
         //output reg[`WORDSIZE]      slotPCE
       );
```

### Stall Unit
```
module stall_unit(
         input [`REGSIZE] rsD,
         input [`REGSIZE] rtD,

         input [`REGSIZE] rsE,
         input [`REGSIZE] rtE,
    
         input [`REGSIZE] writeRegE,
         input [`REGSIZE] writeRegA,
         input [`REGSIZE] writeRegW,
    
         input regWriteE,
         input regWriteA,
         input regWriteW,
         input memToRegE,
         //input isFz,
    
         //input isExp,
    
         //output forwardAD,
         //output forwardBD,
    
         //output [1:0]forwardAE,
         //output [1:0]forwardBE,
    
         output installF,
         output installD,
    
         output flushD,
         output flushE,
         //output flushA
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





```

```

```

```