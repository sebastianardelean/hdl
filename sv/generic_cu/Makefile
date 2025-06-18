PROJECT=cu
OUT=obj
OBJ=cu
CC=iverilog
FLAGS=-g2012
GTKWAVE=gtkwave

SRC=\
	src/cu.sv


TESTS=\
	test/cu_tb.sv 


all: compile


compile:
	mkdir -p $(OUT)
	$(CC) $(FLAGS) $(SRC) $(TESTS) -o $(OUT)/$(OBJ)

run:
	vvp $(OUT)/$(OBJ)

view:
	mv $(OBJ).vcd $(OUT)/
	$(GTKWAVE) $(OUT)/$(OBJ).vcd
clean:
	rm -r $(OUT)
