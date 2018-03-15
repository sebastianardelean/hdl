PROJECT=counter_4_bit
FILES=src
TEST=testbench
OUT=obj
OBJ=auc_4_bit
HDL=iverilog
GTKWAVE=gtkwave

MODULES=\
	$(FILES)/d_ff.v \
	$(FILES)/four_bit_auc.v

TESTBENCHES=\
	$(TEST)/four_bit_auc_tb.v


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
