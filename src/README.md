## UPDATE OF TUE 24 MAR:
### new `control_fsm.v` FSM
- `reg branch_taken` used but never assigned => reversed to 0 if branch taken, 1 otherwise
- wrong alu_op for OP_ADDI => reversed to OP_ADD
- `pc_src` is assigned by output seq block as well as separate branch logic => reversed to only output seq block
- confirmed also branch not taken case is asserted
- fatal error in OP_BEQ / OP_BNE: `zero_flag` is not ready yet when evaluated => added new state BRANCH
- duplicate `HALT` state in seq block @ clkb
- unnecessary `reset` assertion in seq block @ clkb
- added an error flag mechanism for invalid state or opcode handling

### `ins_mem.v`
- instructions `instr` changed from 16'h to 16'b for readability
- instructions `instr` did not replicate commented behavior
- completed integrating `shifter_unit.v` instructions

### `data_mem.v`
- did not check for signal `out_port_en` out of FSM to write
- fixed if-else statement

### `shifter_unit.v`
- fatal error in seq blocks: technology we use does not allow for asynchronous reset
- seq block on posedge(clkb) => changed them to negedge(clkb) to mantain two-phases clock

## `datapath_top.v`
- integrated `shifter_unit` module
- miscellaneous fixes

## `datapath_top_tb.v`
- integrated shifter test
- finalized the testbench integrating all final codes

General commenting in codes and change of names of variables for readability. 

## Structure
alu.v # ALU

data_mem.v # Data memory (RAM/MMIO)

datapath_top.v # Top-level datapath

imm_gen.v # Immediate generator

ins_mem.v # Instruction memory

ir.v # Instruction register

pc.v # Program counter

regfile.v # Register file

shifter_unit.v # Shifter (TODO)

tb.v # Testbench

## Verified Instructions
- ADDI  
- LUI  
- ADD  
- BNE

## Next Steps
1. Verify RAM / MMIO waveform (run current tb.v)  
2. Complete `shifter_unit.v`  
3. Add shifter instructions into `ins_mem.v`  
4. Verify shifter instructions

## Notes
- Datapath is controlled manually via testbench  
- Control FSM is not required for this assignment

## MMIO Address Update
Originally, MMIO was planned at address `0x00FF`.  

However, this is not feasible in the current design because the immediate field is only **6 bits**.

To ensure a clear and robust separation, MMIO is now mapped to:0xFC00 ~ 0xFCFF
- `0xFC00` → output port (write)
- `0xFC02` → input port (read)



