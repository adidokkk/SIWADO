/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : U-2022.12-SP7
// Date      : Sat Apr  4 21:09:40 2026
/////////////////////////////////////////////////////////////


module control_fsm ( clka, clkb, rst, opcode, zero_flag, counter_done, 
        mmio_addr, pc_write, pc_src, ir_load, reg_write, alu_op, alu_src, 
        mem_read, mem_write, mem_to_reg, shifter_en, shifter_op, out_port_en, 
        error_flag_fsm );
  input [3:0] opcode;
  output [3:0] alu_op;
  output [1:0] shifter_op;
  input clka, clkb, rst, zero_flag, counter_done, mmio_addr;
  output pc_write, pc_src, ir_load, reg_write, alu_src, mem_read, mem_write,
         mem_to_reg, shifter_en, out_port_en, error_flag_fsm;
  wire   N118, N120, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
         n14, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27,
         n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
         n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55,
         n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69,
         n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83,
         n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120,
         n121, n122, n123, n124, n125, n126, n127, n128, n129, n130, n131,
         n132, n133, n134, n135, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156;
  wire   [3:0] state;

  DFFNEGX1 \state_reg[0]  ( .D(n2), .CLK(clka), .Q(state[0]) );
  DFFNEGX1 \state_reg[3]  ( .D(N120), .CLK(clka), .Q(state[3]) );
  DFFNEGX1 \state_reg[1]  ( .D(N118), .CLK(clka), .Q(state[1]) );
  DFFNEGX1 \state_reg[2]  ( .D(n4), .CLK(clka), .Q(state[2]) );
  DFFNEGX1 out_port_en_reg ( .D(n152), .CLK(n154), .Q(out_port_en) );
  DFFNEGX1 mem_write_reg ( .D(n151), .CLK(n154), .Q(mem_write) );
  DFFNEGX1 mem_to_reg_reg ( .D(n150), .CLK(n154), .Q(mem_to_reg) );
  DFFNEGX1 shifter_en_reg ( .D(n149), .CLK(n154), .Q(shifter_en) );
  DFFNEGX1 \shifter_op_reg[1]  ( .D(n148), .CLK(n154), .Q(shifter_op[1]) );
  DFFNEGX1 \shifter_op_reg[0]  ( .D(n147), .CLK(n154), .Q(shifter_op[0]) );
  DFFNEGX1 error_flag_fsm_reg ( .D(n146), .CLK(n154), .Q(error_flag_fsm) );
  DFFNEGX1 reg_write_reg ( .D(n145), .CLK(n154), .Q(reg_write) );
  DFFNEGX1 pc_src_reg ( .D(n144), .CLK(n154), .Q(pc_src) );
  DFFNEGX1 pc_write_reg ( .D(n143), .CLK(n154), .Q(pc_write) );
  DFFNEGX1 ir_load_reg ( .D(n142), .CLK(n154), .Q(ir_load) );
  DFFNEGX1 \alu_op_reg[3]  ( .D(n6), .CLK(n154), .Q(alu_op[3]) );
  DFFNEGX1 \alu_op_reg[2]  ( .D(n141), .CLK(n154), .Q(alu_op[2]) );
  DFFNEGX1 \alu_op_reg[1]  ( .D(n140), .CLK(n154), .Q(alu_op[1]) );
  DFFNEGX1 \alu_op_reg[0]  ( .D(n139), .CLK(n154), .Q(alu_op[0]) );
  DFFNEGX1 alu_src_reg ( .D(n138), .CLK(n154), .Q(alu_src) );
  DFFNEGX1 mem_read_reg ( .D(n137), .CLK(n154), .Q(mem_read) );
  AND2X2 U3 ( .A(n124), .B(n14), .Y(n123) );
  AND2X2 U4 ( .A(n85), .B(n9), .Y(n135) );
  INVX2 U5 ( .A(n84), .Y(n1) );
  INVX2 U6 ( .A(n125), .Y(n2) );
  INVX2 U7 ( .A(n129), .Y(n3) );
  INVX2 U8 ( .A(n120), .Y(n4) );
  INVX2 U9 ( .A(n45), .Y(n5) );
  INVX2 U10 ( .A(n57), .Y(n6) );
  INVX2 U11 ( .A(n48), .Y(n7) );
  INVX2 U12 ( .A(n55), .Y(n8) );
  INVX2 U13 ( .A(n113), .Y(n9) );
  INVX2 U14 ( .A(n111), .Y(n10) );
  INVX2 U15 ( .A(n67), .Y(n11) );
  INVX2 U16 ( .A(n100), .Y(n12) );
  INVX2 U17 ( .A(n99), .Y(n13) );
  INVX2 U18 ( .A(n96), .Y(n14) );
  INVX2 U19 ( .A(n81), .Y(n15) );
  INVX2 U20 ( .A(n119), .Y(n16) );
  INVX2 U21 ( .A(state[3]), .Y(n17) );
  INVX2 U22 ( .A(n94), .Y(n18) );
  INVX2 U23 ( .A(state[2]), .Y(n19) );
  INVX2 U24 ( .A(n109), .Y(n20) );
  INVX2 U25 ( .A(state[1]), .Y(n21) );
  INVX2 U26 ( .A(state[0]), .Y(n22) );
  INVX2 U27 ( .A(out_port_en), .Y(n23) );
  INVX2 U28 ( .A(shifter_en), .Y(n24) );
  INVX2 U29 ( .A(shifter_op[1]), .Y(n25) );
  INVX2 U30 ( .A(shifter_op[0]), .Y(n26) );
  INVX2 U31 ( .A(reg_write), .Y(n27) );
  INVX2 U32 ( .A(pc_src), .Y(n28) );
  INVX2 U33 ( .A(alu_op[1]), .Y(n29) );
  INVX2 U34 ( .A(alu_op[0]), .Y(n30) );
  INVX2 U36 ( .A(n47), .Y(n32) );
  INVX2 U37 ( .A(n43), .Y(n33) );
  INVX2 U38 ( .A(opcode[3]), .Y(n34) );
  INVX2 U39 ( .A(n133), .Y(n35) );
  INVX2 U40 ( .A(n103), .Y(n36) );
  INVX2 U41 ( .A(n118), .Y(n37) );
  INVX2 U42 ( .A(opcode[2]), .Y(n38) );
  INVX2 U43 ( .A(n156), .Y(n39) );
  INVX2 U44 ( .A(n64), .Y(n40) );
  INVX2 U46 ( .A(zero_flag), .Y(n42) );
  OAI21X1 U47 ( .A(n9), .B(n43), .C(n44), .Y(n137) );
  NAND3X1 U48 ( .A(n11), .B(n31), .C(mem_read), .Y(n44) );
  OAI21X1 U49 ( .A(n32), .B(n45), .C(n46), .Y(n138) );
  NAND2X1 U50 ( .A(alu_src), .B(n7), .Y(n46) );
  OAI21X1 U51 ( .A(n48), .B(n30), .C(n49), .Y(n139) );
  AOI21X1 U52 ( .A(n5), .B(n50), .C(n51), .Y(n49) );
  OAI21X1 U53 ( .A(n41), .B(n52), .C(n53), .Y(n50) );
  OAI21X1 U54 ( .A(n48), .B(n29), .C(n54), .Y(n140) );
  AOI21X1 U55 ( .A(n55), .B(n156), .C(n51), .Y(n54) );
  OAI21X1 U56 ( .A(n38), .B(n8), .C(n56), .Y(n141) );
  NAND2X1 U57 ( .A(alu_op[2]), .B(n7), .Y(n56) );
  NOR2X1 U58 ( .A(n52), .B(n45), .Y(n55) );
  AOI21X1 U59 ( .A(n7), .B(alu_op[3]), .C(n51), .Y(n57) );
  NOR2X1 U60 ( .A(n58), .B(n45), .Y(n51) );
  OAI21X1 U61 ( .A(n59), .B(n45), .C(n31), .Y(n48) );
  NOR2X1 U62 ( .A(n47), .B(n60), .Y(n59) );
  NAND2X1 U63 ( .A(n53), .B(n52), .Y(n60) );
  NAND2X1 U64 ( .A(n61), .B(n34), .Y(n52) );
  OAI21X1 U65 ( .A(n156), .B(n155), .C(opcode[2]), .Y(n61) );
  OAI21X1 U66 ( .A(n62), .B(n38), .C(n58), .Y(n47) );
  NAND3X1 U67 ( .A(n156), .B(n155), .C(n63), .Y(n58) );
  NOR2X1 U68 ( .A(opcode[2]), .B(n34), .Y(n63) );
  AOI21X1 U69 ( .A(opcode[3]), .B(n64), .C(n65), .Y(n62) );
  NAND2X1 U70 ( .A(n66), .B(n11), .Y(n142) );
  NAND3X1 U71 ( .A(n68), .B(n31), .C(ir_load), .Y(n66) );
  OAI21X1 U72 ( .A(n69), .B(n70), .C(n71), .Y(n143) );
  AOI21X1 U73 ( .A(n72), .B(n73), .C(n67), .Y(n71) );
  AOI21X1 U74 ( .A(n74), .B(n75), .C(opcode[2]), .Y(n73) );
  NAND3X1 U75 ( .A(n41), .B(n42), .C(n156), .Y(n75) );
  NAND3X1 U76 ( .A(n155), .B(n39), .C(zero_flag), .Y(n74) );
  NOR2X1 U77 ( .A(n34), .B(n15), .Y(n72) );
  OAI21X1 U78 ( .A(n53), .B(n76), .C(pc_write), .Y(n70) );
  OR2X1 U79 ( .A(n77), .B(n78), .Y(n76) );
  NAND2X1 U80 ( .A(n68), .B(n31), .Y(n69) );
  NAND3X1 U81 ( .A(n79), .B(n19), .C(n78), .Y(n68) );
  NOR2X1 U82 ( .A(n21), .B(state[0]), .Y(n78) );
  OAI21X1 U83 ( .A(n28), .B(n80), .C(n15), .Y(n144) );
  OAI21X1 U84 ( .A(n82), .B(n83), .C(n31), .Y(n80) );
  NAND2X1 U85 ( .A(state[0]), .B(n79), .Y(n83) );
  NAND2X1 U86 ( .A(n21), .B(n19), .Y(n82) );
  OAI21X1 U87 ( .A(n84), .B(n27), .C(n85), .Y(n145) );
  NAND2X1 U88 ( .A(n86), .B(n87), .Y(n146) );
  AOI21X1 U89 ( .A(n81), .B(n53), .C(n88), .Y(n87) );
  OAI21X1 U90 ( .A(n18), .B(n17), .C(n89), .Y(n88) );
  OAI21X1 U91 ( .A(n90), .B(n91), .C(n5), .Y(n89) );
  OAI21X1 U92 ( .A(n38), .B(n92), .C(n93), .Y(n91) );
  OR2X1 U93 ( .A(n41), .B(n65), .Y(n92) );
  NOR2X1 U94 ( .A(n39), .B(n36), .Y(n90) );
  NAND3X1 U95 ( .A(n64), .B(n38), .C(opcode[3]), .Y(n53) );
  NOR2X1 U96 ( .A(n77), .B(state[1]), .Y(n81) );
  AOI22X1 U97 ( .A(n95), .B(n96), .C(error_flag_fsm), .D(n31), .Y(n86) );
  OAI21X1 U98 ( .A(n97), .B(n26), .C(n98), .Y(n147) );
  AOI21X1 U99 ( .A(n35), .B(n96), .C(n99), .Y(n98) );
  OAI21X1 U100 ( .A(n25), .B(n97), .C(n12), .Y(n148) );
  OAI21X1 U101 ( .A(n101), .B(n102), .C(n13), .Y(n100) );
  NOR2X1 U102 ( .A(n93), .B(n14), .Y(n99) );
  NAND2X1 U103 ( .A(n96), .B(n103), .Y(n102) );
  NAND2X1 U104 ( .A(n156), .B(n155), .Y(n101) );
  OAI21X1 U105 ( .A(n95), .B(n14), .C(n31), .Y(n97) );
  OAI21X1 U106 ( .A(n24), .B(n104), .C(n14), .Y(n149) );
  OAI21X1 U107 ( .A(n21), .B(n105), .C(n31), .Y(n104) );
  NAND2X1 U108 ( .A(state[2]), .B(n79), .Y(n105) );
  OAI21X1 U109 ( .A(n43), .B(n85), .C(n106), .Y(n150) );
  NAND2X1 U110 ( .A(mem_to_reg), .B(n1), .Y(n106) );
  OAI21X1 U111 ( .A(n107), .B(n108), .C(n31), .Y(n84) );
  OAI21X1 U112 ( .A(state[1]), .B(n19), .C(state[0]), .Y(n108) );
  NAND2X1 U113 ( .A(n79), .B(n20), .Y(n107) );
  OAI21X1 U114 ( .A(n33), .B(n9), .C(n110), .Y(n151) );
  NAND2X1 U115 ( .A(mem_write), .B(n10), .Y(n110) );
  OAI21X1 U116 ( .A(n111), .B(n23), .C(n112), .Y(n152) );
  NAND3X1 U117 ( .A(n113), .B(n43), .C(mmio_addr), .Y(n112) );
  OAI21X1 U118 ( .A(n33), .B(n114), .C(n115), .Y(n111) );
  NOR2X1 U119 ( .A(rst), .B(n67), .Y(n115) );
  NAND3X1 U120 ( .A(n155), .B(n65), .C(opcode[2]), .Y(n43) );
  OAI21X1 U121 ( .A(n94), .B(n79), .C(n116), .Y(N120) );
  NAND3X1 U122 ( .A(n16), .B(n37), .C(n117), .Y(n116) );
  NOR2X1 U123 ( .A(rst), .B(n41), .Y(n117) );
  NAND2X1 U124 ( .A(state[3]), .B(n31), .Y(n79) );
  NAND3X1 U125 ( .A(n21), .B(n19), .C(n22), .Y(n94) );
  OAI21X1 U126 ( .A(n121), .B(n5), .C(n31), .Y(n120) );
  AOI21X1 U127 ( .A(n122), .B(n3), .C(rst), .Y(N118) );
  NOR2X1 U128 ( .A(n67), .B(n121), .Y(n122) );
  OAI21X1 U129 ( .A(n95), .B(n119), .C(n123), .Y(n121) );
  OAI21X1 U130 ( .A(n155), .B(n118), .C(n113), .Y(n124) );
  NOR2X1 U131 ( .A(n114), .B(state[2]), .Y(n67) );
  OAI21X1 U132 ( .A(n126), .B(n127), .C(n31), .Y(n125) );
  NAND2X1 U133 ( .A(n128), .B(n3), .Y(n127) );
  OAI21X1 U134 ( .A(n119), .B(n130), .C(n131), .Y(n129) );
  OAI21X1 U135 ( .A(n40), .B(n34), .C(n5), .Y(n131) );
  XNOR2X1 U136 ( .A(n156), .B(n41), .Y(n64) );
  OAI21X1 U137 ( .A(n41), .B(n118), .C(n95), .Y(n130) );
  NOR2X1 U138 ( .A(n35), .B(n132), .Y(n95) );
  OAI21X1 U139 ( .A(n41), .B(n36), .C(n93), .Y(n132) );
  NAND3X1 U140 ( .A(n41), .B(n38), .C(n65), .Y(n93) );
  NOR2X1 U141 ( .A(n34), .B(n156), .Y(n65) );
  NAND3X1 U142 ( .A(n156), .B(n41), .C(n103), .Y(n133) );
  NOR2X1 U143 ( .A(n38), .B(opcode[3]), .Y(n103) );
  NAND3X1 U144 ( .A(opcode[2]), .B(opcode[3]), .C(n156), .Y(n118) );
  NAND3X1 U145 ( .A(n22), .B(n17), .C(n109), .Y(n119) );
  AOI22X1 U146 ( .A(n134), .B(n22), .C(counter_done), .D(n96), .Y(n128) );
  NOR2X1 U147 ( .A(n77), .B(n21), .Y(n96) );
  NAND3X1 U148 ( .A(n22), .B(n17), .C(state[2]), .Y(n77) );
  NOR2X1 U149 ( .A(state[3]), .B(state[1]), .Y(n134) );
  OAI21X1 U150 ( .A(n38), .B(n45), .C(n135), .Y(n126) );
  NOR2X1 U151 ( .A(n19), .B(n114), .Y(n113) );
  NAND3X1 U152 ( .A(n21), .B(n17), .C(state[0]), .Y(n114) );
  NAND3X1 U153 ( .A(state[1]), .B(state[2]), .C(n136), .Y(n85) );
  NOR2X1 U154 ( .A(state[3]), .B(n22), .Y(n136) );
  NAND3X1 U155 ( .A(state[0]), .B(n17), .C(n109), .Y(n45) );
  NOR2X1 U156 ( .A(n21), .B(state[2]), .Y(n109) );
  INVX1 U157 ( .A(clkb), .Y(n153) );
  INVX2 U158 ( .A(n153), .Y(n154) );
  INVX2 U159 ( .A(n155), .Y(n41) );
  BUFX2 U160 ( .A(opcode[1]), .Y(n156) );
  BUFX2 U161 ( .A(opcode[0]), .Y(n155) );
  INVX2 U162 ( .A(rst), .Y(n31) );
endmodule

