`define WORD_WIDTH 31:0
`define BYTE_WIDTH 7:0
`define REG_SIZE 4:0
`define ALU_OP_LENGTH 4:0

`define MAX_INSTR_NUM 255:0 // 最大指令条数

`define EXP_PC 32'h00000040
`define PC_BASE 32'h00000000
`define ZEROWORD 32'h00000000
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
