# Booth's Algorithm


## Project structure

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
└── Makefile             # Project-level build/sim control
