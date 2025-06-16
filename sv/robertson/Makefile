PROJECT=robertson
OUT=obj
OBJ=robertson
CC=iverilog
FLAGS=-g2012
GTKWAVE=gtkwave

SRC=\
	src/robertson_parts.sv \
	src/robertson.sv


TESTS=\
	test/robertson_tb.sv 


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
