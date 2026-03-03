/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Mon Mar  2 23:21:26 2026
/////////////////////////////////////////////////////////////


module control_fsm ( clka, clkb, rst, opcode, zero_flag, counter_done, 
        mmio_addr, pc_write, pc_src, ir_load, reg_write, alu_op, alu_src, 
        mem_read, mem_write, mem_to_reg, shifter_en, counter_en, shifter_op, 
        out_port_en );
  input [3:0] opcode;
  output [3:0] alu_op;
  output [1:0] shifter_op;
  input clka, clkb, rst, zero_flag, counter_done, mmio_addr;
  output pc_write, pc_src, ir_load, reg_write, alu_src, mem_read, mem_write,
         mem_to_reg, shifter_en, counter_en, out_port_en;
  wire   N100, N176, N179, N180, N181, N183, N184, N185, N188, N189, N190,
         N191, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14,
         n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
         n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70,
         n71, n72, n73, n74, n75, n76;
  wire   [2:0] state;

  DFFNEGX1 \state_reg[0]  ( .D(n1), .CLK(clka), .Q(state[0]) );
  DFFNEGX1 \state_reg[2]  ( .D(n2), .CLK(clka), .Q(state[2]) );
  DFFNEGX1 \state_reg[1]  ( .D(N100), .CLK(clka), .Q(state[1]) );
  DFFNEGX1 counter_en_reg ( .D(n4), .CLK(n76), .Q(counter_en) );
  DFFNEGX1 \shifter_op_reg[1]  ( .D(N189), .CLK(n76), .Q(shifter_op[1]) );
  DFFNEGX1 \shifter_op_reg[0]  ( .D(N188), .CLK(n76), .Q(shifter_op[0]) );
  DFFNEGX1 out_port_en_reg ( .D(N184), .CLK(n76), .Q(out_port_en) );
  DFFNEGX1 pc_write_reg ( .D(N176), .CLK(n76), .Q(pc_write) );
  DFFNEGX1 pc_src_reg ( .D(n9), .CLK(n76), .Q(pc_src) );
  DFFNEGX1 ir_load_reg ( .D(n5), .CLK(n76), .Q(ir_load) );
  DFFNEGX1 reg_write_reg ( .D(N190), .CLK(n76), .Q(reg_write) );
  DFFNEGX1 \alu_op_reg[3]  ( .D(n10), .CLK(n76), .Q(alu_op[3]) );
  DFFNEGX1 \alu_op_reg[2]  ( .D(N181), .CLK(n76), .Q(alu_op[2]) );
  DFFNEGX1 \alu_op_reg[1]  ( .D(N180), .CLK(n76), .Q(alu_op[1]) );
  DFFNEGX1 \alu_op_reg[0]  ( .D(N179), .CLK(n76), .Q(alu_op[0]) );
  DFFNEGX1 alu_src_reg ( .D(N183), .CLK(n76), .Q(alu_src) );
  DFFNEGX1 mem_read_reg ( .D(N185), .CLK(n76), .Q(mem_read) );
  DFFNEGX1 mem_write_reg ( .D(n3), .CLK(n76), .Q(mem_write) );
  DFFNEGX1 mem_to_reg_reg ( .D(N191), .CLK(n76), .Q(mem_to_reg) );
  DFFNEGX1 shifter_en_reg ( .D(n4), .CLK(n76), .Q(shifter_en) );
  AND2X2 U3 ( .A(n4), .B(n37), .Y(N189) );
  AND2X2 U4 ( .A(mmio_addr), .B(n3), .Y(N184) );
  AND2X2 U5 ( .A(n69), .B(n14), .Y(N100) );
  INVX2 U6 ( .A(n26), .Y(n1) );
  INVX2 U7 ( .A(n60), .Y(n2) );
  INVX2 U8 ( .A(n46), .Y(n3) );
  INVX2 U9 ( .A(n41), .Y(n4) );
  INVX2 U10 ( .A(n55), .Y(n5) );
  INVX2 U11 ( .A(n36), .Y(n6) );
  INVX2 U12 ( .A(state[2]), .Y(n7) );
  INVX2 U13 ( .A(n51), .Y(n8) );
  INVX2 U14 ( .A(n56), .Y(n9) );
  INVX2 U15 ( .A(n50), .Y(n10) );
  INVX2 U16 ( .A(n73), .Y(n11) );
  INVX2 U17 ( .A(state[1]), .Y(n12) );
  INVX2 U18 ( .A(state[0]), .Y(n13) );
  INVX2 U19 ( .A(rst), .Y(n14) );
  INVX2 U20 ( .A(n32), .Y(n15) );
  INVX2 U21 ( .A(n68), .Y(n16) );
  INVX2 U22 ( .A(opcode[3]), .Y(n17) );
  INVX2 U23 ( .A(n42), .Y(n18) );
  INVX2 U24 ( .A(n29), .Y(n19) );
  INVX2 U25 ( .A(opcode[2]), .Y(n20) );
  INVX2 U26 ( .A(opcode[1]), .Y(n21) );
  INVX2 U27 ( .A(n74), .Y(n22) );
  INVX2 U28 ( .A(opcode[0]), .Y(n23) );
  INVX2 U29 ( .A(zero_flag), .Y(n24) );
  INVX2 U30 ( .A(counter_done), .Y(n25) );
  OAI21X1 U31 ( .A(n27), .B(n28), .C(n14), .Y(n26) );
  OAI21X1 U32 ( .A(n29), .B(n30), .C(n31), .Y(n28) );
  OAI21X1 U33 ( .A(n15), .B(n7), .C(n13), .Y(n31) );
  OAI21X1 U34 ( .A(n13), .B(n33), .C(n6), .Y(n27) );
  NAND2X1 U35 ( .A(state[2]), .B(n25), .Y(n33) );
  NOR2X1 U36 ( .A(n34), .B(n35), .Y(N191) );
  NAND3X1 U37 ( .A(opcode[0]), .B(opcode[2]), .C(n36), .Y(n35) );
  NAND3X1 U38 ( .A(n21), .B(n13), .C(opcode[3]), .Y(n34) );
  NOR2X1 U39 ( .A(state[0]), .B(n6), .Y(N190) );
  NOR2X1 U40 ( .A(n7), .B(n12), .Y(n36) );
  OAI21X1 U41 ( .A(n38), .B(n18), .C(n39), .Y(n37) );
  AOI21X1 U42 ( .A(n39), .B(n40), .C(n41), .Y(N188) );
  NAND3X1 U43 ( .A(opcode[1]), .B(n23), .C(n42), .Y(n40) );
  NAND2X1 U44 ( .A(n43), .B(state[0]), .Y(n41) );
  NOR2X1 U45 ( .A(n44), .B(n45), .Y(N185) );
  NAND2X1 U46 ( .A(n43), .B(n13), .Y(n45) );
  NAND3X1 U47 ( .A(n44), .B(n13), .C(n43), .Y(n46) );
  NAND3X1 U48 ( .A(opcode[0]), .B(opcode[2]), .C(n47), .Y(n44) );
  NOR2X1 U49 ( .A(opcode[1]), .B(n17), .Y(n47) );
  OAI21X1 U50 ( .A(n48), .B(n49), .C(n50), .Y(N183) );
  NAND2X1 U51 ( .A(n51), .B(opcode[2]), .Y(n49) );
  NAND2X1 U52 ( .A(opcode[3]), .B(n38), .Y(n48) );
  NOR2X1 U53 ( .A(n22), .B(n52), .Y(N181) );
  NAND2X1 U54 ( .A(n42), .B(n51), .Y(n52) );
  OAI21X1 U55 ( .A(n30), .B(n53), .C(n50), .Y(N180) );
  NAND3X1 U56 ( .A(opcode[0]), .B(n51), .C(n54), .Y(n50) );
  NOR2X1 U57 ( .A(opcode[2]), .B(n16), .Y(n54) );
  NAND2X1 U58 ( .A(opcode[1]), .B(n17), .Y(n53) );
  AOI21X1 U59 ( .A(n16), .B(n23), .C(n30), .Y(N179) );
  NAND2X1 U60 ( .A(n51), .B(n20), .Y(n30) );
  NAND2X1 U61 ( .A(n55), .B(n56), .Y(N176) );
  NAND3X1 U62 ( .A(n51), .B(opcode[3]), .C(n57), .Y(n56) );
  AOI21X1 U63 ( .A(n58), .B(n59), .C(opcode[2]), .Y(n57) );
  NAND3X1 U64 ( .A(n23), .B(n24), .C(opcode[1]), .Y(n59) );
  NAND3X1 U65 ( .A(opcode[0]), .B(n21), .C(zero_flag), .Y(n58) );
  NAND3X1 U66 ( .A(n12), .B(n7), .C(state[0]), .Y(n55) );
  OAI21X1 U67 ( .A(n61), .B(n62), .C(n14), .Y(n60) );
  OAI21X1 U68 ( .A(n7), .B(n13), .C(n63), .Y(n62) );
  OAI21X1 U69 ( .A(opcode[2]), .B(n29), .C(n51), .Y(n63) );
  OAI21X1 U70 ( .A(n64), .B(n11), .C(n65), .Y(n61) );
  AOI21X1 U71 ( .A(n66), .B(opcode[0]), .C(n67), .Y(n64) );
  NOR2X1 U72 ( .A(n16), .B(n20), .Y(n66) );
  OAI21X1 U73 ( .A(n19), .B(n8), .C(n70), .Y(n69) );
  AOI22X1 U74 ( .A(n71), .B(n13), .C(state[0]), .D(n72), .Y(n70) );
  OAI22X1 U75 ( .A(n73), .B(n43), .C(state[1]), .D(n25), .Y(n72) );
  OAI21X1 U76 ( .A(n11), .B(n67), .C(n65), .Y(n71) );
  NAND2X1 U77 ( .A(n43), .B(n32), .Y(n65) );
  NAND3X1 U78 ( .A(n68), .B(n23), .C(opcode[2]), .Y(n32) );
  NOR2X1 U79 ( .A(n17), .B(n21), .Y(n68) );
  NOR2X1 U80 ( .A(n7), .B(state[1]), .Y(n43) );
  OAI21X1 U81 ( .A(n74), .B(n18), .C(n39), .Y(n67) );
  NAND3X1 U82 ( .A(opcode[3]), .B(n20), .C(n74), .Y(n39) );
  NOR2X1 U83 ( .A(n20), .B(opcode[3]), .Y(n42) );
  NOR2X1 U84 ( .A(n11), .B(n13), .Y(n51) );
  NOR2X1 U85 ( .A(n12), .B(state[2]), .Y(n73) );
  NAND3X1 U86 ( .A(n38), .B(n22), .C(opcode[3]), .Y(n29) );
  NOR2X1 U87 ( .A(opcode[1]), .B(opcode[0]), .Y(n74) );
  NAND2X1 U88 ( .A(opcode[0]), .B(opcode[1]), .Y(n38) );
  INVX1 U89 ( .A(clkb), .Y(n75) );
  INVX2 U90 ( .A(n75), .Y(n76) );
endmodule

