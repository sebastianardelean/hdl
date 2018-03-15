PROJECT=booth
FILES=src
TEST=testbench
OUT=obj
OBJ=booth
HDL=iverilog
GTKWAVE=gtkwave

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(FILES)/booth.v $(TEST)/booth_tb.v -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
