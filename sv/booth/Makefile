PROJECT=booth
OUT=obj
OBJ=booth
CC=iverilog
FLAGS=-g2012
GTKWAVE=gtkwave

SRC=\
	src/booth_parts.sv \
	src/booth.sv


TESTS=\
	test/booth_tb.sv


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
