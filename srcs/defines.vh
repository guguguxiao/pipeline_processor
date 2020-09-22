`define WORD_WIDTH 31:0
`define ZERO_WORD 32'h00000000
`define BYTE_WIDTH 7:0
`define REG_SIZE 4:0

`define INSTR_SIZE 1023:0 // 最大指令条数

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
`define EXT_OP_UNSIGNED 1'b0     // 无符号
`define EXT_OP_SIGNED   1'b1     // 有符号

// ALU第一个操作数的选择信号
`define ALU_SRC1_MUX_RS     1'b0       // ALU source: register file
`define ALU_SRC1_MUX_SA     1'b1       // ALU Source: immediate

// ALU第二个操作数的选择信号
`define ALU_SRC2_MUX_RT      1'b0       // ALU source: register file
`define ALU_SRC2_MUX_IMM     1'b1       // ALU Source: immediate

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

// ALU操作码
`define ALU_OP_LENGTH       3:0
`define ALU_XOR             4'b0001
`define ALU_EQB             4'b0010
`define ALU_ADD             4'b0100
`define ALU_LS_LEFT         4'b0011
`define ALU_LS_RIGHT        4'b0101
`define ALU_AS_RIGHT        4'b0110
`define ALU_AND             4'b0111
`define ALU_NOR             4'b1001
`define ALU_OR              4'b1010
`define ALU_SUB             4'b1011
`define ALU_SLT             4'b1100
`define ALU_SLTU            4'b1101
`define ALU_LUI             4'b1110

