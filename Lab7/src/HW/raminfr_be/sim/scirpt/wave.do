onerror {resume}

quietly WaveActivateNextPane {} 0
add wave -noupdate                    /raminfr_be_tb/clk
add wave -noupdate                    /raminfr_be_tb/reset_n
add wave -noupdate                    /raminfr_be_tb/writebyteenable_n
add wave -noupdate                    /raminfr_be_tb/address
add wave -noupdate                    /raminfr_be_tb/writedata 
add wave -noupdate                    /raminfr_be_tb/readdata
add wave -noupdate                    /raminfr_be_tb/stimulus/check
add wave -noupdate                    /raminfr_be_tb/DONE
add wave -noupdate                    /raminfr_be_tb/flag
add wave -noupdate                    /raminfr_be_tb/uut/ram_4bytes(0)/ram_block/RAM
add wave -noupdate                    /raminfr_be_tb/uut/ram_4bytes(1)/ram_block/RAM
add wave -noupdate                    /raminfr_be_tb/uut/ram_4bytes(2)/ram_block/RAM
add wave -noupdate                    /raminfr_be_tb/uut/ram_4bytes(3)/ram_block/RAM

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

