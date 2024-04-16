onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_stateMachine_tb/clk
add wave -noupdate /top_stateMachine_tb/reset
add wave -noupdate /top_stateMachine_tb/state
add wave -noupdate /top_stateMachine_tb/dut/tempo_counter
add wave -noupdate /top_stateMachine_tb/dut/ps
add wave -noupdate /top_stateMachine_tb/dut/ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 2
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
