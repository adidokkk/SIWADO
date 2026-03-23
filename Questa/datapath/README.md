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



