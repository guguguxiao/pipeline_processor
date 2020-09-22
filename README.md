# pipeline_processor

## 流水线阶段

IF(F) -> IF/ID(D) -> ID -> ID/EXE(E) -> EXE -> EXE/ME(M) -> ME -> ME/WB(W) -> WB

## 接口设计


### IF

#### pc
```
module pc(
         input                    clk,
         input                    rst,
         input                    stallF,
         input     [`WORD_WIDTH]  npc,
         output reg[`WORD_WIDTH]  pc,
       );
```
#### Instruction Memory
```
module instruction_memory(
         input  wire [11:2] instr_addr, // 忽略了PC前面的0x004

         output wire [`WORD_WIDTH] instr
       );
```

### IF/ID
```
module if_id(
         input       clk,
         input       rst,

         input      [`WORD_WIDTH] instrF,
         input                 stallD,
         input                 flushD,
         output reg [`WORD_WIDTH]  instrD,
       );
```

### ID

#### npc
```
module npc(
         input  wire [`WORD_WIDTH]                  pc,
         input  wire [15:0]                  imm16,     // 16 bit immediate
         input  wire [25:0]                  imm26,     // 26 bit immediate

         input  wire [`NPC_OP_LENGTH] npcOp, // NPC control signal
    
         output wire [`WORD_WIDTH]                  npc,       // next program counter
       );
```

#### Branch Judge
```
module branch_judge(
         input  wire [`WORD_WIDTH]   reg1_data,
         input  wire [`WORD_WIDTH]   reg2_data,

         output wire                isRsRtEq       // rs rt是否相等
       );
```

#### Control Unit
```
module control_unit(
         input wire                         rst,
         input wire [5:0]                    opcode, // Instruction opcode
         input wire [5:0]                    func,   // R-Type instruction function
         input wire                         isRsRtEq,

         output wire                        Regfile_weD,
         output wire                        DataMem_weD,
         output wire         extOp,
         output wire [`NPC_OP_LENGTH]        npcOp,
         output wire [`ALU_OP_LENGTH]        aluOpD,
         output wire                        aluSrc2_muxD,
         output wire [`REG_SRC_LENGTH]       regSrc_muxD,
         output wire [`REG_DST_LENGTH]       regDst_muxD,
         output wire                        memToRegD // 是否为从内存加载到寄存器中的指令
       );
```

#### Register File
```
module register_file(
         input clk,

         input [`REG_SIZE]          rs,
         input [`REG_SIZE]          rt,
         input                      Regfile_we,
         input [`REG_SIZE]          writeAddr,
         input [`WORD_WIDTH]        writeData,

         output [`WORD_WIDTH]       readData1D,
         output [`WORD_WIDTH]       readData2D

       );
```



### ID/EX
```
module id_ex(
         input clk,
         input rst,
         input [`REG_SIZE]                  rsD,
         input [`REG_SIZE]                  rtD,
         input [`REG_SIZE]                  rdD,
         input [15:0]                       imm16D,
         input [4:0]                        saD,
         input wire                         Regfile_weD,
         input wire                         DataMem_weD,
         input wire          extOp,
         input wire [`ALU_OP_LENGTH]         aluOpD,
         input wire                         aluSrc2_muxD,
         input wire [`REG_SRC_LENGTH]        regSrc_muxD,
         input wire [`REG_DST_LENGTH]        regDst_muxD,
         input [`WORD_WIDTH]                readData1D,
         input [`WORD_WIDTH]                readData2D,
         input                              flushE,

         output [`REG_SIZE]                 rsE,
         output [`REG_SIZE]                 rtE,
         output [`REG_SIZE]                 rdE,
         output [15:0]                      imm16E,
         output [4:0]                       saE,
         output wire                        Regfile_weE,
         output wire                        DataMem_weE,
         output wire         extOp,
         output wire [`ALU_OP_LENGTH]        aluOpE,
         output wire                        aluSrc2_muxE,
         output wire [`REG_SRC_LENGTH]       regSrc_muxE,
         output wire [`REG_DST_LENGTH]       regDst_muxE,
         output [`WORD_WIDTH]               readData1E,
         output [`WORD_WIDTH]               readData2E,
       );
```

### Stall Unit
```
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
```
### EXE
#### alu
```
module ALU(
    input [`ALU_OP_LENGTH] aluOpE,
    input [`WORD_WIDTH]    SrcA,
    input [`WORD_WIDTH]    SrcB,
    
    output [`WORD_WIDTH]   aluOutE
    );
```
### forward_unit
```
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
```
#### EX/MEM
```
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
    output reg [`WORD_WIDTH] writeDataM,
    output reg [`REG_SIZE]        rdM    
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

### MEM/WB
```
module mem_wb(
    input       clk,
    input       rst,
    input     Regfile_weM,
    input       [`WORD_WIDTH] readDataM,
    input       [`WORD_WIDTH]   aluOutM,
    input       [`REG_SIZE]  writeRegAddrM,
    
    output reg              Regfile_weW,
    output reg [`WORD_WIDTH]    aluOutW,
    output reg [`WORD_WIDTH]  readDataW,
    output reg  [`REG_SIZE]  writeRegAddrW
    
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