PROJECT=d_ff
FILES=src
TEST=testbench
OUT=obj
OBJ=dff
HDL=iverilog
GTKWAVE=gtkwave

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(FILES)/d_ff.v $(TEST)/d_ff_tb.v -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
