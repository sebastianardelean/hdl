PROJECT=booth
FILES=src
TEST=testbench
OUT=obj
OBJ=boothr4
HDL=iverilog
GTKWAVE=gtkwave

all: compile


compile:
	mkdir -p $(OUT)
	$(HDL) $(FILES)/boothr4.v $(TEST)/boothr4_tb.v -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)
	mv $(OBJ).vcd $(OUT)/

view:
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
