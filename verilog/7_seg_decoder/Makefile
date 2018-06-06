PROJECT=7-segments driver
FILES=src
TEST=testbench
OUT=obj
TOPLEVEL_MODULE=segments_driver
HDL=iverilog
TARGET=vvp
FLAGS=-g2012 -t$(TARGET)
TOPLEVEL_MODULE_FLAG=-s $(TOPLEVEL_MODULE)


MODULES=\
	$(FILES)/driver_7_segments.v\
	$(FILES)/dlatch.v\
	$(FILES)/dec_7seg.v\
	$(FILES)/drv_7seg.v

TEST_TARGETS=\
	dec_7seg_tb\
	drv_7seg_tb\
	driver_7_segments_tb



all: create_dir compile_link

preprocess:
	$(HDL) -E $(MODULES)

test:$(TEST_TARGETS)

clean:
	rm -r $(OUT)
	rm *.vcd






### DO NOT USE THESE TARGETS ###
create_dir:
	mkdir -p $(OUT)

compile_link:
	$(HDL) $(FLAGS) $(MODULES) -o $(OUT)/$(TOPLEVEL_MODULE)


dec_7seg_tb:
	$(HDL) $(FLAGS) $(MODULES) $(TEST)/dec_7seg_tb.v -o $(OUT)/dec7_seg_tb

drv_7seg_tb:
	$(HDL) $(FLAGS) $(MODULES) $(TEST)/drv_7seg_tb.v -o $(OUT)/drv_7seg_tb

driver_7_segments_tb:
	$(HDL) $(FLAGS) $(MODULES) $(TEST)/driver_7_segments_tb.v -o $(OUT)/driver_7_segments_tb