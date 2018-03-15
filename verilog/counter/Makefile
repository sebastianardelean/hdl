PROJECT=counter
FILES=src
TEST=testbench
OUT=obj
OBJ=counter
HDL=iverilog
GTKWAVE=gtkwave

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(FILES)/counter.v $(TEST)/counter_tb.v -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
