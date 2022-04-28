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

  logic [1:0] aluop;
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
               output logic [1:0] aluop);

  logic [8:0] controls;//TODO: Make it on 16 bits
//TODO: Only aluop is modified. Such that in case of 
//R type it will look at the func code in alu decoder. In that case the aluop
//is 10
//I,J type -> aluop will encode the function that need to perform
  assign {regwrite, regdst, alusrc,
          branch, memwrite,
          memtoreg, jump, aluop} = controls;

  always_comb
    case(op)
      6'b000000: controls <= 9'b110000010; //Rtype
      6'b000001: controls <= 9'b000000000; //bltz
      6'b000010: controls <= 9'b000000000; //j
      6'b000011: controls <= 9'b000000000; //jal
      6'b000100: controls <= 9'b000000000; //beq
      6'b000101: controls <= 9'b000000000; //bne
      6'b000110: controls <= 9'b000000000; //blez
      6'b000111: controls <= 9'b000000000; //bgtz
      6'b001000: controls <= 9'b000000000; //addi
      6'b001001: controls <= 9'b000000000; //addiu
      6'b001010: controls <= 9'b000000000; //slti
      6'b001011: controls <= 9'b000000000; //sltiu
      6'b001100: controls <= 9'b000000000; //andi
      6'b001101: controls <= 9'b000000000; //ori
      6'b001110: controls <= 9'b000000000; //xori
      6'b001111: controls <= 9'b000000000; //lui
      6'b011100: controls <= 9'b000000000; //mul
      6'b100000: controls <= 9'b000000000; //lb
      6'b100001: controls <= 9'b000000000; //lh
      6'b100011: controls <= 9'b000000000; //lw
      6'b100100: controls <= 9'b000000000; //lbu
      6'b100101: controls <= 9'b000000000; //lhu
      6'b101000: controls <= 9'b000000000; //sb
      6'b101001: controls <= 9'b000000000; //sh
      6'b101011: controls <= 9'b000000000; //sw
      default:



      6'b100011: controls <= 9'b101001000; //LW
      6'b101011: controls <= 9'b001010000; //SW
      6'b000100: controls <= 9'b000100001; //BEQ
      6'b001000: controls <= 9'b101000000; //ADDI
      6'b000010: controls <= 9'b000000100; //J
      //TODO: Add ALL OPCODES
      default:   controls <= 9'bxxxxxxxxx; //???
    endcase
endmodule

module aludec(input  logic [5:0] funct,
              input  logic [1:0] aluop,
              output logic [3:0] alucontrol);

  always_comb
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add Used in MAINDEC only for SW & LW
      2'b01: alucontrol <= 3'b110;  // sub USED IN MAINDEC only for BEQ
      2'b10: case(funct)          // RTYPE
	  6'b000000: alucontrol <= 3'bxxx;  // SLL
	  6'b000010: alucontrol <= 3'bxxx;  // SRL
	  6'b000011: alucontrol <= 3'bxxx;  // SRA
	  6'b000100: alucontrol <= 3'bxxx;  // SLLV
	  6'b000110: alucontrol <= 3'bxxx;  // SRLV
	  6'b000111: alucontrol <= 3'bxxx;  // SRAV
	  6'b001000: alucontrol <= 3'bxxx;  // JR
	  6'b001001: alucontrol <= 3'bxxx;  // JALR
	  6'b001100: alucontrol <= 3'bxxx;  // SYSCALL
	  6'b001101: alucontrol <= 3'bxxx;  // BREAK
	  6'b010000: alucontrol <= 3'bxxx;  // MFHI
	  6'b010001: alucontrol <= 3'bxxx;  // MTHI
	  6'b010010: alucontrol <= 3'bxxx;  // MFLO
	  6'b010011: alucontrol <= 3'bxxx;  // MTLO
	  6'b011000: alucontrol <= 3'bxxx;  // MULT
	  6'b011001: alucontrol <= 3'bxxx;  // MULTU
	  6'b011010: alucontrol <= 3'bxxx;  // DIV
	  6'b011011: alucontrol <= 3'bxxx;  // DIVU
          6'b100000: alucontrol <= 3'b010; // ADD
	  6'b100001: alucontrol <= 3'bxxx;  // ADDU
          6'b100010: alucontrol <= 3'b110; // SUB
	  6'b100011: alucontrol <= 3'bxxx;  // SUBU
	  6'b100100: alucontrol <= 3'b000;  // AND
	  6'b100101: alucontrol <= 3'b001;  // OR
	  6'b100110: alucontrol <= 3'bxxx;  // XOR
	  6'b100111: alucontrol <= 3'bxxx;  // NOR
	  6'b101010: alucontrol <= 3'b111;  // SLT
	  6'b101011: alucontrol <= 3'bxxx;  // SLTU
          default:   alucontrol <= 3'bxxx; // ???
        endcase
    endcase
endmodule

module datapath(input  logic        clk, reset,
                input  logic        memtoreg, pcsrc,
                input  logic        alusrc, regdst,
                input  logic        regwrite, jump,
                input  logic [2:0]  alucontrol,
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
          4'b0010: result = a + b;
          4'b0110: result = a - b;
          4'b0000: result = a & b;
          4'b0001: result = a | b;
	  4'b0111: result = b << shamt;
          4'b0111: if (a<b) 
		    result = 1'b1;
		  else
		    result = 1'b0;
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

