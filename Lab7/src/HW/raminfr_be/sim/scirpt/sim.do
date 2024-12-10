vlib work
vcom -2008 -work work ../../src/raminfr.vhd
vcom -2008 -work work ../../src/raminfr_be.vhd
vcom -2008 -work work ../src/raminfr_be_tb.vhd
vsim -voptargs=+acc raminfr_be_tb
do wave.do
run 573500 ns
