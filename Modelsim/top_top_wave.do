onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_top_tb/sysclk
add wave -noupdate /top_top_tb/dut/top/clk
add wave -noupdate -expand -group FrameSequencer /top_top_tb/dut/top/APU/APUclockDivider/clk
add wave -noupdate -expand -group FrameSequencer /top_top_tb/dut/top/APU/APUclockDivider/reset
add wave -noupdate -expand -group FrameSequencer /top_top_tb/dut/top/APU/APUclockDivider/length_clk
add wave -noupdate -expand -group FrameSequencer /top_top_tb/dut/top/APU/APUclockDivider/envelope_clk
add wave -noupdate -expand -group FrameSequencer /top_top_tb/dut/top/APU/APUclockDivider/sweep_clk
add wave -noupdate /top_top_tb/dut/top/APU/APUclockDivider/div
add wave -noupdate /top_top_tb/dut/top/reset
add wave -noupdate /top_top_tb/dut/top/sweep_enable
add wave -noupdate /top_top_tb/dut/top/envelope_enable
add wave -noupdate -expand -group {PWM Outputs} /top_top_tb/pwm_aud
add wave -noupdate -expand -group {PWM Outputs} /top_top_tb/pwm_aud_1
add wave -noupdate -expand -group {PWM Outputs} /top_top_tb/pwm_aud_2
add wave -noupdate -expand -group {PWM Outputs} /top_top_tb/pwm_aud_3
add wave -noupdate -expand -group {PWM Outputs} /top_top_tb/pwm_aud_4
add wave -noupdate -expand -group {ROM Pointers} /top_top_tb/dut/top/ch1_ROM_ptr
add wave -noupdate -expand -group {ROM Pointers} /top_top_tb/dut/top/ch2_ROM_ptr
add wave -noupdate -expand -group {ROM Pointers} /top_top_tb/dut/top/ch3_ROM_ptr
add wave -noupdate -expand -group {ROM Pointers} /top_top_tb/dut/top/ch4_ROM_ptr
add wave -noupdate -expand -group {Channel Outputs} /top_top_tb/dut/top/ch1
add wave -noupdate -expand -group {Channel Outputs} /top_top_tb/dut/top/ch2
add wave -noupdate -expand -group {Channel Outputs} /top_top_tb/dut/top/ch3
add wave -noupdate -expand -group {Channel Outputs} /top_top_tb/dut/top/ch4
add wave -noupdate -expand -group {Channel Outputs} /top_top_tb/dut/top/audio_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {38664490 ps} 0}
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
WaveRestoreZoom {0 ps} {437519229 ps}
