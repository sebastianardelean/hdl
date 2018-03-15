PROJECT=half_adder
FILES=src/half_adder.vhd
SIMOB=half_adder_tb
SIMFILES=testbench/half_adder_tb.vhd
SIMDIR=sim
GHDL_CMD=ghdl
GTKWAVE=gtkwave
compile:
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -a --workdir=$(SIMDIR) --work=work $(FILES) $(SIMFILES)
	$(GHDL_CMD) -e --workdir=$(SIMDIR) $(SIMOB)
run:
	$(GHDL_CMD) -r $(SIMOB) --vcd=$(SIMDIR)/$(SIMOB).vcd
	$(GTKWAVE) $(SIMDIR)/$(SIMOB).vcd
clean:
	$(GHDL_CMD) --clean --workdir=$(SIMDIR)
