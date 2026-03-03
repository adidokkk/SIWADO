###################################################################

# Created by write_sdc on Mon Mar  2 23:21:26 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_driving_cell -lib_cell INVX1 [get_ports clka]
set_driving_cell -lib_cell INVX1 [get_ports clkb]
set_driving_cell -lib_cell INVX1 [get_ports rst]
set_driving_cell -lib_cell INVX1 [get_ports {opcode[3]}]
set_driving_cell -lib_cell INVX1 [get_ports {opcode[2]}]
set_driving_cell -lib_cell INVX1 [get_ports {opcode[1]}]
set_driving_cell -lib_cell INVX1 [get_ports {opcode[0]}]
set_driving_cell -lib_cell INVX1 [get_ports zero_flag]
set_driving_cell -lib_cell INVX1 [get_ports counter_done]
set_driving_cell -lib_cell INVX1 [get_ports mmio_addr]
create_clock [get_ports clka]  -period 20  -waveform {0 10}
set_input_delay -clock clka  1  [get_ports clkb]
set_input_delay -clock clka  1  [get_ports rst]
set_input_delay -clock clka  1  [get_ports {opcode[3]}]
set_input_delay -clock clka  1  [get_ports {opcode[2]}]
set_input_delay -clock clka  1  [get_ports {opcode[1]}]
set_input_delay -clock clka  1  [get_ports {opcode[0]}]
set_input_delay -clock clka  1  [get_ports zero_flag]
set_input_delay -clock clka  1  [get_ports counter_done]
set_input_delay -clock clka  1  [get_ports mmio_addr]
set_output_delay -clock clka  1  [get_ports pc_write]
set_output_delay -clock clka  1  [get_ports pc_src]
set_output_delay -clock clka  1  [get_ports ir_load]
set_output_delay -clock clka  1  [get_ports reg_write]
set_output_delay -clock clka  1  [get_ports {alu_op[3]}]
set_output_delay -clock clka  1  [get_ports {alu_op[2]}]
set_output_delay -clock clka  1  [get_ports {alu_op[1]}]
set_output_delay -clock clka  1  [get_ports {alu_op[0]}]
set_output_delay -clock clka  1  [get_ports alu_src]
set_output_delay -clock clka  1  [get_ports mem_read]
set_output_delay -clock clka  1  [get_ports mem_write]
set_output_delay -clock clka  1  [get_ports mem_to_reg]
set_output_delay -clock clka  1  [get_ports shifter_en]
set_output_delay -clock clka  1  [get_ports counter_en]
set_output_delay -clock clka  1  [get_ports {shifter_op[1]}]
set_output_delay -clock clka  1  [get_ports {shifter_op[0]}]
set_output_delay -clock clka  1  [get_ports out_port_en]
