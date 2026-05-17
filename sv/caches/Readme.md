# Cache



## Project structure

```
project/
│
├── src/                 # RTL source files
├── tb/                  # Testbenches
├── sim/                 # Simulation scripts and config
├── build/               # Build-related outputs (e.g., synthesis)
├── docs/                # Documentation, specs
└── Makefile             # Project-level build/sim control
```

## Requirements

Design and simulate a 32 KiB 4-way set associative cache, with 8-words block and 32 bit words.   
Main Memory size is 8 MiB, the addressable unit is the word. The cache is write-back, write-allocate with an LRU replacement policy.


Check this link: https://github.com/zebmehring/Processor-Cache/blob/master/project_caches/i_cache.v
