/* Top-Level Gameboy Audio Processing Unit

This module connects the corresponding APU Control Signals to their respective
Channel Submodules, and generates the Sweep, Length, and Envelope Clocks.
It also mixes the channel outputs and returns an output audio signal.

We store the custom wave for channel 3 here as well.

Inspiration from the following project:
    VerilogBoy: https://github.com/zephray/VerilogBoy

Inputs:
    clk             - GB clk (2^22 Hz)
    reset           - System Reset
    ch1_*           - Channel 1 Settings
    ch2_*           - Channel 2 Settings
    ch3_*           - Channel 3 Settings
    ch4_*           - Channel 4 Settings
    sound_enable    - Master sound control

Outputs:
    audio_out       - Audio Output
*/
module gb_APU (
    input logic clk,
    input logic reset,
    input logic [5:0]  ch1_length,
    input logic        ch1_length_enable,
    input logic [3:0]  ch1_volume,
    input logic [10:0] ch1_frequency,
    input logic        ch1_start,
    input logic        ch1_enable,
    input logic [5:0]  ch2_length,
    input logic        ch2_length_enable,
    input logic [3:0]  ch2_volume,
    input logic [10:0] ch2_frequency,
    input logic        ch2_start,
    input logic        ch2_enable,
    input logic [7:0]  ch3_length,
    input logic        ch3_length_enable,
    input logic [1:0]  ch3_volume,
    input logic [10:0] ch3_frequency,
    input logic        ch3_start,
    input logic        ch3_enable,
    input logic [5:0]  ch4_length,
    input logic        ch4_length_enable,
    input logic [3:0]  ch4_volume,
    input logic [3:0]  ch4_shift_clock_freq,
    input logic        ch4_counter_width,
    input logic [2:0]  ch4_freq_dividing_ratio,
    input logic        ch4_start,
    input logic        ch4_enable,
    input logic        sound_enable,
    output logic [15:0] audio_out
);

    // Master volume modifier
    logic [2:0] output_level;
    assign output_level = 3'b111;  // Max this out for now

    ////////////////////////////////
    // CUSTOM WAVE MEMORY CONTROL //
    ////////////////////////////////

    // Store the custom wave for channel 3
    logic [7:0] customWave [16];

    initial begin
        $readmemb("./sawtooth.mif", customWave);
    end

    logic [3:0] wave_addr;
    logic [7:0] wave_data;
    assign wave_data = customWave[wave_addr];

    ////////////////////////////////////
    // FRAME SEQUENCER CLOCK DIVISION //
    ////////////////////////////////////

    logic clk_length_ctr; // 256Hz Length Control Clock
    logic clk_vol_env;    // 64Hz Volume Enevelope Clock
    logic clk_sweep;      // 128Hz Sweep Clock

    gb_frameSequencer APUclockDivider (
        .clk(clk),
        .reset(reset),
        .length_clk(clk_length_ctr),
        .envelope_clk(clk_vol_env),
        .sweep_clk(clk_sweep)
    );

    ///////////////////////
    // CHANNEL INSTANCES //
    ///////////////////////

    // Store Channel Outputs
    logic [3:0] ch1, ch2, ch3, ch4;
    logic ch1_on_flag, ch2_on_flag, ch3_on_flag, ch4_on_flag;

    // Channel 1 Submodule. This channel is a pulse function with Sweep, Level,
    // and Envelope Functions
    gb_pulseChannel channel_1(
        .reset(~sound_enable),
        .clk(clk),
        .clk_length_ctr(clk_length_ctr),
        .clk_vol_env(clk_vol_env),
        .clk_sweep(clk_sweep),
        .sweep_time(3'b000),
        .sweep_decreasing(1'b0),
        .num_sweep_shifts(3'b000),
        .wave_duty(2'b10),
        .length(ch1_length),
        .initial_volume(ch1_volume),
        .envelope_increasing(1'b0),
        .num_envelope_sweeps(3'b000),
        .start(ch1_start),
        .single(ch1_length_enable),
        .frequency(ch1_frequency),
        .level(ch1),
        .enable(ch1_on_flag)
    );

    // Channel 2 Submodule. This Channel is a pulse function with Level and
    // Envelope Functions.
    gb_pulseChannel channel_2(
        .reset(~sound_enable),
        .clk(clk),
        .clk_length_ctr(clk_length_ctr),
        .clk_vol_env(clk_vol_env),
        .clk_sweep(clk_sweep),
        .sweep_time(3'b000),
        .sweep_decreasing(1'b0),
        .num_sweep_shifts(3'b000),
        .wave_duty(2'b10),
        .length(ch2_length),
        .initial_volume(ch2_volume),
        .envelope_increasing(1'b0),
        .num_envelope_sweeps(3'b000),
        .start(ch2_start),
        .single(ch2_length_enable),
        .frequency(ch2_frequency),
        .level(ch2),
        .enable(ch2_on_flag)
    );

    // Channel 3 Submodule. This channel reads from a 16-byte section of memory
    // in 4-bit nibbles as a customized waveform.
    // The custom waveform is stored within the channel module
    // It also has a Level and Envelope function.
    gb_customWaveChannel channel_3(
        .reset(~sound_enable),
        .clk(clk),
        .clk_length_ctr(clk_length_ctr),
        .length(ch3_length),
        .volume(ch3_volume),
        .on(1'b1),
        .single(ch3_length_enable),
        .start(ch3_start),
        .frequency(ch3_frequency),
        .wave_addr(wave_addr),
        .wave_data(wave_data),
        .level(ch3),
        .enable(ch3_on_flag)
    );

    // Channel 4 Submodule. This channel generates noise with an LFSR and has
    // Level and Enevelope Functions.
    gb_noiseChannel channel_4(
        .reset(~sound_enable),
        .clk(clk),
        .clk_length_ctr(clk_length_ctr),
        .clk_vol_env(clk_vol_env),
        .length(ch4_length),
        .initial_volume(ch4_volume),
        .envelope_increasing(1'b0),
        .num_envelope_sweeps(3'b000),
        .shift_clock_freq(ch4_shift_clock_freq),
        .counter_width(ch4_counter_width),
        .freq_dividing_ratio(ch4_freq_dividing_ratio),
        .start(ch4_start),
        .single(ch4_length_enable),
        .level(ch4),
        .enable(ch4_on_flag)
    );

    ////////////////
    // MIXER UNIT //
    ////////////////

    /* This section prototypes the DAC, Mixer, and Volume Modules from the
    Pan Docs diagram: https://gbdev.io/pandocs/Audio_details.html

    Essentially, there are 4 DAC modules, each taking the 4-bit volume output
    from each channel, as well as the channel enable signals.

    The 4 DAC modules send their analog outputs to the Mixer module, which
    uses control signals to selectively mix DAC inputs on the specified
    channels. This allows for outputs up to 4x the DAC inputs, so we add an
    extra 2 bits for a 6-bit output.

    Lastly, the mixer signal is sent to the Volume module, which boosts the
    output with the 3-bit volume control signal. This can be at most a 7x
    boost, so we add 3 additional bits to this output for a total of 9-bits.

    In physical hardware, the output from the Volume module is sent through a
    High-Pass filter.
    */
    logic [5:0] DAC_sum;
    always_comb begin
        DAC_sum = 6'd0;
        if (ch1_enable&ch1_on_flag) DAC_sum = DAC_sum + {2'b00, ch1};
        if (ch2_enable&ch2_on_flag) DAC_sum = DAC_sum + {2'b00, ch2};
        if (ch3_enable&ch3_on_flag) DAC_sum = DAC_sum + {2'b00, ch3};
        if (ch4_enable&ch4_on_flag) DAC_sum = DAC_sum + {2'b00, ch4};
    end

    // Mixer Unit
    logic [8:0] mixer_sum;
    assign mixer_sum = DAC_sum * output_level;

    // Volume Unit, boost up to a 16-bit value
    assign audio_out  = (sound_enable) ? {1'b0, mixer_sum, 6'b0} : 16'b0;

endmodule  // gb_APU
