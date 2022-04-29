
controls = 7 + 9 = 16 bits
ALUOp = 9 bits


00000 ADD
00001 SUB
00010 MUL32
00011 MUL64
00100 DIV64
00101 AND
00110 OR
00111 XOR
01000 NOR
01001 SET
01010 SL-SHAMT
01011 SR-SHAMT
01100 SRA-SHAMT
01101 SL
01110 SR
01111 SRA
10000 Copy B
11111 NOP




=> 5 BITS for alu function


| instruction      | opcode | regwrite | regdst | alusrc | branch | memwrite | memtoreg | jump | aluop | Alu function     |
| r-type           | 000000 | 1        | 1      | 0      | 0      | 0        | 0        | 0    | 00010 |                  |
| lw               | 100011 | 1        | 0      | 01     | 0      | 0        | 1        | 0    | 00011 | ADD              |
| sw               | 101011 | 0        | 0      | 01     | 0      | 1        | x        | 0    | 00100 | ADD              |
| beq              | 000100 | 0        | 0      | 00     | 1      | 0        | 0        | 0    | 00101 | SUB              |
| bltz             | 000001 | 0        | 0      | 00     | 1      | 0        | 0        | 0    | 00110 | SUB              |
| j                | 000010 | 0        | 0      | 00     | 0      | 0        | 0        | 1    | 00111 | NOP              |
| jal              | 000011 | 0        | 0      | 00     | 0      | 0        | 0        | 1    | 01000 | NOP              |
| bne              | 000101 | 0        | 0      | 00     | 1      | 0        | 0        | 0    | 01001 | SUB              |
| blez             | 000110 | 0        | 0      | 00     | 1      | 0        | 0        | 0    | 01010 | SUB              |
| bgtz             | 000111 | 0        | 0      | 00     | 1      | 0        | 0        | 0    | 01011 | SUB              |
| addi (rt=rs+imm) | 001000 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 01100 | ADD              |
| addiu            | 001001 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 01101 | ADD              |
| slti (set rt)    | 001010 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 01110 | SET              |
| sltiu            | 001011 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 01111 | SET              |
| andi             | 001100 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 10000 | AND              |
| ori              | 001101 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 10001 | OR               |
| xori             | 001110 | 1        | 1      | 01     | 0      | 0        | 0        | 0    | 10010 | XOR              |
| lui              | 001111 | 1        | 0      | 10     | 0      | 0        | 0        | 0    | 10011 | NOP              |
| mul   (rd=rs*rt) | 011100 | 1        | 1      | 00     | 0      | 0        | 0        | 0    | 10100 | MUL32            |
| lb               | 100000 | 1        | 0      | 01     | 0      | 0        | 1        | 0    | 10101 | ADD              |
| lh               | 100001 | 1        | 0      | 01     | 0      | 0        | 1        | 0    | 10110 | ADD              |
| lbu              | 100100 | 1        | 0      | 01     | 0      | 0        | 1        | 0    | 10111 | ADD              |
| lhu              | 100101 | 1        | 0      | 01     | 0      | 0        | 0        | 0    | 11000 | ADD              |
| sb               | 101000 | 0        | 0      | 01     | 0      | 1        | 0        | 0    | 11001 | ADD              |
| sh               | 101001 | 0        | 0      | 01     | 0      | 1        | 0        | 0    | 11010 | ADD              |
|                  |        |          |        |        |        |          |          | 0    |       |                  |

| Instruction | Func   | RegWrite | RegDst | ALUSrc | Branch | MemWrite | MemToReg | Jump | ALUOp | Alu Function                 |
| SLL         | 000000 | 1        | 1      | 00     | 0      | 0        | 0        |      |       | SHIFT LEFT SHAMT             |
| SRL         | 000010 | 1        | 1      | 00     | 0      | 0        | 0        |      |       | SHIFT RIGHT SHAMT            |
| SRA         | 000011 | 1        | 1      | 00     | 0      | 0        | 0        |      |       | SHIFT RIGHT ARITHMETIC SHAMT |
| SLLV        | 000100 | 1        | 1      | 00     | 0      | 0        | 0        |      |       | SHIFT LEFT                   |
| SRLV        | 000110 | 1        | 1      | 00     | 0      | 0        | 0        |      |       | SHIFT RIGHT                  |
| SRAV        | 000111 | 1        | 1      | 00     | 0      | 0        | 0        |      |       | SHIFT RIGHT ARITHMETIC       |
| JR          | 001000 | 0        | 0      | 00     | 1      | 0        | 0        |      |       | NOP                          |
| JALR        | 001001 | 0        | 0      | 00     | 1      | 0        | 0        |      |       | NOP                          |
| syscall     | 001100 |          |        |        |        |          |          |      |       | NOP                          |
| break       | 001101 |          |        |        |        |          |          |      |       | NOP                          |
| mfhi        | 010000 | 1        | 1      | ?      |        |          |          |      |       | NOP                          |
| mthi        | 010001 |          |        | ?      |        |          |          |      |       | NOP                          |
| mflo        | 010010 |          |        | ?      |        |          |          |      |       | NOP                          |
| mtlo        | 010011 |          |        | ?      |        |          |          |      |       | NOP                          |
| mult        | 011000 | ?        |        |        |        |          |          |      |       | MUL64                        |
| multu       | 011001 | ?        |        |        |        |          |          |      |       | MUL64                        |
| div         | 011010 | ?        |        |        |        |          |          |      |       | DIV64                        |
| divu        | 011011 | ?        |        |        |        |          |          |      |       | DIV64                        |
| add         | 100000 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | ADD                          |
| addu        | 100001 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | ADD                          |
| sub         | 100010 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | SUB                          |
| subu        | 100011 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | SUB                          |
| and         | 100100 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | AND                          |
| or          | 100101 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | OR                           |
| xor         | 100110 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | XOR                          |
| nor         | 100111 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | NOR                          |
| slt         | 101010 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | SET                          |
| sltu        | 101011 | 1        | 1      | 0      | 0      | 0        | 0        |      |       | SET                          |
