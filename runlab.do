# Create work library
vlib work

# Compile Code
vlog "./src/*.sv"
vlog "./test/top_stateMachine_tb.sv"

# Start the Simulator
vsim -voptargs="+acc" -t 1ps -lib work top_stateMachine_tb

# Source the wave file
do ./Modelsim/top_stateMachine_wave.do

# Set window types
view wave
view structure
view signals

# Run the simulation
run -all
