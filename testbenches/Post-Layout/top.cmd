vector ins_in   ins_in\[15\]    ins_in\[14\]    ins_in\[13\]    \
                ins_in\[12\]    ins_in\[11\]    ins_in\[10\]    \
                ins_in\[9\]     ins_in\[8\]     ins_in\[7\]     \
                ins_in\[6\]     ins_in\[5\]     ins_in\[4\]     \
                ins_in\[3\]     ins_in\[2\]     ins_in\[1\]     \
                ins_in\[0\]
vector in_port  in_port\[15\]   in_port\[14\]   in_port\[13\]   \
                in_port\[12\]   in_port\[11\]   in_port\[10\]   \
                in_port\[9\]    in_port\[8\]    in_port\[7\]    \
                in_port\[6\]    in_port\[5\]    in_port\[4\]    \
                in_port\[3\]    in_port\[2\]    in_port\[1\]    \
                in_port\[0\]
vector out_port out_port\[15\]  out_port\[14\]  out_port\[13\]  \
                out_port\[12\]  out_port\[11\]  out_port\[10\]  \
                out_port\[9\]   out_port\[8\]   out_port\[7\]   \
                out_port\[6\]   out_port\[5\]   out_port\[4\]   \
                out_port\[3\]   out_port\[2\]   out_port\[1\]   \
                out_port\[0\]

clock clka 0 1 0 0
clock clkb 0 0 0 1

ana clka clkb rst ins_in ins_done in_port out_port error


h rst
l ins_done in_port
h in_port\[3\]  in_port\[0\]
c 2

l rst

| 1100001000000101	// ADDI R1, R0, 5
h ins_in\[15\] ins_in\[14\] ins_in\[9\] ins_in\[2\] ins_in\[0\]
l ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[10\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[1\]
c 1

| 1011010000000011	// LUI  R2, 3
h ins_in\[15\] ins_in\[13\] ins_in\[12\] ins_in\[10\] ins_in\[1\] ins_in\[0\]
l ins_in\[14\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\]
c 1

| 0000011001010000	// ADD  R3, R1, R2
h ins_in\[10\] ins_in\[9\] ins_in\[6\] ins_in\[4\]
l ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[8\] ins_in\[7\] ins_in\[5\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1100100001110111	// ADDI R4, R1, -9
h ins_in\[15\] ins_in\[14\] ins_in\[11\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
l ins_in\[13\] ins_in\[12\] ins_in\[10\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[3\]
c 1

| 0001101100100000	// SUB  R5, R4, R4
h ins_in\[12\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[5\]
l ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[10\] ins_in\[7\] ins_in\[6\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0010110011100000	// AND  R6, R3, R4
h ins_in\[13\] ins_in\[11\] ins_in\[10\] ins_in\[7\] ins_in\[6\] ins_in\[5\]
l ins_in\[15\] ins_in\[14\] ins_in\[12\] ins_in\[9\] ins_in\[8\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0011111001100000	// OR   R7, R1, R4
h ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[10\] ins_in\[9\] ins_in\[6\] ins_in\[5\]
l ins_in\[15\] ins_in\[14\] ins_in\[8\] ins_in\[7\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0100011010111000	// XOR  R3, R2, R7
h ins_in\[14\] ins_in\[10\] ins_in\[9\] ins_in\[7\] ins_in\[5\] ins_in\[4\] ins_in\[3\]
l ins_in\[15\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[8\] ins_in\[6\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1110001010000010	// SW  R1, 2(R2)
h ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[9\] ins_in\[7\] ins_in\[1\]
l ins_in\[12\] ins_in\[11\] ins_in\[10\] ins_in\[8\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[0\]
c 1

| 1101010010000010	// LW  R2, 2(R2)
h ins_in\[15\] ins_in\[14\] ins_in\[12\] ins_in\[10\] ins_in\[7\] ins_in\[1\]
l ins_in\[13\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[0\]
c 1

| 1100001000000011	// ADDI R1, R0, 3
h ins_in\[15\] ins_in\[14\] ins_in\[9\] ins_in\[1\] ins_in\[0\]
l ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[10\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\]
c 1

| 1100010000000010	// ADDI R2, R0, 2
h ins_in\[15\] ins_in\[14\] ins_in\[10\] ins_in\[1\]
l ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[0\]
c 1

| 0000011000101000	// ADD R3, R0, R5
h ins_in\[10\] ins_in\[9\] ins_in\[5\] ins_in\[3\]
l ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[4\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1100101101000001	// ADDI R5, R5, 1
h ins_in\[15\] ins_in\[14\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[6\] ins_in\[0\]
l ins_in\[13\] ins_in\[12\] ins_in\[10\] ins_in\[7\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\]
c 1

| 1001011010000001	// BEQ R3, R2, 1
h ins_in\[15\] ins_in\[12\] ins_in\[10\] ins_in\[9\] ins_in\[7\] ins_in\[0\]
l ins_in\[14\] ins_in\[13\] ins_in\[11\] ins_in\[8\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\]
c 1

| 1110111011000000	// SW R7, 0(R3)
h ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[11\] ins_in\[10\] ins_in\[9\] ins_in\[7\] ins_in\[6\]
l ins_in\[12\] ins_in\[8\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1010101001111011	// BNE R5, R1, FOR_LOOP
h ins_in\[15\] ins_in\[13\] ins_in\[11\] ins_in\[9\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[1\] ins_in\[0\]
l ins_in\[14\] ins_in\[12\] ins_in\[10\] ins_in\[8\] ins_in\[7\] ins_in\[2\]
c 1

| 1011010000111111	// LUI R2, 63
h ins_in\[15\] ins_in\[13\] ins_in\[12\] ins_in\[10\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
l ins_in\[14\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[6\]
c 1

| 1110100010000000	// SW  R4, 0(R2)
h ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[11\] ins_in\[7\]
l ins_in\[12\] ins_in\[10\] ins_in\[9\] ins_in\[8\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1101011010000010	// LW  R3, 2(R2)
h ins_in\[15\] ins_in\[14\] ins_in\[12\] ins_in\[10\] ins_in\[9\] ins_in\[7\] ins_in\[1\]
l ins_in\[13\] ins_in\[11\] ins_in\[8\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[0\]
c 1

| 0101011001001000	// LSL R3, R1, R1
h ins_in\[14\] ins_in\[12\] ins_in\[10\] ins_in\[9\] ins_in\[6\] ins_in\[3\]
l ins_in\[15\] ins_in\[13\] ins_in\[11\] ins_in\[8\] ins_in\[7\] ins_in\[5\] ins_in\[4\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0110111001001000	// LSR R7, R1, R1
h ins_in\[14\] ins_in\[13\] ins_in\[11\] ins_in\[10\] ins_in\[9\] ins_in\[6\] ins_in\[3\]
l ins_in\[15\] ins_in\[12\] ins_in\[8\] ins_in\[7\] ins_in\[5\] ins_in\[4\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1000100110000000	// CLZ R4, R6
h ins_in\[15\] ins_in\[11\] ins_in\[8\] ins_in\[7\]
l ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[10\] ins_in\[9\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0111110101100000	// MAC R6, R5, R4
h ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[10\] ins_in\[8\] ins_in\[6\] ins_in\[5\]
l ins_in\[15\] ins_in\[9\] ins_in\[7\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1100111000111110	// ADDI R7, R0, -2
h ins_in\[15\] ins_in\[14\] ins_in\[11\] ins_in\[10\] ins_in\[9\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\]
l ins_in\[13\] ins_in\[12\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[0\]
c 1

| 0111111111111000	// MAC R7, R7, R7
h ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[10\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\]
l ins_in\[15\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0001001111001000	// SUB R1, R7, R1
h ins_in\[12\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[3\]
l ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[11\] ins_in\[10\] ins_in\[5\] ins_in\[4\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0111101101001000	// MAC R5, R5, R1
h ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[9\] ins_in\[8\] ins_in\[6\] ins_in\[3\]
l ins_in\[15\] ins_in\[10\] ins_in\[7\] ins_in\[5\] ins_in\[4\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 0111100001110000	// MAC R4, R1, R6
h ins_in\[14\] ins_in\[13\] ins_in\[12\] ins_in\[11\] ins_in\[6\] ins_in\[5\] ins_in\[4\]
l ins_in\[15\] ins_in\[10\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1

| 1111000000000000	// HALT
h ins_in\[15\] ins_in\[14\] ins_in\[13\] ins_in\[12\]
l ins_in\[11\] ins_in\[10\] ins_in\[9\] ins_in\[8\] ins_in\[7\] ins_in\[6\] ins_in\[5\] ins_in\[4\] ins_in\[3\] ins_in\[2\] ins_in\[1\] ins_in\[0\]
c 1


h ins_done
c 188