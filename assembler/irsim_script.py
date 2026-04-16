# IRSIM Script
    # It creates a new IRSIM .cmd testbench
    # based on latest binary code.

    # It can be executed with:
    # python3 irsim_script.py [-h] [-i INPUT] [-din IN_DIR] [-dout OUT_DIR] [-o OUTPUT]
        #   Default INPUT:      "program.bin"
        #   Default IN_DIR:     "../testbenches/"
        #   Default OUT_DIR:    "../testbenches/Post-Layout/"
        #   Default OUTPUT:     "top.cmd"
        #   Optional modes:     "-h" for help

import argparse
import os
import re
import sys

# Parser
    # It splits binary code in lines and keeps 
    # track of pc, code, and comments.
def parse_bin(source):
    raw_lines = source.splitlines()

    result = []
    pc = 0

    for raw in raw_lines:
        parts = re.split(r'//', raw)

        code_str = parts[0].strip()
        if not code_str:
            continue  # skip empty or comment lines

        try:
            binary = int(code_str, 2)
        except ValueError:
            print(f"[ERROR] Invalid instruction '{code_str}'")
            continue

        original = parts[1].strip() if len(parts) > 1 else ""

        result.append((binary, pc, original))
        pc += 1

    return result

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', default='program.bin',
                        help="Input .bin file (default: program.bin)")
    parser.add_argument('-din', default='../testbenches/',
                        help="Input directory (default: ../testbenches/)")
    parser.add_argument('-dout', default='../testbenches/Post-Layout/',
                        help="Output directory (default: ../testbenches/Post-Layout/)")    
    parser.add_argument('-o', default='top.cmd',
                        help="Output .cmd file (default: top.cmd)")
    args = parser.parse_args()

    # Build i/o paths safely
    in_path  = os.path.join(args.din, args.i)
    out_path = os.path.join(args.dout, args.o)

    try:
        with open(in_path) as f:
            source = f.read()
    except FileNotFoundError:
        print(f"[ERROR] Input file '{args.i}' not found")
        sys.exit(1)
    result = parse_bin(source)

    text = """
stepsize 5
relax l

vector ins_in   ins_in\[15\]    ins_in\[14\]    ins_in\[13\]    \\
                ins_in\[12\]    ins_in\[11\]    ins_in\[10\]    \\
                ins_in\[9\]     ins_in\[8\]     ins_in\[7\]     \\
                ins_in\[6\]     ins_in\[5\]     ins_in\[4\]     \\
                ins_in\[3\]     ins_in\[2\]     ins_in\[1\]     \\
                ins_in\[0\]
vector in_port  in_port\[15\]   in_port\[14\]   in_port\[13\]   \\
                in_port\[12\]   in_port\[11\]   in_port\[10\]   \\
                in_port\[9\]    in_port\[8\]    in_port\[7\]    \\
                in_port\[6\]    in_port\[5\]    in_port\[4\]    \\
                in_port\[3\]    in_port\[2\]    in_port\[1\]    \\
                in_port\[0\]
vector out_port out_port\[15\]  out_port\[14\]  out_port\[13\]  \\
                out_port\[12\]  out_port\[11\]  out_port\[10\]  \\
                out_port\[9\]   out_port\[8\]   out_port\[7\]   \\
                out_port\[6\]   out_port\[5\]   out_port\[4\]   \\
                out_port\[3\]   out_port\[2\]   out_port\[1\]   \\
                out_port\[0\]

clock clka 0 1 0 0
clock clkb 0 0 0 1

ana clka clkb rst ins_in ins_done in_port out_port error

h rst
l ins_done
setvector in_port 0x0009
c 2

l rst
    """
    with open(out_path, 'w') as f:
        f.write("| IRSIM Testbench\n")
        f.write("\t| Python script (../assembler/irsim_script.py)\n")
        f.write("\t| copies latest assembly code, and\n")
        f.write("\t| creates this custom testbench.\n")
        f.write(f"{text}\n")
        for word, pc, desc in result:
            f.write(f"| {pc:02d}: {desc}\n\tsetvector ins_in 0x{word:04x}\n")
            f.write("\tc 1\n")
        f.write("\n\nh ins_done\nc 200")

    print(f"IRSIM testbench in {out_path} ready to fire!")

if __name__ == '__main__':
    main()