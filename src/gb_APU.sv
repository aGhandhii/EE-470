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
    sweep_enable    - Apply sweep to pulse channels
    envelope_enable - Apply envelope to pulse and noise channels

Outputs:
    ch*             - Channel Output
    audio_out       - Audio Output
*/
module gb_APU (
    input logic clk,
    input logic reset,
    input logic [3:0]  ch1_volume,
    input logic [10:0] ch1_frequency,
    input logic        ch1_start,
    input logic        ch1_enable,
    input logic [3:0]  ch2_volume,
    input logic [10:0] ch2_frequency,
    input logic        ch2_start,
    input logic        ch2_enable,
    input logic [1:0]  ch3_volume,
    input logic [10:0] ch3_frequency,
    input logic        ch3_start,
    input logic        ch3_enable,
    input logic [3:0]  ch4_volume,
    input logic [3:0]  ch4_shift_clock_freq,
    input logic        ch4_counter_width,
    input logic [2:0]  ch4_freq_dividing_ratio,
    input logic        ch4_start,
    input logic        ch4_enable,
    input logic        sound_enable,
    input logic        sweep_enable,
    input logic        envelope_enable,
    output logic [3:0] ch1,
    output logic [3:0] ch2,
    output logic [3:0] ch3,
    output logic [3:0] ch4,
    output logic [5:0] audio_out
);

    ////////////////////////////////
    // CUSTOM WAVE MEMORY CONTROL //
    ////////////////////////////////

    // Store the custom wave for channel 3
    logic [7:0] customWave [16];

    initial begin
        $readmemh("./audio/sawtooth.mif", customWave);
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
    logic ch1_on_flag, ch2_on_flag, ch3_on_flag, ch4_on_flag;

    // Channel 1 Submodule. This channel is a pulse function with Sweep, Level,
    // and Envelope Functions
    gb_pulseChannel channel_1(
        .reset(~sound_enable),
        .clk(clk),
        .clk_length_ctr(clk_length_ctr),
        .clk_vol_env(clk_vol_env),
        .clk_sweep(clk_sweep),
        .sweep_time(sweep_enable ? 3'b001 : 3'b000),
        .sweep_decreasing(1'b1),
        .num_sweep_shifts(sweep_enable ? 3'b001 : 3'b000),
        .wave_duty(2'b10),
        .length(6'b111111),
        .initial_volume(ch1_volume),
        .envelope_increasing(1'b0),
        .num_envelope_sweeps(envelope_enable ? 3'b001 : 3'b000),
        .start(ch1_start),
        .single(1'b0),
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
        .sweep_time(sweep_enable ? 3'b001 : 3'b000),
        .sweep_decreasing(1'b1),
        .num_sweep_shifts(sweep_enable ? 3'b001 : 3'b000),
        .wave_duty(2'b10),
        .length(6'b111111),
        .initial_volume(ch2_volume),
        .envelope_increasing(1'b0),
        .num_envelope_sweeps(envelope_enable ? 3'b001 : 3'b000),
        .start(ch2_start),
        .single(1'b0),
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
        .length(8'b11111111),
        .volume(ch3_volume),
        .on(1'b1),
        .single(1'b0),
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
        .length(6'b111111),
        .initial_volume(ch4_volume),
        .envelope_increasing(1'b0),
        .num_envelope_sweeps(envelope_enable ? 3'b001 : 3'b000),
        .shift_clock_freq(ch4_shift_clock_freq),
        .counter_width(ch4_counter_width),
        .freq_dividing_ratio(ch4_freq_dividing_ratio),
        .start(ch4_start),
        .single(1'b0),
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

    // Digital Mixing
    always_comb begin
        audio_out = 6'd0;
        if (ch1_enable&ch1_on_flag) audio_out = audio_out + {2'b00, ch1};
        if (ch2_enable&ch2_on_flag) audio_out = audio_out + {2'b00, ch2};
        if (ch3_enable&ch3_on_flag) audio_out = audio_out + {2'b00, ch3};
        if (ch4_enable&ch4_on_flag) audio_out = audio_out + {2'b00, ch4};
    end

endmodule  // gb_APU
