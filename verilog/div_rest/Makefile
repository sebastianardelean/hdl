PROJECT=7-segments driver
FILES=src
TEST=testbench
OUT=obj
OBJ=divrest
HDL=iverilog
GTKWAVE=gtkwave



MODULES=\
	$(FILES)/divrest.v

	

TESTBENCHES=\
	$(TEST)/divrest_tb.v

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(MODULES) $(TESTBENCHES) -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	

view:
	mv $(OBJ).vcd $(OUT)/
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
