onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab_4_servo_controller_tb/UUT/clk
add wave -noupdate /lab_4_servo_controller_tb/UUT/reset_n
add wave -noupdate /lab_4_servo_controller_tb/UUT/address_bit
add wave -noupdate /lab_4_servo_controller_tb/UUT/write
add wave -noupdate -radix decimal /lab_4_servo_controller_tb/UUT/write_data
add wave -noupdate /lab_4_servo_controller_tb/UUT/irq
add wave -noupdate -color Yellow /lab_4_servo_controller_tb/UUT/pwm_out
add wave -noupdate -color green /lab_4_servo_controller_tb/UUT/current_state
add wave -noupdate -color blue /lab_4_servo_controller_tb/UUT/next_state
add wave -noupdate -color purple -radix decimal /lab_4_servo_controller_tb/UUT/up_angle_cnt
add wave -noupdate -color purple -radix decimal /lab_4_servo_controller_tb/UUT/down_angle_cnt
add wave -noupdate -color purple -radix decimal /lab_4_servo_controller_tb/UUT/period_cnt
add wave -noupdate -color orange -radix decimal /lab_4_servo_controller_tb/UUT/Current_Lower_Angle_Limit
add wave -noupdate -color orange -radix decimal /lab_4_servo_controller_tb/UUT/Current_Upper_Angle_Limit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {139841986 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 112
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1050 ms}
