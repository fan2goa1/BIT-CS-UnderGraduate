//opcode
`define OPCODE_R    7'b0110011
`define OPCODE_I    7'b0010011
`define OPCODE_LW   7'b0000011
`define OPCODE_S    7'b0100011
`define OPCODE_B    7'b1100011
`define OPCODE_J    7'b1101111

//funct3
`define FUNCT3_ADD  3'b000
`define FUNCT3_SUB  3'b000
`define FUNCT3_ADDI 3'b000
`define FUNCT3_ORI  3'b110
`define FUNCT3_BEQ  3'b000
`define FUNCT3_LW   3'b010
`define FUNCT3_SW   3'b010
`define FUNCT3_BGE  3'b101
`define FUNCT3_BNE  3'b001
`define FUNCT3_BLT  3'b100

//funct7
`define FUNCT7_ADD  7'b0000000
`define FUNCT7_SUB  7'b0100000

//instr_id
`define ID_NULL     0
`define ID_ADD      1
`define ID_SUB      2
`define ID_ADDI     3
`define ID_ORI      4
`define ID_BEQ      5
`define ID_LW       6
`define ID_SW       7
`define ID_JAL      8
`define ID_BGE      9
`define ID_BLT      10
`define ID_BNE      11

//alu_op
`define ALU_NULL    4'b1111
`define ALU_ADD     4'b0000
`define ALU_SUB     4'b0001
`define ALU_OR      4'b0011

//branch
`define BR_NULL     3'b000
`define BR_BLT      3'b011
`define BR_BGE      3'b100
`define BR_BEQ      3'b101
`define BR_BNE      3'b110
`define BR_JAL      3'b111
