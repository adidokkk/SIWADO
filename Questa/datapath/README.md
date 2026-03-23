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


