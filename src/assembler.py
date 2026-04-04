# Python Assembler
    # It translates assembly code into machine code,
    # and stores it in a new file.

    # It can be executed with:
    # python3 assembler.py [-h] [-i INPUT] [-o OUTPUT] [-v]
        #   Default INPUT:  "program.asm"
        #   Default OUTPUT: "program.bin"
        #   Optional modes: "-h" for help, "-v" for printing in terminal

import sys
import re
import argparse

# Opcodes
OPCODES = {
    'ADD':  0b0000,
    'SUB':  0b0001,
    'AND':  0b0010,
    'OR':   0b0011,
    'XOR':  0b0100,
    'LSL':  0b0101,
    'LSR':  0b0110,
    'MAC':  0b0111,
    'CLZ':  0b1000,
    'BEQ':  0b1001,
    'BNE':  0b1010,
    'LUI':  0b1011,
    'ADDI': 0b1100,
    'LW':   0b1101,
    'SW':   0b1110,
    'HALT': 0b1111
}

# Registers
REGISTERS = {f'R{i}': i for i in range(8)}



# HELPER FUNCTIONS

# Tokenizer
    # e.g. "ADD R1, R2, R3   # cool comment" => ['ADD', 'R1', 'R2', 'R3']
def tokenize(line):
    line = re.split(r'[#]', line)[0].strip()        # handle comments with '#'
    if not line:
        return []
    line = line.replace(',', ' ')
    return line.split()


# Register Parser
    # e.g. " r2 " => '2'
def parse_reg(token):
    reg = token.strip().upper()
    if reg not in REGISTERS:
        raise ValueError(f"Unknown register '{reg}'")
    return REGISTERS[reg]

# Immediate Parser
    # e.g. " 3 " => '000011'
def parse_imm(token, bits=6, signed=True):
    t = token.strip()
    try:
        imm = int(t, 0)     # '0' triggers base auto-detection
    except ValueError:
        raise ValueError(f"Invalid immediate '{t}'")

    lo = -(1 << (bits - 1)) if signed else 0
    hi =  (1 << (bits - 1)) - 1 if signed else (1 << bits) - 1

    if imm < lo or imm > hi:
        raise ValueError(
            f"Immediate {imm} out of {bits}-bit {'signed' if signed else 'unsigned'} "
            f"range [{lo}, {hi}]"
        )
    return imm & ((1 << bits) - 1)      # return imm as 2's comp

# Offsets Parser for Memory Ops (LW / SW) 
    # e.g. " 0x10(r2) " => (16, 2)
def parse_mem(token):
    mem = re.match(r'^(-?\w+)\((\w+)\)$', token.strip())
    if not mem:
        raise ValueError(f"Expected offset(base), got '{token}'")
    try:
        offset = int(mem.group(1), 0)       # '0' triggers base auto-detection
    except ValueError:
        raise ValueError(f"Invalid offset '{mem.group(1)}'")
    return offset, parse_reg(mem.group(2))


# Instruction Encoder
    # e.g. ['ADD', 'R1', 'R2', 'R3'] => '0000001010011000'
def encode(tokens, labels, pc):
    mnem = tokens[0].upper()

    if mnem not in OPCODES:
        raise ValueError(f"Unknown mnemonic '{mnem}'")

    op = OPCODES[mnem]

    # Case 1: ADD, SUB, AND, OR, XOR, LSL, LSR, MAC
        # format: OP rd, rs1, rs2
        # [15:12]=op [11:9]=rd [8:6]=rs1 [5:3]=rs2 [2:0]=000
    if mnem in ('ADD', 'SUB', 'AND', 'OR', 'XOR', 'LSL', 'LSR', 'MAC'):
        rd  = parse_reg(tokens[1])
        rs1 = parse_reg(tokens[2])
        rs2 = parse_reg(tokens[3])
        return (op << 12) | (rd << 9) | (rs1 << 6) | (rs2 << 3)

    # Case 2: ADDI
        # format: ADDI rd, rs1, imm 
        # [15:12]=op [11:9]=rd [8:6]=rs1 [5:0]=imm (signed)
    elif mnem == 'ADDI':
        rd  = parse_reg(tokens[1])
        rs1 = parse_reg(tokens[2])
        imm = parse_imm(tokens[3], signed=True)
        return (op << 12) | (rd << 9) | (rs1 << 6) | (imm & 0x3F)

    # Case 3: LUI
        # format: LUI rd, imm
        # [15:12]=op [11:9]=rd [8:6]=000 [5:0]=imm (unsigned)
    elif mnem == 'LUI':
        rd  = parse_reg(tokens[1])
        imm = parse_imm(tokens[2], bits=6, signed=False)
        return (op << 12) | (rd << 9) | (imm & 0x3F)

    # Case 4: BEQ, BNE
        # format: BEQ rs1, rs2, label_or_offset
        # [15:12]=op [11:9]=rs1 [8:6]=rs2 [5:0]=offset (signed)
    elif mnem in ('BEQ', 'BNE'):
        rs1    = parse_reg(tokens[1])
        rs2    = parse_reg(tokens[2])
        target = tokens[3].strip()

        if target in labels:
            offset = labels[target] - (pc + 1)      # compute offset relative to next instr
        else:
            try:
                offset = int(target, 0)     # '0' triggers base auto-detection
            except ValueError:
                raise ValueError(f"Unknown label '{target}'")

        imm = parse_imm(str(offset), signed=True)
        return (op << 12) | (rs1 << 9) | (rs2 << 6) | (imm & 0x3F)

    # Case 5: LW
        # format: LW rd, offset(base)
        # [15:12]=op [11:9]=rd [8:6]=base [5:0]=offset (signed)
    elif mnem == 'LW':
        rd            = parse_reg(tokens[1])
        offset, base  = parse_mem(tokens[2])
        imm           = parse_imm(str(offset), signed=True)
        return (op << 12) | (rd << 9) | (base << 6) | (imm & 0x3F)

    # Case 6: SW
        # format: SW rs, offset(base)
        # [15:12]=op [11:9]=rs [8:6]=base [5:0]=offset (signed)
    elif mnem == 'SW':
        rs            = parse_reg(tokens[1])
        offset, base  = parse_mem(tokens[2])
        imm           = parse_imm(str(offset), signed=True)
        return (op << 12) | (rs << 9) | (base << 6) | (imm & 0x3F)

    # Case 7: CLZ
        # format: CLZ rd, rs1
        # [15:12]=op [11:9]=rd [8:6]=rs1 [5:0]=000000
    elif mnem == 'CLZ':
        rd  = parse_reg(tokens[1])
        rs1 = parse_reg(tokens[2])
        return (op << 12) | (rd << 9) | (rs1 << 6)

    # Case 8: HALT
    elif mnem == 'HALT':
        return (op << 12)

    else:
        raise ValueError(f"Unknown mnem '{mnem}'")


# Assembler
    # It splits assembly code in lines and encodes 
    # every line managing comments and labels.
def assemble(source):
    raw_lines = source.splitlines()

    # Step 1: collect labels, build (pc, raw_line) list
    labels     = {}
    code_lines = []     # list of (pc:int, original_line:str, tokens:list)
    pc         = 0

    for raw in raw_lines:
        stripped = re.split(r'[#]', raw)[0].strip()
        if not stripped:        # skip empty or comment lines
            continue

        # Labels can be like "LOOP:" or "LOOP: ADD R1, R1, R2"
        if ':' in stripped:
            label, _, rest = stripped.partition(':')
            labels[label.strip()] = pc
            stripped = rest.strip()
            if not stripped: 
                continue

        tokens = tokenize(stripped)
        if tokens:
            code_lines.append((pc, stripped, tokens))
            pc += 1

    # Step 2: encode
    result = []     # list of (pc, word, original_line)

    for pc, original, tokens in code_lines:
        try:
            word = encode(tokens, labels, pc)
        except ValueError as e:
            print(f"\t[ERROR] at '{original}' (pc={pc:04X}): {e}!")
            sys.exit(1)
        result.append((pc, word, original))

    return result, labels


# Terminal Printer
    # Prints output also in terminal if
    # verbose "-v" mode is selected.
def print_listing(result, labels):
    col = 67
    
    print()
    print(f"\tAddr\tHex\t{'Binary':^16}\t{'Line':^15}")
    print("  " + "─" * col)

    for pc, word, original in result:
        print(
            f"\t{pc:04X}\t{word:04X}\t{word:016b}\t"
            f"{original}"
        )

    print()



def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', default='program.asm',
                        help='Input .asm file (default: program.asm)')
    parser.add_argument('-o', default='program.bin',
                        help='Output .bin file (default: program.bin)')
    parser.add_argument('-v', action='store_true',
                        help='Print instruction listing')
    args = parser.parse_args()

    with open(args.i) as f:
        source = f.read()
    result, labels = assemble(source)

    with open(args.o, 'w') as f:
        f.write("// Assembler's Output\n")
        f.write("\t// Python Assembler translates the assembly code\n")
        f.write("\t// into machine code, and stores it in this file.\n")
        for _, word, desc in result:
            f.write(f"\n{word:016b}\t// {desc}")
    if args.v:
        print_listing(result, labels)

    print(f"Assembled {len(result)} instruction(s) in {args.o}!")

if __name__ == '__main__':
    main()