`define WORD_WIDTH `WORD_WIDTH
`define ZERO_WORD 32'h00000000
`define BYTE_WIDTH 7:0
`define REG_SIZE 4:0

`define INSTR_SIZE 255:0 // 最大指令条数

`define EXP_PC 32'h00000040
`define PC_BASE 32'h00000000
`define RAMLINE 1048576
`define DATARAMLINE 4194304

// 指令各部分
`define OP       31:26
`define FUNC     5:0
`define RS       25:21
`define RT       20:16
`define IMM      15:0
`define RD       15:11
`define INSTR_INDEX 25:0
`define SA          10:6
// 控制信号

// 跳转控制信号
`define NPC_OP_LENGTH   1:0
`define NPC_OP_DEFAULT  2'b00     // 默认下一条
`define NPC_OP_JUMP     2'b01     // J
`define NPC_OP_BRANCH   2'b10     // BEQ ...

// 数字扩展控制信号
`define EXT_OP_LENGTH   1:0       // Length of Signal ExtOp
`define EXT_OP_DEFAULT  2'b00     // ExtOp default value
`define EXT_OP_UNSIGNED 2'b01     // 无符号
`define EXT_OP_SIGNED   2'b10     // 有符号

// ALU第二个操作数的选择信号
`define ALU_SRC_REG     1'b0       // ALU source: register file
`define ALU_SRC_IMM     1'b1       // ALU Source: immediate

// ALU控制信号
`define ALU_OP_LENGTH   3:0        // Length of signal ALUOp
`define ALU_OP_DEFAULT  4'b0000    // ALUOp default value
`define ALU_OP_ADD      4'b0001    // ALU add
`define ALU_OP_SUB      4'b0010    // ALU sub
`define ALU_OP_SLT      4'b0011    // ALU slt
`define ALU_OP_AND      4'b0100    // ALU and
`define ALU_OP_OR       4'b0101    // ALU or
`define ALU_OP_XOR      4'b0110    // ALU xor
`define ALU_OP_NOR      4'b0111    // ALU nor
`define ALU_OP_SLL      4'b1000    // ALU sll, with respect to sa
`define ALU_OP_SRL      4'b1001    // ALU srl, with respect to sa
`define ALU_OP_SRA      4'b1010    // ALU sra, with respect to sa
`define ALU_OP_SLLV     4'b1011    // ALU sllv, with respect to rs
`define ALU_OP_SRLV     4'b1100    // ALU srlv, with respect to rs
`define ALU_OP_SRAV     4'b1101    // ALU srav, with respect to rs

// 写回寄存器的数值来源
`define REG_SRC_LENGTH  1:0          // Length of signal RegSrc
`define REG_SRC_DEFAULT 2'b00     // Register default value
`define REG_SRC_ALU     2'b01     // Register write source: ALU
`define REG_SRC_MEM     2'b10     // Register write source: Data Memory

// RegDst Control Signals
`define REG_DST_LENGTH  1:0
`define REG_DST_DEFAULT 2'b00      // Register write destination: default
`define REG_DST_RT      2'b01      // Register write destination: rt
`define REG_DST_RD      2'b10      // Register write destination: rd







// opcode
`define OP_ZEROS 6'b000000
`define OP_ADDIU 6'b001001
`define OP_ADDI 6'b001000
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
`define OP_SW 6'b101011
`define OP_LW 6'b100011
`define OP_LB 6'b100000
`define OP_LBU 6'b100100
`define OP_LH 6'b100001
`define OP_LHU 6'b100101
`define OP_SB 6'b101000
`define OP_SH 6'b101001
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_BGEZ 6'b000001
`define OP_BLTZ 6'b000001
`define OP_BGEZAL 6'b000001
`define OP_BLTZAL 6'b000001
`define OP_BGTZ 6'b000111
`define OP_BLEZ 6'b000110
`define OP_J 6'b000010
`define OP_JAL 6'b000011
`define OP_XORI 6'b001110
`define OP_ORI 6'b001101
`define OP_LUI 6'b001111
`define OP_ANDI 6'b001100
`define OP_CP0 6'b010000

// funccode
`define FUNC_XOR 6'b100110
`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_SLLV 6'b000100
`define FUNC_SLL 6'b000000
`define FUNC_SRAV 6'b000111
`define FUNC_SRA 6'b000011
`define FUNC_SRLV 6'b000110
`define FUNC_SRL 6'b000010
`define FUNC_AND 6'b100100
`define FUNC_NOR 6'b100111
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110

// rtcode
`define RT_BGEZ 5'b00001
`define RT_BGTZ 5'b00000
`define RT_BLEZ 5'b00000
`define RT_BLTZ 5'b00000
`define RT_BGEZAL 5'b10001
`define RT_BLTZAL 5'b10000

// alu code
`define ALU_XOR 5'b00001
`define ALU_EQB 5'b00010
`define ALU_ADD 5'b00100
`define ALU_LS_LEFT 5'b00011
`define ALU_LS_RIGHT 5'b00101
`define ALU_AS_RIGHT 5'b00110
`define ALU_AND 5'b00111
`define ALU_NOR 5'b01001
`define ALU_OR 5'b01010
`define ALU_SUB 5'b01011
`define ALU_SLT 5'b01100
`define ALU_SLTU 5'b01101
