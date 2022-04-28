PROJECT=<project-name>
FILES=src
TEST=testbench
OUT=obj
OBJ=<executable-name>
HDL=iverilog
GTKWAVE=gtkwave

MODULES=\
	$(FILES)/<module_1>.sv \
	$(FILES)/<module_2>.sv

TESTBENCHES=\
	$(TEST)/<testbench>.sv


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
