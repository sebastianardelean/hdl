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

Design and simulate a 32 KiB direct mapped cache, with 8-words block and 32 bit words.
Main Memory size is 8 MiB, the addressable unit is the word. The cache is write-back.


## Parameters

### Cache

$32 KiB = 2^5 \times 2^ 10 B$. Considering that there are $32 bits = 4B = 2^2 B$ per each word, that
means that the cache size is $ \frac{2^5 \times 2^10}{2^2} $
