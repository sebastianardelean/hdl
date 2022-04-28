# MIPS single-cycle microarchitecture

## Implemented as in HARRIS, David; HARRIS, Sarah L. Digital design and computer architecture. Morgan Kaufmann, 2010.


# Implemented instructions

## R-type arithmetic/logic instructions: 

| op | rs | rt | rd | shamt | funct |
| 6  | 5  | 5  | 5  | 5     | 6     |

1. add 
2. sub 
3. and 
4. or 
5. slt





## J-type Instructions:

| op      | address |
| 31 - 26 | 25 - 0  |


1. j

## I-type Instructions:

| op | rs | rt | imm |
| 6  | 5  | 5  | 16  |

1. addi
2. lw
3. sw
4. beq


LINKS:
https://phoenix.goucher.edu/~kelliher/f2009/cs220/mipsir.html

https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_Green_Sheet.pdf

https://www.d.umn.edu/~gshute/mips/control-signal-summary.html

https://en.wikibooks.org/wiki/MIPS_Assembly/MIPS_Details


