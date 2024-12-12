vlib work
vcom -93 -work work ../../DE1_Soc_Lab6/Quartus/part3/raminfr_be.vhd
vcom -93 -work work ../../DE1_Soc_Lab6/Quartus/part3/raminfr_be_tb.vhd
vsim -voptargs=+acc -msgmode both raminfr_be_tb
do wave.do
run 1000 us