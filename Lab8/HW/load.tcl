# Dr. Kaputa
# Quartus II compile script for DE1-SoC board
set project_name "lab8_top"

cd project
load_package flow
project_open $project_name
# 1] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/HW/filter_base_16_tap/src/filter_base_16_tap.vhd
set_global_assignment -name VHDL_FILE ../../src/HW/filter_base_16_tap/src/generic_laterial_shift.vhd
set_global_assignment -name VHDL_FILE ../../src/HW/lab8_top.vhd
set_global_assignment -name QIP_FILE ../../src/HW/filter_base_16_tap/src/MULT/MULT.qip

#execute_flow -compile
project_close


