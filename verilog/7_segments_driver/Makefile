PROJECT=7-segments driver
FILES=src
TEST=testbench
OUT=obj
OBJ=segments_driver
HDL=iverilog
GTKWAVE=gtkwave



MODULES=\
	$(FILES)/segments_driver.v

	

TESTBENCHES=\
	$(TEST)/segments_driver_tb.v

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(MODULES) $(TESTBENCHES) -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
