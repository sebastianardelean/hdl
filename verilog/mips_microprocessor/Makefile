PROJECT=mips
FILES=src
TEST=testbench
OUT=obj
OBJ=mips
HDL=iverilog
GTKWAVE=gtkwave
FLAGS = -Wall -g2012

ALL_SRC = \
    $(FILES)/mipsmem.sv \
    $(FILES)/mipsparts.sv \
    $(FILES)/mips.sv \
    $(FILES)/mipstop.sv



all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(FLAGS) $(ALL_SRC) $(TEST)/mipstest.sv -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
