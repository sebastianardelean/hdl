//--------------------------------------------------------------
// mips.sv
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 23 October 2005
// Updated to SystemVerilog dmh 12 November 2010
// Single-cycle MIPS processor
//--------------------------------------------------------------

// files needed for simulation:
//  mipsttest.v
//  mipstop.v
//  mipsmem.v
//  mips.v
//  mipsparts.v

// single-cycle MIPS processor
module mips(input  logic        clk, reset,
            output logic [31:0] pc,
            input  logic [31:0] instr,
            output logic        memwrite,
            output logic [31:0] aluout, writedata,
            input  logic [31:0] readdata);

  logic        memtoreg, branch,
               pcsrc, zero,
               alusrc, regdst, regwrite, jump;
  logic [2:0]  alucontrol;

  controller c(instr[31:26], instr[5:0], zero,
               memtoreg, memwrite, pcsrc,
               alusrc, regdst, regwrite, jump,
               alucontrol);
  datapath dp(clk, reset, memtoreg, pcsrc,
              alusrc, regdst, regwrite, jump,
              alucontrol,
              zero, pc, instr,
              aluout, writedata, readdata);
endmodule

module controller(input  logic [5:0] op, funct,
                  input  logic       zero,
                  output logic       memtoreg, memwrite,
                  output logic       pcsrc, alusrc,
                  output logic       regdst, regwrite,
                  output logic       jump,
                  output logic [2:0] alucontrol);

  logic [8:0] aluop;
  logic       branch;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump,
             aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcsrc = branch & zero;
endmodule

module maindec(input  logic [5:0] op,
               output logic       memtoreg, memwrite,
               output logic       branch, alusrc,
               output logic       regdst, regwrite,
               output logic       jump,
               output logic [8:0] aluop);

  logic [15:0] controls;//TODO: Make it on 16 bits
//TODO: Only aluop is modified. Such that in case of 
//R type it will look at the func code in alu decoder. In that case the aluop
//is 10
//I,J type -> aluop will encode the function that need to perform
  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 16'b1100000000000010; //Rtype
      6'b000001: controls <= 16'b0001000000000110; //bltz
      6'b000010: controls <= 16'b0000001000000000; //j
      6'b000011: controls <= 16'b0000001000000000; //jal
      6'b000100: controls <= 16'b0001000000000101; //beq
      6'b000101: controls <= 16'b0001000000001001; //bne
      6'b000110: controls <= 16'b0001000000001010; //blez
      6'b000111: controls <= 16'b0001000000001011; //bgtz
      6'b001000: controls <= 16'b1010000000001100; //addi
      6'b001001: controls <= 16'b1010000000001101; //addiu
      6'b001010: controls <= 16'b1010000000001110; //slti
      6'b001011: controls <= 16'b1010000000001111; //sltiu
      6'b001100: controls <= 16'b1010000000010000; //andi
      6'b001101: controls <= 16'b1010000000010001; //ori
      6'b001110: controls <= 16'b1010000000010010; //xori
      6'b001111: controls <= 16'b1010000000010011; //lui
      6'b011100: controls <= 16'b1000000000010100; //mul
      6'b100000: controls <= 16'b1010010000010101; //lb
      6'b100001: controls <= 16'b1010010000010110; //lh
      6'b100011: controls <= 16'b1010010000000011; //lw
      6'b100100: controls <= 16'b1010010000010111; //lbu
      6'b100101: controls <= 16'b1010010000011000; //lhu
      6'b101000: controls <= 16'b0010100000011001; //sb
      6'b101001: controls <= 16'b0010100000011010; //sh
      6'b101011: controls <= 16'b0010100000000100; //sw
      default:   controls <= 16'bxxxxxxxxxxxxxxxx;
    endcase
endmodule

module aludec(input  logic [5:0] funct,
              input  logic [8:0] aluop,
              output logic [3:0] alucontrol);


  always_comb
    case(aluop)
	9'b000000011: alucontrol <= 4'b0000;//LW
	9'b000000100: alucontrol <= 4'b0001;//SW
	9'b000000101: alucontrol <= 4'b0001;//BEQ
	9'b000000110: alucontrol <= 4'b0001;//BLTZ
	9'b000001001: alucontrol <= 4'b0001;//bne
	9'b000001010: alucontrol <= 4'b0001;//blez
	9'b000001011: alucontrol <= 4'b0001;//bgtz
	9'b000001100: alucontrol <= 4'b0000;//addi
	9'b000001101: alucontrol <= 4'b0000;//addiu
	9'b000001110: alucontrol <= 4'b0100;//slti
	9'b000001111: alucontrol <= 4'b0100;//sltiu
	9'b000010000: alucontrol <= 4'b0101;//andi
	9'b000010001: alucontrol <= 4'b0110;//ori
	9'b000010010: alucontrol <= 4'b0111;//xori
	9'b000010011: alucontrol <= 4'b1111;//lui TODO: Add a left shift 16 and a mux 3-1
	9'b000010100: alucontrol <= 4'b0010;//mul
	9'b000010101: alucontrol <= 4'b0000;//lb
	9'b000010110: alucontrol <= 4'b0000;//lh
	9'b000010111: alucontrol <= 4'b0000;//lbu
	9'b000011000: alucontrol <= 4'b0000;//lhu
	9'b000011001: alucontrol <= 4'b0000;//sb
	9'b000011010: alucontrol <= 4'b0000;//sh
	9'b000000010: case(funct)          // RTYPE
			6'b000000: alucontrol <= 4'b1001;  // SLL
		        6'b000010: alucontrol <= 4'b1010;  // SRL
		        6'b000011: alucontrol <= 4'b1100;  // SRA
		        6'b000100: alucontrol <= 4'b1001;  // SLLV
		        6'b000110: alucontrol <= 4'b1010;  // SRLV
		        6'b000111: alucontrol <= 4'b1100;  // SRAV
			6'b001000: alucontrol <= 4'b1111;  // JR
			6'b001001: alucontrol <= 4'b1111;  // JALR
			6'b001100: alucontrol <= 4'b1111;  // SYSCALL
			6'b001101: alucontrol <= 4'b1111;  // BREAK
			6'b010000: alucontrol <= 4'b1111;  // MFHI
		        6'b010001: alucontrol <= 4'b1111;  // MTHI
			6'b010010: alucontrol <= 4'b1111;  // MFLO
		        6'b010011: alucontrol <= 4'b1111;  // MTLO
			6'b011000: alucontrol <= 4'b0010;  // MULT
			6'b011001: alucontrol <= 4'b0010;  // MULTU
			6'b011010: alucontrol <= 4'b0011;  // DIV
			6'b011011: alucontrol <= 4'b0011;  // DIVU
		        6'b100000: alucontrol <= 4'b0000; // ADD
			6'b100001: alucontrol <= 4'b0000;  // ADDU
			6'b100010: alucontrol <= 4'b0001; // SUB
			6'b100011: alucontrol <= 4'b0001;  // SUBU
			6'b100100: alucontrol <= 4'b0101;  // AND
			6'b100101: alucontrol <= 4'b0110;  // OR
			6'b100110: alucontrol <= 4'b0111;  // XOR
			6'b100111: alucontrol <= 4'b1000;  // NOR
			6'b101010: alucontrol <= 4'b0100;  // SLT
			6'b101011: alucontrol <= 4'b0100;  // SLTU
			default:   alucontrol <= 4'bxxxx; // ???
		      endcase
    endcase
endmodule

module datapath(input  logic        clk, reset,
                input  logic        memtoreg, pcsrc,
                input  logic        alusrc, regdst,
                input  logic        regwrite, jump,
                input  logic [3:0]  alucontrol,
                output logic        zero,
                output logic [31:0] pc,
                input  logic [31:0] instr,
                output logic [31:0] aluout, writedata,
                input  logic [31:0] readdata);

  logic [4:0]  writereg;
  logic [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  logic [31:0] signimm, signimmsh;
  logic [31:0] srca, srcb;
  logic [31:0] result;

  // next PC logic
  flopr #(32) pcreg(clk, reset, pcnext, pc);
  adder       pcadd1(pc, 32'b100, pcplus4);
  sl2         immsh(signimm, signimmsh);
  adder       pcadd2(pcplus4, signimmsh, pcbranch);
  mux2 #(32)  pcbrmux(pcplus4, pcbranch, pcsrc,
                      pcnextbr);
  mux2 #(32)  pcmux(pcnextbr, {pcplus4[31:28],
		    instr[25:0], 2'b00}, 
		    jump, pcnext);

  // register file logic
  regfile     rf(clk, regwrite, instr[25:21],
                 instr[20:16], writereg,
                 result, srca, writedata);
  mux2 #(5)   wrmux(instr[20:16], instr[15:11],
                    regdst, writereg);
  mux2 #(32)  resmux(aluout, readdata,
                     memtoreg, result);
  signext     se(instr[15:0], signimm);

  // ALU logic
  mux2 #(32)  srcbmux(writedata, signimm, alusrc,
                      srcb);
  alu         alu(.a(srca), .b(srcb), .f(alucontrol),
                  .result(aluout), .zero(zero));
endmodule

module alu(input  logic [31:0] a, b,
           input  logic [4:0]  shamt,
	   input  logic [3:0]  f,
	   output logic [31:0] result,
	   output logic        zero);
    always_comb
	case (f)
          4'b0000: result = a + b;
	  4'b0001: result = a - b;
	  4'b0010: result = a * b;
	  4'b0011: result = a / b;
	  4'b0100: if (a<b) 
			result = 1'b1;
		   else
			result = 1'b0;
	  4'b0101: result = a & b;
	  4'b0110: result = a | b; 
	  4'b0111: result = a ^ b;
	  4'b1000: result = ~ (a | b);
	  4'b1001: result = a << b;
	  4'b1010: result = a >> b;
	  4'b1011: result = 1'b0; //TODO: Not an operation
	  4'b1100: result = a >> b; //TODO: Fix this Instruction
	  default: result = 31'bx;
//	  4'b1101:
//	  4'b1110:
//	  4'b1111: 
    endcase


module alu(input  logic [31:0] a, b,
           input  logic [2:0]  f,
           output logic [31:0] result,
           output logic        zero);



  always_comb
    case (f)
      3'b010: result = a + b;
      3'b110: result = a - b;
      3'b000: result = a & b;
      3'b001: result = a | b;
      3'b111: if (a<b) 
		result = 1'b1;
	      else
		result = 1'b0;
    endcase

  assign zero = (result == 32'b0);
endmodule

