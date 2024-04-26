onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /gb_pulseChannel_tb/reset
add wave -noupdate /gb_pulseChannel_tb/clk
add wave -noupdate /gb_pulseChannel_tb/start
add wave -noupdate /gb_pulseChannel_tb/dut/start_posedge
add wave -noupdate -expand -group Sweep /gb_pulseChannel_tb/clk_sweep
add wave -noupdate -expand -group Sweep /gb_pulseChannel_tb/sweep_time
add wave -noupdate -expand -group Sweep /gb_pulseChannel_tb/dut/sweepFuncion/new_frequency
add wave -noupdate -expand -group Sweep /gb_pulseChannel_tb/dut/pulse_frequency
add wave -noupdate -expand -group Sweep /gb_pulseChannel_tb/sweep_decreasing
add wave -noupdate -expand -group Sweep /gb_pulseChannel_tb/num_sweep_shifts
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/clk_length_ctr
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/single
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/dut/lengthFunction/start
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/length
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/dut/lengthFunction/length_left
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/dut/enable_length
add wave -noupdate -expand -group Length /gb_pulseChannel_tb/enable
add wave -noupdate -expand -group Envelope /gb_pulseChannel_tb/clk_vol_env
add wave -noupdate -expand -group Envelope /gb_pulseChannel_tb/initial_volume
add wave -noupdate -expand -group Envelope /gb_pulseChannel_tb/dut/envelopeFunction/target_vol
add wave -noupdate -expand -group Envelope /gb_pulseChannel_tb/envelope_increasing
add wave -noupdate -expand -group Envelope /gb_pulseChannel_tb/num_envelope_sweeps
add wave -noupdate /gb_pulseChannel_tb/wave_duty
add wave -noupdate /gb_pulseChannel_tb/dut/waveIndex
add wave -noupdate /gb_pulseChannel_tb/dut/waveValue
add wave -noupdate /gb_pulseChannel_tb/frequency
add wave -noupdate /gb_pulseChannel_tb/level
add wave -noupdate /gb_pulseChannel_tb/dut/overflow
add wave -noupdate /gb_pulseChannel_tb/dut/target_vol
add wave -noupdate /gb_pulseChannel_tb/dut/periodDivider
add wave -noupdate /gb_pulseChannel_tb/dut/periodDividerClock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2512450 ps} 0} {{Cursor 2} {0 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 186
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
WaveRestoreZoom {0 ps} {2327464 ps}
