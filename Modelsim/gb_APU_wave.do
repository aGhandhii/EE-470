onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /gb_APU_tb/clk
add wave -noupdate /gb_APU_tb/dut/clk_length_ctr
add wave -noupdate /gb_APU_tb/dut/clk_vol_env
add wave -noupdate /gb_APU_tb/dut/clk_sweep
add wave -noupdate /gb_APU_tb/reset
add wave -noupdate -group {CH 1} /gb_APU_tb/ch1_volume
add wave -noupdate -group {CH 1} /gb_APU_tb/ch1_frequency
add wave -noupdate -group {CH 1} /gb_APU_tb/dut/channel_1/pulse_frequency
add wave -noupdate -group {CH 1} /gb_APU_tb/dut/channel_1/level
add wave -noupdate -group {CH 1} /gb_APU_tb/ch1_start
add wave -noupdate -group {CH 1} /gb_APU_tb/ch1_enable
add wave -noupdate -group {CH 2} /gb_APU_tb/ch2_volume
add wave -noupdate -group {CH 2} /gb_APU_tb/ch2_frequency
add wave -noupdate -group {CH 2} /gb_APU_tb/dut/channel_2/pulse_frequency
add wave -noupdate -group {CH 2} /gb_APU_tb/dut/channel_2/level
add wave -noupdate -group {CH 2} /gb_APU_tb/ch2_start
add wave -noupdate -group {CH 2} /gb_APU_tb/ch2_enable
add wave -noupdate -group {CH 3} /gb_APU_tb/dut/customWave
add wave -noupdate -group {CH 3} /gb_APU_tb/dut/channel_3/current_pointer
add wave -noupdate -group {CH 3} /gb_APU_tb/dut/channel_3/current_sample
add wave -noupdate -group {CH 3} /gb_APU_tb/ch3_volume
add wave -noupdate -group {CH 3} /gb_APU_tb/ch3_frequency
add wave -noupdate -group {CH 3} /gb_APU_tb/dut/channel_3/level
add wave -noupdate -group {CH 3} /gb_APU_tb/ch3_start
add wave -noupdate -group {CH 3} /gb_APU_tb/ch3_enable
add wave -noupdate -group {CH 4} /gb_APU_tb/ch4_volume
add wave -noupdate -group {CH 4} /gb_APU_tb/ch4_shift_clock_freq
add wave -noupdate -group {CH 4} /gb_APU_tb/ch4_counter_width
add wave -noupdate -group {CH 4} /gb_APU_tb/ch4_freq_dividing_ratio
add wave -noupdate -group {CH 4} /gb_APU_tb/dut/channel_4/lfsr
add wave -noupdate -group {CH 4} /gb_APU_tb/dut/channel_4/lfsr_next
add wave -noupdate -group {CH 4} /gb_APU_tb/dut/channel_4/level
add wave -noupdate -group {CH 4} /gb_APU_tb/ch4_start
add wave -noupdate -group {CH 4} /gb_APU_tb/ch4_enable
add wave -noupdate /gb_APU_tb/sound_enable
add wave -noupdate /gb_APU_tb/sweep_enable
add wave -noupdate /gb_APU_tb/envelope_enable
add wave -noupdate /gb_APU_tb/dut/ch1
add wave -noupdate /gb_APU_tb/dut/ch2
add wave -noupdate /gb_APU_tb/dut/ch3
add wave -noupdate /gb_APU_tb/dut/ch4
add wave -noupdate /gb_APU_tb/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {127465130 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {210000032 ps}
