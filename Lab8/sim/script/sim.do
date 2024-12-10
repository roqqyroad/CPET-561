vlib work
vcom -93 -work work ../../src/HW/filter_base_16_tap/src/MULT/MULT.vhd
vcom -93 -work work ../../src/HW/filter_base_16_tap/src/generic_laterial_shift.vhd
vcom -93 -work work ../../src/HW/filter_base_16_tap/src/filter_base_16_tap.vhd
vcom -93 -work work ../../src/HW/lab8_top.vhd
vcom -93 -work work ../src/Lab8_tb.vhd
vsim -voptargs=+acc Lab8_tb
do wave.do
run 80000 ns
