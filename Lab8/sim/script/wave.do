onerror {resume}

quietly WaveActivateNextPane {} 0
add wave -noupdate                    /Lab8_tb/uut/filter/clk
add wave -noupdate                    /Lab8_tb/uut/filter/reset
add wave -noupdate                    /Lab8_tb/uut/filter/filter_en
add wave -noupdate                    /Lab8_tb/uut/filter/filter_type
add wave -noupdate                    /Lab8_tb/uut/memory
add wave -noupdate                    /Lab8_tb/uut/filter_type
add wave -noupdate                    /Lab8_tb/uut/filter/coeff_q
add wave -noupdate                    /Lab8_tb/uut/filter/bypass
add wave -noupdate                    /Lab8_tb/uut/filter/low_pass
add wave -noupdate                    /Lab8_tb/uut/filter/high_pass
add wave -noupdate                    /Lab8_tb/uut/filter/mov_avg

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {887 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ns} {12000 ns}

