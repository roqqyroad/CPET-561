vlib work
vcom -93 -work work ../../src/MULT/MULT.vhd
vcom -93 -work work ../../src/generic_laterial_shift.vhd
vcom -93 -work work ../../src/filter_base_16_tap.vhd
vcom -93 -work work ../src/filter_base_16_tap_tb.vhd
vsim -voptargs=+acc filter_base_16_tap_tb
do wave.do
run 20000 ns
