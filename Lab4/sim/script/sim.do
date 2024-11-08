vlib work
vcom -93 -work work ../../src/servo_controller.vhd
vcom -93 -work work ../src/lab_4_servo_Controller_tb.vhd
vsim -voptargs=+acc lab_4_servo_Controller_tb
do wave.do
run 1000 ms
