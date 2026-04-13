# Assembler's Input
    # The assembler translates this assembly code into binary data.
    # List of possible instructions:
        #    ADD, SUB
        #    LUI, ADDI
        #    AND, OR, XOR
        #    LSL, LSR, MAC, CLZ
        #    BEQ, BNE
        #    LW, SW
        #    HALT    

# Arithmetic Test
    ADDI R1, R0, 5      # R1 = R0 +  5 = 0x0005
    LUI  R2, 3          # R2 = 3 << 10 = 0x0C00
    ADD  R3, R1, R2     # R3 = R1 + R2 = 0x0C05
    ADDI R4, R1, -9     # R4 = R1 + -9 = 0xFFFC
    SUB  R5, R4, R4     # R5 = R4 - R4 = 0x0000

# Logic Test
    AND  R6, R3, R4     # R6 = R3 & R4 = 0x0C04
    OR   R7, R1, R4     # R7 = R1 | R4 = 0xFFFD
    XOR  R3, R2, R7     # R3 = R2 ^ R7 = 0xF3FD

# RAM Test
    SW  R1, 2(R2)       # ram[R2[7:0] + 2] = R1 => ram[0x02] = 0x0005
    LW  R2, 2(R2)       # R2 = ram[R2[7:0] + 2] = ram[0x02] = 0x0005

# Branch Test
    ADDI R1, R0, 3      # R1 = 3
    ADDI R2, R0, 2      # R2 = 2
    FOR_LOOP:           # for (i = 0; i != 3; i++) { if (i != 2) { ram[i] = R7; } }
        ADD R3, R0, R5          # R3 = R5
        ADDI R5, R5, 1          # R5++
        BEQ R3, R2, 1           # i == 2 ? jump 1 : continue 
        SW R7, 0(R3)            # ram[i] = R7
        BNE R5, R1, FOR_LOOP    # i !=3 ? FOR_LOOP : continue

# MMIO Test
    LUI R2, 63          # R2 = 63 << 10 = 0xFC00 (MMIO base)
    SW  R4, 0(R2)       # out_port = 0xFFFC
    LW  R3, 2(R2)       # R3 = in_port

# Shifter Test
    LSL R3, R1, R1      # R3 = 3 << 3 = 0x0018
    LSR R7, R1, R1      # R7 = 3 >> 3 = 0x0000
    CLZ R4, R6          # R4 = 0x0004

    MAC R6, R5, R4      # MAC 1 – BOTH POSITIVE: R6 = 0x0C10
    ADDI R7, R0, -2     # R7 = 0xFFFE
    MAC R7, R7, R7      # MAC 2 – BOTH NEGATIVE: R7 = 0x0002
    SUB R1, R7, R1      # R1 = 0xFFFF
    MAC R5, R5, R1      # MAC 3 – POSITIVE, NEGATIVE: R5 = 0x0000
    MAC R4, R1, R6      # MAC 4 – NEGATIVE, POSITIVE: R4 = 0xF3F4

# Halt Test
    HALT                # STOP Execution