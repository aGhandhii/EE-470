onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/reset
add wave -noupdate /top_tb/dut/reset
add wave -noupdate /top_tb/dut/APU/reset
add wave -noupdate /top_tb/dut/state
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch1_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch2_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch3_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch4_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} /top_tb/dut/ch1_settings
add wave -noupdate -expand -group {Audio ROM} /top_tb/dut/ch2_settings
add wave -noupdate -expand -group {Audio ROM} /top_tb/dut/ch3_settings
add wave -noupdate -expand -group {Audio ROM} /top_tb/dut/ch4_settings
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/APU/channel_4/enable
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/APU/channel_4/reset
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/APU/channel_4/lfsr
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/APU/channel_4/frequencyTimer
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_length
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_length_enable
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_volume
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_shift_clock_freq
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_counter_width
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_freq_dividing_ratio
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_start
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/ch4_enable
add wave -noupdate -expand -group {Audio ROM} -expand -group {CH4 Settings} /top_tb/dut/APU/channel_4/level
add wave -noupdate /top_tb/dut/APU/ch1
add wave -noupdate /top_tb/dut/APU/ch2
add wave -noupdate /top_tb/dut/APU/ch3
add wave -noupdate /top_tb/dut/APU/ch4
add wave -noupdate /top_tb/dut/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1199848 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
configure wave -valuecolwidth 146
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
WaveRestoreZoom {1199777 ps} {1200033 ps}
