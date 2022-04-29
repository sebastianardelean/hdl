
controls = 7 + 9 = 16 bits
ALUOp = 9 bits

0000 ADD
0001 SUB
0010 MUL32
0011 MUL64
0100 SET
0101 AND
0110 OR
0111 XOR
1000 NOR
1001 SHIFT LEFT 
1010 SHIFT RIGHT
1011 DIV
1100 SHIFT RIGHT ARITH
1101 NOP
1110 NOP
1111 NOP

=> 4 BITS for alu function


| instruction | opcode | regwrite | regdst | alusrc | branch | memwrite | memtoreg | jump | aluop | Alu function |
| r-type      | 000000 | 1        | 1      | 0      | 0      | 0        | 0        | 0    | 00010 |
| lw          | 100011 | 1        | 0      | 1      | 0      | 0        | 1        | 0    | 00011 | ADD
| sw          | 101011 | 0        | x      | 1      | 0      | 1        | x        | 0    | 00100 | ADD
| beq         | 000100 | 0        | x      | 0      | 1      | 0        | x        | 0    | 00101 | SUB
| bltz        | 000001 | 0        | x      | 0      | 1      | 0        | x        | 0    | 00110 | SUB
| j           | 000010 | 0        | x      | 0      | 0      | 0        | x        | 1    | 00111 |
| jal         | 000011 | 0        | x      | 0      | 0      | 0        | x        | 1    | 01000 |
| bne         | 000101 | 0        | x      | 0      | 1      | 0        | x        | 0    | 01001 | SUB
| blez        | 000110 | 0        | x      | 0      | 1      | 0        | x        | 0    | 01010 | SUB
| bgtz        | 000111 | 0        | x      | 0      | 1      | 0        | x        | 0    | 01011 | SUB
| addi        | 001000 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 01100 | ADD
| addiu       | 001001 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 01101 | ADD
| slti        | 001010 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 01110 | SET
| sltiu       | 001011 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 01111 | SET
| andi        | 001100 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 10000 | AND
| ori         | 001101 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 10001 | OR
| xori        | 001110 | 1        | 1      | 1      | 0      | 0        | 0        | 0    | 10010 | XOR
| lui         | 001111 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 10011 | SHIFT LEFT BY 16
| mul         | 011100 | 1        | 0      | 0      | 0      | 0        | 0        | 0    | 10100 | MUL32
| lb          | 100000 | 1        | 0      | 1      | 0      | 0        | 1        | 0    | 10101 | ADD
| lh          | 100001 | 1        | 0      | 1      | 0      | 0        | 1        | 0    | 10110 | ADD
| lbu         | 100100 | 1        | 0      | 1      | 0      | 0        | 1        | 0    | 10111 | ADD
| lhu         | 100101 | 1        | 0      | 1      | 0      | 0        | 0        | 0    | 11000 | ADD
| sb          | 101000 | 0        | x      | 1      | 0      | 1        | x        | 0    | 11001 | ADD
| sh          | 101001 | 0        | x      | 1      | 0      | 1        | x        | 0    | 11010 | ADD
|             |        |          |        |        |        |          |          | 0    |       |

| Instruction | Func   | RegWrite | RegDst | ALUSrc | Branch | MemWrite | MemToReg | ALUOp | Alu Function |
| SLL         | 000000 | 1        | 1      | 0      | 0      | 0        | 0        |       | SHIFT LEFT
| SRL         | 000010 | 1        | 1      | 0      | 0      | 0        | 0        |       | SHIFT RIGHT
| SRA         | 000011 | 1        | 1      | 0      | 0      | 0        | 0        |       | SHIFT RIGHT ARITHMETIC
| SLLV        | 000100 | 1        | 1      | 0      | 0      | 0        | 0        |       | SHIFT LEFT
| SRLV        | 000110 | 1        | 1      | 0      | 0      | 0        | 0        |       | SHIFT RIGHT
| SRAV        | 000111 | 1        | 1      | 0      | 0      | 0        | 0        |       | SHIFT RIGHT ARITHMETIC
| JR          | 001000 | 0        | X      | X      | 1      | 0        | 0        |       | NOP
| JALR        | 001001 | 0        | X      | X      | 1      | 0        | 0        |       | NOP
| syscall     | 001100 |          |        |        |        |          |          |       | X
| break       | 001101 |          |        |        |        |          |          |       | X
| mfhi        | 010000 | 1        | 1      | ?      |        |          |          |       | NOP
| mthi        | 010001 |          |        | ?      |        |          |          |       | NOP
| mflo        | 010010 |          |        | ?      |        |          |          |       | NOP
| mtlo        | 010011 |          |        | ?      |        |          |          |       | NOP
| mult        | 011000 | ?        |        |        |        |          |          |       | MUL
| multu       | 011001 | ?        |        |        |        |          |          |       | MUL
| div         | 011010 | ?        |        |        |        |          |          |       | DIV
| divu        | 011011 | ?        |        |        |        |          |          |       | DIV
| add         | 100000 | 1        | 1      | 0      | 0      | 0        | 0        |       | ADD
| addu        | 100001 | 1        | 1      | 0      | 0      | 0        | 0        |       | ADD
| sub         | 100010 | 1        | 1      | 0      | 0      | 0        | 0        |       | SUB
| subu        | 100011 | 1        | 1      | 0      | 0      | 0        | 0        |       | SUB
| and         | 100100 | 1        | 1      | 0      | 0      | 0        | 0        |       | AND
| or          | 100101 | 1        | 1      | 0      | 0      | 0        | 0        |       | OR
| xor         | 100110 | 1        | 1      | 0      | 0      | 0        | 0        |       | XOR
| nor         | 100111 | 1        | 1      | 0      | 0      | 0        | 0        |       | NOR
| slt         | 101010 | 1        | 1      | 0      | 0      | 0        | 0        |       | SET
| sltu        | 101011 | 1        | 1      | 0      | 0      | 0        | 0        |       | SET
|   |   |   |   |   |   |   |   |   |
