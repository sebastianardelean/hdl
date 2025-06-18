1. Restoring division
2. Non-restoring division
3. Booth R4
5. SRT2
6. SRT4
7. Move all components in own files (gates, flip-flops etc)
8. All arithmetic under same project.
9. Find a way for multiple testbenches to be run.
10. Organize the projects as:

project/
│
├── src/                 # RTL source files
│   ├── top/             # Top-level module(s)
│   ├── core/            # Core logic (datapath, CU, ALU, etc.)
│   ├── mem/             # Memory modules (RAM, ROM, registers)
│   └── utils/           # Reusable components (muxes, adders, etc.)
│
├── tb/                  # Testbenches
│   ├── top_tb/          # Testbench for top-level
│   ├── core_tb/         # Unit-level testbenches
│   └── include/         # Shared testbench definitions
│
├── sim/                 # Simulation scripts and config
│   ├── run/             # Output dir for waveforms/logs
│   └── scripts/         # Compile/run scripts (e.g., compile.f)
│
├── build/               # Build-related outputs (e.g., synthesis)
│
├── docs/                # Documentation, specs
│
├── constraints/         # Timing/placement constraints (for FPGA/ASIC)
│
└── Makefile / run.py    # Project-level build/sim control


filelist.f
-I./src
-I./tb

src/alu.sv
src/top.sv
tb/top_tb.sv


iverilog -g2012 -f filelist.f -o sim.out


# Top-level module names for testbenches
TESTBENCHES := alu_tb top_tb

# Simulator output directory
BUILD_DIR := build
VVP_FLAGS := 
IVERILOG_FLAGS := -g2012 -Wall -f filelist.f

# Default target
all: $(TESTBENCHES)

# Rule to build each testbench
$(TESTBENCHES):
	mkdir -p $(BUILD_DIR)
	iverilog $(IVERILOG_FLAGS) tb/$@.sv -o $(BUILD_DIR)/$@.out
	vvp $(BUILD_DIR)/$@.out $(VVP_FLAGS)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
    
    
-I./src
-I./tb

src/alu.sv
src/top.sv    
