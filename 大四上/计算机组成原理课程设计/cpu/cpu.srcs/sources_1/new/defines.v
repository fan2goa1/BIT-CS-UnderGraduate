`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define Stop 1'b1
`define NoStop 1'b0
`define Branch 1'b1
`define NoBranch 1'b0

//指令类型
`define inst_type_nop 3'b000
`define inst_type_calc 3'b001
`define inst_type_branch 3'b010
`define inst_type_mem 3'b011

//alu执行的运算符号
`define alu_nop 4'b0000
`define alu_sadd 4'b0001
`define alu_ssub 4'b0010
`define alu_smul 4'b0011
`define alu_sdiv 4'b0100
`define alu_uadd 4'b0101
`define alu_usub 4'b0110
`define alu_shl 4'b0111
`define alu_shr 4'b1000
`define alu_ushr 4'b1001
`define alu_and 4'b1010
`define alu_or 4'b1011
`define alu_xor 4'b1100
`define alu_slt 4'b1101
`define alu_ult 4'b1110
`define alu_rem 4'b1111

//涉及计算的符号
`define calc_nop 3'b000
`define calc_alu 3'b001

//涉及访存的符号
`define mem_nop 3'b000
`define mem_lw 3'b001
`define mem_sw 3'b010

//涉及跳转的符号
`define branch_nop 3'b000
`define branch_j 3'b001
`define branch_jal 3'b010
`define branch_b 3'b011

`define OPCODE_SPECIAL 6'b000000 
`define OPCODE_REGIMM 6'b000001
`define OPCODE_ORI 6'b001101
`define OPCODE_J 6'b000010
`define OPCODE_JAL 6'b000011
`define OPCODE_LW 6'b100011
`define OPCODE_SW 6'b101011
`define OPCODE_LUI 6'b001111
`define OPCODE_ADDI 6'b001000
`define OPCODE_ANDI 6'b001100
`define OPCODE_ORI 6'b001101
`define OPCODE_XORI 6'b001110
`define OPCODE_ADDIU 6'b001001
`define OPCODE_BEQ 6'b000100
`define OPCODE_BNE 6'b000101
`define OPCODE_SLTI 6'b001010
`define OPCODE_SLTIU 6'b001011

`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_SRA 6'b000011
`define FUNC_SLLV 6'b000100
`define FUNC_SRLV 6'b000110
`define FUNC_SRAV 6'b000111
`define FUNC_JR 6'b001000