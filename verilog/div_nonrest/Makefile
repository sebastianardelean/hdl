PROJECT=7-segments driver
FILES=src
TEST=testbench
OUT=obj
OBJ=divnonrest
HDL=iverilog
GTKWAVE=gtkwave



MODULES=\
	$(FILES)/divnonrest.v

	

TESTBENCHES=\
	$(TEST)/divnonrest_tb.v

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
