| IRSIM Testbench
	| Adapted from ../Post-Innovus/flattop.cmd,
	| which is automatically generated based on 
	| latest assembly codeby a Python script 
	| (../../../assembler/irsim_script.py).

stepsize 5
relax l

vector p_ins_in   	p_ins_in\[15\]    p_ins_in\[14\]    p_ins_in\[13\]    \
					p_ins_in\[12\]    p_ins_in\[11\]    p_ins_in\[10\]    \
					p_ins_in\[9\]     p_ins_in\[8\]     p_ins_in\[7\]     \
					p_ins_in\[6\]     p_ins_in\[5\]     p_ins_in\[4\]     \
					p_ins_in\[3\]     p_ins_in\[2\]     p_ins_in\[1\]     \
					p_ins_in\[0\]
vector p_in_port  	p_in_port\[15\]   p_in_port\[14\]   p_in_port\[13\]   \
					p_in_port\[12\]   p_in_port\[11\]   p_in_port\[10\]   \
					p_in_port\[9\]    p_in_port\[8\]    p_in_port\[7\]    \
					p_in_port\[6\]    p_in_port\[5\]    p_in_port\[4\]    \
					p_in_port\[3\]    p_in_port\[2\]    p_in_port\[1\]    \
					p_in_port\[0\]
vector p_out_port 	p_out_port\[15\]  p_out_port\[14\]  p_out_port\[13\]  \
					p_out_port\[12\]  p_out_port\[11\]  p_out_port\[10\]  \
					p_out_port\[9\]   p_out_port\[8\]   p_out_port\[7\]   \
					p_out_port\[6\]   p_out_port\[5\]   p_out_port\[4\]   \
					p_out_port\[3\]   p_out_port\[2\]   p_out_port\[1\]   \
					p_out_port\[0\]

clock p_clka 0 1 0 0
clock p_clkb 0 0 0 1

ana p_clka p_clkb p_rst p_ins_in p_ins_done p_in_port p_out_port p_error

h p_rst
l p_ins_done
setvector p_in_port 0x0009
c 2

l p_rst
    
| 00: ADDI R1, R0, 5
	setvector p_ins_in 0xc205
	c 1
| 01: LUI  R2, 3
	setvector p_ins_in 0xb403
	c 1
| 02: ADD  R3, R1, R2
	setvector p_ins_in 0x0650
	c 1
| 03: ADDI R4, R1, -9
	setvector p_ins_in 0xc877
	c 1
| 04: SUB  R5, R4, R4
	setvector p_ins_in 0x1b20
	c 1
| 05: AND  R6, R3, R4
	setvector p_ins_in 0x2ce0
	c 1
| 06: OR   R7, R1, R4
	setvector p_ins_in 0x3e60
	c 1
| 07: XOR  R3, R2, R7
	setvector p_ins_in 0x46b8
	c 1
| 08: SW  R1, 2(R2)
	setvector p_ins_in 0xe282
	c 1
| 09: LW  R2, 2(R2)
	setvector p_ins_in 0xd482
	c 1
| 10: ADDI R1, R0, 3
	setvector p_ins_in 0xc203
	c 1
| 11: ADDI R2, R0, 2
	setvector p_ins_in 0xc402
	c 1
| 12: ADD R3, R0, R5
	setvector p_ins_in 0x0628
	c 1
| 13: ADDI R5, R5, 1
	setvector p_ins_in 0xcb41
	c 1
| 14: BEQ R3, R2, 1
	setvector p_ins_in 0x9681
	c 1
| 15: SW R7, 0(R3)
	setvector p_ins_in 0xeec0
	c 1
| 16: BNE R5, R1, FOR_LOOP
	setvector p_ins_in 0xaa7b
	c 1
| 17: LUI R2, 63
	setvector p_ins_in 0xb43f
	c 1
| 18: SW  R4, 0(R2)
	setvector p_ins_in 0xe880
	c 1
| 19: LW  R3, 2(R2)
	setvector p_ins_in 0xd682
	c 1
| 20: LSL R3, R1, R1
	setvector p_ins_in 0x5648
	c 1
| 21: LSR R7, R1, R1
	setvector p_ins_in 0x6e48
	c 1
| 22: CLZ R4, R6
	setvector p_ins_in 0x8980
	c 1
| 23: MAC R6, R5, R4
	setvector p_ins_in 0x7d60
	c 1
| 24: ADDI R7, R0, -2
	setvector p_ins_in 0xce3e
	c 1
| 25: MAC R7, R7, R7
	setvector p_ins_in 0x7ff8
	c 1
| 26: SUB R1, R7, R1
	setvector p_ins_in 0x13c8
	c 1
| 27: MAC R5, R5, R1
	setvector p_ins_in 0x7b48
	c 1
| 28: MAC R4, R1, R6
	setvector p_ins_in 0x7870
	c 1
| 29: HALT
	setvector p_ins_in 0xf000
	c 1


h p_ins_done
c 200