# pipeline_processor

## ��ˮ�߽׶�

IF(F) -> IF/ID(D) -> ID -> ID/EXE(E) -> EXE -> EXE/ME(M) -> ME -> ME/WB(W) -> WB

## �ӿ����


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
         input  wire [11:2] instr_addr, // ������PCǰ���0x004

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

         output wire                isRsRtEq       // rs rt�Ƿ����
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
         output wire                        memToRegD // �Ƿ�Ϊ���ڴ���ص��Ĵ����е�ָ��
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
## ֧��ָ��
### ��������ָ��(7��)
- ADDU rd, rs, rt  GPR[rd] �� GPR[rs] + GPR[rt] 
- �� ADDIU rt, rs, imm  GPR[rt] �� GPR[rs] + sign_extend(imm) 
- SUBU rd, rs, rt  GPR[rd] �� GPR[rs] �C GPR[rt] 
- SLT rd, rt, rs  
    if GPR[rs] < GPR[rt] GPR[rd] �� 1  
    else  GPR[rd] �� 0  
- SLTI rt, rs, imm  
    if GPR[rs] < Sign_extend(imm)  GPR[rt] �� 1  
    else GPR[rt] �� 0
- SLTU rd, rs, rt  
    if (0||GPR[rs]31..0) < (0||GPR[rt]31..0) //rs rt�е�ֵ�����޷������Ƚ�
    GPR[rd] �� 1  
    else GPR[rd] �� 0
- SLTIU rt, rs, imm  
    if (0||GPR[rs]31..0) < Sign_extend(imm) GPR[rt] �� 1  
    else GPR[rt] �� 0
### �߼�����ָ�8����
- AND rd, rs, rt  GPR[rd] �� GPR[rs] & GPR[rt]  
- ANDI rt, rs, imm  GPR[rt] �� GPR[rs] & Zero_extend(imm)  
- LUI rt, imm GPR[rt] �� (imm || 16'h0000)
- NOR rd, rs, rt GPR[rd] �� GPR[rs] nor GPR[rt]
- OR rd, rs, rt GPR[rd] �� GPR[rs] or GPR[rt]
- ORI rt, rs, imm GPR[rt] �� GPR[rs] or Zero_extend(imm)
- XOR rd, rs, rt GPR[rd] �� GPR[rs] xor GPR[rt]
- XORI rt, rs, imm GPR[rt] �� GPR[rs] xor Zero_extend(imm)
### ��λָ�6����
- SLLV rd, rt, rs GPR[rd] �� GPR[rt] (31-rs)..0||rs'h0   
�ɼĴ��� rs �е�ֵָ����λ�����ԼĴ��� rt ��ֵ�����߼����ƣ����д��Ĵ��� rd �С�
- SLL rd, rt, sa GPR[rd] �� GPR[rt] (31-sa)..0||sa'h0  
�������� sa ָ����λ�����ԼĴ��� rt ��ֵ�����߼����ƣ����д��Ĵ��� rd �С�
- SRAV rd, rt, rs   
�ɼĴ��� rs �е�ֵָ����λ�����ԼĴ��� rt ��ֵ�����������ƣ����д��Ĵ��� rd �С�
- SRA rd, rt, sa
�������� sa ָ����λ�����ԼĴ��� rt ��ֵ�����������ƣ����д��Ĵ��� rd �С�
- SRLV rd, rt, rs
�ɼĴ��� rs �е�ֵָ����λ�����ԼĴ��� rt ��ֵ�����߼����ƣ����д��Ĵ��� rd �С�
- SRL rd, rt, sa  
�������� sa ָ����λ�����ԼĴ��� rt ��ֵ�����߼����ƣ����д��Ĵ��� rd �С�
### ��֧��תָ�3����
- BEQ rs, rt, offset
- BNE rs, rt, offset
- J target
### �ô�ָ�2����
- LW rt, offset(base)
- SW rt, offset(base)



### ָ�������

|       |            |            |00:pc+4    01:j/jal   10:beq/bne  11:jr       |       | 0���Ĵ���rs     1��������sa | 0���Ĵ���rt     1��������imm | 01��ALU     10��MEM | 01��RT     10��RD   11��31| 0���޷���     1�������� |
| ----- | ---------- | ---------- | ----- | ----- | --------------------------- | ---------------------------- | ------------------- | ----------------- | ----------------------- |
| ָ��  | Regfile_we | DataMem_we | npcOp | aluOp | aluSrc1_mux                 | aluSrc2_mux                  | regSrc_mux          | regDst_mux        | extOp                   |
| add    | 1          | 0          | 00    | 0100  | 0                           | 0                            | 01                  | 10        
| addu  | 1          | 0          | 00    | 0100  | 0                           | 0                            | 01                  | 10                | 1                       |
| addi  | 1          | 0          | 00    | 0100  | 0                           | 1                            | 01                  | 01                | 1                       |
| addiu | 1          | 0          | 00    | 0100  | 0                           | 1                            | 01                  | 01                | 1                       |
| sub   | 1          | 0          | 00    | 1011  | 0                           | 0                            | 01                  | 10                | 1                       |
| subu  | 1          | 0          | 00    | 1011  | 0                           | 0                            | 01                  | 10                | 1                       |
| slt   | 1          | 0          | 00    | 1100  | 0                           | 0                            | 01                  | 10                | 1                       |
| slti  | 1          | 0          | 00    | 1100  | 0                           | 1                            | 01                  | 01                | 1                       |
| sltu  | 1          | 0          | 00    | 1101  | 0                           | 0                            | 01                  | 10                | 1                       |
| sltiu | 1          | 0          | 00    | 1101  | 0                           | 1                            | 01                  | 01                | 1                       |
|       |            |            |       |       |                             |                              |                     |                   |                         |
| lui   | 1          | 0          | 00    | 1110  | 0                           | 1                            | 01                  | 01                | 0                       |
| and   | 1          | 0          | 00    | 0111  | 0                           | 0                            | 01                  | 10                | 0                       |
| andi  | 1          | 0          | 00    | 0111  | 0                           | 1                            | 01                  | 01                | 0                       |
| nor   | 1          | 0          | 00    | 1001  | 0                           | 0                            | 01                  | 10                | 0                       |
| or    | 1          | 0          | 00    | 1010  | 0                           | 0                            | 01                  | 10                | 0                       |
| ori   | 1          | 0          | 00    | 1010  | 0                           | 1                            | 01                  | 01                | 0                       |
| xor   | 1          | 0          | 00    | 0001  | 0                           | 0                            | 01                  | 10                | 0                       |
| xori  | 1          | 0          | 00    | 0001  | 0                           | 1                            | 01                  | 01                | 0                       |
|       |            |            |       |       |                             |                              |                     |                   |                         |
| sllv  | 1          | 0          | 00    | 0011  | 0                           | 0                            | 01                  | 10                | 1                       |
| sll   | 1          | 0          | 00    | 0011  | 1                           | 0                            | 01                  | 10                | 1                       |
| srav  | 1          | 0          | 00    | 0101  | 1                           | 0                            | 01                  | 10                | 1                       |
| sra   | 1          | 0          | 00    | 0101  | 1                           | 0                            | 01                  | 10                | 1                       |
| srlv  | 1          | 0          | 00    | 0110  | 1                           | 0                            | 01                  | 10                | 1                       |
| srl   | 1          | 0          | 00    | 0110  | 1                           | 0                            | 01                  | 10                | 1                       |
|       |            |            |       |       |                             |                              |                     |                   |                         |
| beq   | 0          | 0          | 10    | 0000  | 0                           | 0                            | 00                  | 00                | 0                       |
| bne   | 0          | 0          | 10    | 0000  | 0                           | 0                            | 00                  | 00                | 0                       |
| j     | 0          | 0          | 01    | 0000  | 0                           | 0                            | 00                  | 00                | 0                       |
| jal     | 1          | 0          | 01    | 0000  | 0                           | 0                            | 00                  | 11                | 0                       |
| jr     | 0          | 0          | 11    | 0000  | 0                           | 0                            | 00                  | 00                | 0                       |
|       |            |            |       |       |                             |                              |                     |                   |                         |
| sw    | 0          | 1          | 00    | 0100  | 0                           | 1                            | 00                  | 00                | 1                       |
| lw    | 1          | 0          | 00    | 0100  | 0                           | 1                            | 10                  | 01                | 1                       |