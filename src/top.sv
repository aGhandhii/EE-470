/* Top-Level Module

Stores ROM for channel notes and loads them into channels following the tempo.

Inputs:
    clk     - 2^22 Hz
    reset   - System Reset
Outputs:
    ch*_out - Channel out
    DAC_sum - Mixed output of all channels

*/
module top (
    input logic clk,
    input logic reset,
    output logic [3:0] ch1_out,
    output logic [3:0] ch2_out,
    output logic [3:0] ch3_out,
    output logic [3:0] ch4_out,
    output logic [5:0] DAC_sum
);

    // State Definitions
    localparam S_RESET = 2'b00;
    localparam S_LOAD = 2'b01;
    localparam S_START = 2'b10;
    localparam S_PLAY = 2'b11;

    // State Machine
    logic [1:0] ch1_state, ch2_state, ch3_state, ch4_state;
    logic [23:0] ch1_length, ch2_length, ch3_length, ch4_length;
    top_stateMachine stateMachine_1 (
        .clk(clk),
        .reset(reset),
        .length(ch1_length),
        .state(ch1_state)
    );
    top_stateMachine stateMachine_2 (
        .clk(clk),
        .reset(reset),
        .length(ch2_length),
        .state(ch2_state)
    );
    top_stateMachine stateMachine_3 (
        .clk(clk),
        .reset(reset),
        .length(ch3_length),
        .state(ch3_state)
    );
    top_stateMachine stateMachine_4 (
        .clk(clk),
        .reset(reset),
        .length(ch4_length),
        .state(ch4_state)
    );

    // Channel Note ROM
    logic [38:0] ch1_ROM [598];
    logic [38:0] ch2_ROM [622];
    logic [36:0] ch3_ROM [582];
    logic [38:0] ch4_ROM [756];
    initial begin : loadChannelROM
        $readmemb("./audio/pulse_1.mif", ch1_ROM);
        $readmemb("./audio/pulse_2.mif", ch2_ROM);
        $readmemb("./audio/custom.mif", ch3_ROM);
        $readmemb("./audio/noise.mif", ch4_ROM);
    end

    // Index of ROM to feed into the APU
    // The ROM have <1024 entries, so we need 10-bit pointers
    logic [9:0] ch1_ROM_ptr, ch2_ROM_ptr, ch3_ROM_ptr, ch4_ROM_ptr;

    // Clocked logic for the pointers
    always_ff @(posedge clk) begin
        if (ch1_state == S_RESET) begin
            ch1_ROM_ptr <= 10'd1023;
            ch2_ROM_ptr <= 10'd1023;
            ch3_ROM_ptr <= 10'd1023;
            ch4_ROM_ptr <= 10'd1023;
        end
        else begin
            if (ch1_state == S_LOAD)
                ch1_ROM_ptr <= (ch1_ROM_ptr > 10'd597) ? 10'd0 : ch1_ROM_ptr + 10'd1;
            if (ch2_state == S_LOAD)
                ch2_ROM_ptr <= (ch2_ROM_ptr > 10'd621) ? 10'd0 : ch2_ROM_ptr + 10'd1;
            if (ch3_state == S_LOAD)
                ch3_ROM_ptr <= (ch3_ROM_ptr > 10'd581) ? 10'd0 : ch3_ROM_ptr + 10'd1;
            if (ch4_state == S_LOAD)
                ch4_ROM_ptr <= (ch4_ROM_ptr > 10'd755) ? 10'd0 : ch4_ROM_ptr + 10'd1;
        end
    end

    // Make ROM Mapping easier
    logic [38:0] ch1_settings, ch2_settings, ch4_settings;
    logic [36:0] ch3_settings;
    assign ch1_settings = ch1_ROM[ch1_ROM_ptr];
    assign ch2_settings = ch2_ROM[ch2_ROM_ptr];
    assign ch3_settings = ch3_ROM[ch3_ROM_ptr];
    assign ch4_settings = ch4_ROM[ch4_ROM_ptr];

    // Map the ROM to APU inputs
    logic [3:0]  ch1_volume;
    logic [10:0] ch1_frequency;
    logic        ch1_start;
    logic        ch1_enable;
    assign ch1_length           = ch1_settings[38:15];
    assign ch1_volume           = ch1_settings[14:11];
    assign ch1_frequency        = ch1_settings[10:0];
    assign ch1_start            = (ch1_state == S_START) ? 1'b1 : 1'b0;
    assign ch1_enable           = 1'b1;

    logic [3:0]  ch2_volume;
    logic [10:0] ch2_frequency;
    logic        ch2_start;
    logic        ch2_enable;
    assign ch2_length           = ch2_settings[38:15];
    assign ch2_volume           = ch2_settings[14:11];
    assign ch2_frequency        = ch2_settings[10:0];
    assign ch2_start            = (ch2_state == S_START) ? 1'b1 : 1'b0;
    assign ch2_enable           = 1'b1;

    logic [1:0]  ch3_volume;
    logic [10:0] ch3_frequency;
    logic        ch3_start;
    logic        ch3_enable;
    assign ch3_length           = ch3_settings[36:13];
    assign ch3_volume           = ch3_settings[12:11];
    assign ch3_frequency        = ch3_settings[10:0];
    assign ch3_start            = (ch3_state == S_START) ? 1'b1 : 1'b0;
    assign ch3_enable           = 1'b1;

    logic [3:0]  ch4_volume;
    logic [3:0]  ch4_shift_clock_freq;
    logic        ch4_counter_width;
    logic [2:0]  ch4_freq_dividing_ratio;
    logic        ch4_start;
    logic        ch4_enable;
    assign ch4_length           = ch4_settings[38:15];
    assign ch4_volume           = ch4_settings[14:11];
    assign ch4_shift_clock_freq = ch4_settings[7:4];
    assign ch4_counter_width    = ch4_settings[3];
    assign ch4_freq_dividing_ratio = ch4_settings[2:0];
    assign ch4_start            = (ch4_state == S_START) ? 1'b1 : 1'b0;
    assign ch4_enable           = 1'b1;

    // APU
    logic sound_enable;
    assign sound_enable = (ch1_state == S_RESET) ? 1'b0 : 1'b1;

    logic [3:0] ch1, ch2, ch3, ch4;
    logic [5:0] audio_out;

    assign ch1_out = ch1;
    assign ch2_out = ch2;
    assign ch3_out = ch3;
    assign ch4_out = ch4;
    assign DAC_sum = audio_out;

    gb_APU APU (.*);

endmodule  // top
