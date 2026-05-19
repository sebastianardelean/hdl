
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

Design and simulate a 32 KiB full associative mapped cache, with 8-words block and 32 bit words.
Main Memory size is 8 MiB, the addressable unit is the word. The cache is write-back and it implements a LRU policy.


## Parameters

### Cache

$32 KiB = 2^5 \times 2^{10} B$. Considering that there are $32 bits = 4B = 2^2 B$ per each word, that
means that the cache size is $\frac{2^5 \times 2^{10}}{2^2}=2^3 \times 2^{10} words$. 
Since there are 8 words per block ($2^3 words/block$), the are $\frac{2^3 \times 2^{10}}{2^3}=2^{10}$ blocks in cache.

| Tag            | Block Offset| 
|----------------|-------------|
| 18 bits        | 3 bits      |

### Main Memory
Main memory is $8 MiB = 2^3 \times 2^{20} B$. Since the addressable unit is the word, and each word is 4B, there are $\frac{ 2^3 \times 2^{20}}{2^2}=2^{21}$ words in main memory. This means that the address word is 21 bits. Therefore, tag size is $21 - 3 = 18$ bits. 

The address issued from the cache controller to main memory is on $8+10=18$ bits.

### Offsets

| Tag (20:3)                 | Block Offset (2:0)  |  
|----------------------------|---------------------|  
| 18 bits                    | 3 bits              |


## Cache controller parameters

```verilog
parameter BLOCK_SIZE = 256; // bits (8 words * 4 B * 8 bits = 256 bits)
parameter ADDRESS_WIDTH = 21; //bits (3 + 18 )
parameter TAG_WIDTH = 18; //bits
parameter OFFSET_WIDTH = 3; //bits
parameter WORD_SIZE = 32; //bits
parameter NBLOCKS = 1024; // 2^10 blocks in cache
```

