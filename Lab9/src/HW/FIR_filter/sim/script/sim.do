vlib work
vcom -93 -work work ../../src/HW/filter_base_16_tap/src/MULT/MULT.vhd
vcom -93 -work work ../../src/HW/filter_base_16_tap/src/generic_laterial_shift.vhd
vcom -93 -work work ../../src/HW/filter_base_16_tap/src/filter_base_16_tap.vhd
vcom -93 -work work ../../src/HW/FIR_filter.vhd
vcom -93 -work work ../src/FIR_filter_tb.vhd
vsim -voptargs=+acc FIR_filter_tb
do wave.do
run 80000 ns
