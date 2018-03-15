PROJECT=multiplexer
FILES=src/multiplexer.vhd
SIMOB=multiplexer_tb
SIMFILES=testbench/multiplexer_tb.vhd
SIMDIR=sim
GHDL_CMD=ghdl
GTKWAVE=gtkwave
compile:
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -a --workdir=$(SIMDIR) --work=work $(FILES) $(SIMFILES)
	$(GHDL_CMD) -e --workdir=$(SIMDIR) $(SIMOB)
run:
	$(GHDL_CMD) -r $(SIMOB) --vcd=$(SIMDIR)/$(SIMOB).vcd
view:
	$(GTKWAVE) $(SIMDIR)/$(SIMOB).vcd
clean:
	$(GHDL_CMD) --clean --workdir=$(SIMDIR)
	rm -r $(SIMDIR)
