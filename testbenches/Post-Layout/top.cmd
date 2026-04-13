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

ana clka clkb rst in_port out_port error


h rst
l in_port
h in_port\[3\]  in_port\[0\]
c 8

l rst
c 752