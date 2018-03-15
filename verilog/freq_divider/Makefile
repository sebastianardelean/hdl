PROJECT=d_ff
FILES=src
TEST=testbench
OUT=obj
OBJ=freq_div
HDL=iverilog
GTKWAVE=gtkwave

MODULES=\
	$(FILES)/d_ff.v \
	$(FILES)/freq_div.v

TESTBENCHES=\
	$(TEST)/freq_div_tb.v


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
