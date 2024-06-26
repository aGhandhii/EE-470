onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/reset
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch1_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch2_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch3_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -radix unsigned /top_tb/dut/ch4_ROM_ptr
add wave -noupdate -expand -group {Audio ROM} -group {Channel Settings} /top_tb/dut/ch1_settings
add wave -noupdate -expand -group {Audio ROM} -group {Channel Settings} /top_tb/dut/ch2_settings
add wave -noupdate -expand -group {Audio ROM} -group {Channel Settings} /top_tb/dut/ch3_settings
add wave -noupdate -expand -group {Audio ROM} -group {Channel Settings} /top_tb/dut/ch4_settings
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/APU/channel_4/enable
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/APU/channel_4/reset
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/APU/channel_4/lfsr
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/APU/channel_4/frequencyTimer
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_length
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_volume
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_shift_clock_freq
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_counter_width
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_freq_dividing_ratio
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_start
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/ch4_enable
add wave -noupdate -expand -group {Audio ROM} -group {Noise Channel Specs} /top_tb/dut/APU/channel_4/level
add wave -noupdate /top_tb/ch1
add wave -noupdate /top_tb/ch2
add wave -noupdate /top_tb/ch3
add wave -noupdate /top_tb/ch4
add wave -noupdate /top_tb/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50293006 ps} 0}
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
WaveRestoreZoom {0 ps} {168000042 ps}
