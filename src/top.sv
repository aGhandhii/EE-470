/* Top-Level Module

Stores ROM for channel notes and loads them into channels following the tempo.

Inputs:
    clk     - 2^22 Hz
    reset   - System Reset
Outputs:

*/
module top (
    input logic clk,
    input logic reset
);

    // State Definitions
    localparam S_RESET = 2'b00;
    localparam S_LOAD = 2'b01;
    localparam S_START = 2'b10;
    localparam S_PLAY = 2'b11;

    // State Machine
    logic [1:0] state;
    top_stateMachine stateMachine (
        .clk(clk),
        .reset(reset),
        .state(state)
    );

    // Channel Note ROM
    logic [20:0] ch1_ROM [512];
    logic [20:0] ch2_ROM [512];
    logic [20:0] ch3_ROM [512];
    logic [20:0] ch4_ROM [512];
    initial begin : loadChannelROM
        $readmemb("./audio/pulse_1.mif", ch1_ROM);
        $readmemb("./audio/pulse_2.mif", ch2_ROM);
        $readmemb("./audio/custom.mif", ch3_ROM);
        $readmemb("./audio/noise.mif", ch4_ROM);
    end

    // Index of ROM to feed into the APU
    // The ROM have 512 entries, so we need 9-bit pointers
    logic [8:0] ch1_ROM_ptr, ch2_ROM_ptr, ch3_ROM_ptr, ch4_ROM_ptr;

    // Clocked logic for the pointers
    always_ff @(posedge clk) begin
        if (state == S_RESET) begin
            ch1_ROM_ptr <= 9'd511;
            ch2_ROM_ptr <= 9'd511;
            ch3_ROM_ptr <= 9'd511;
            ch4_ROM_ptr <= 9'd511;
        end
        else if (state == S_LOAD) begin
            ch1_ROM_ptr <= ch1_ROM_ptr + 9'd1;
            ch2_ROM_ptr <= ch2_ROM_ptr + 9'd1;
            ch3_ROM_ptr <= ch3_ROM_ptr + 9'd1;
            ch4_ROM_ptr <= ch4_ROM_ptr + 9'd1;
        end
    end

    // Make ROM Mapping easier
    logic [20:0] ch1_settings, ch2_settings, ch3_settings, ch4_settings;
    assign ch1_settings = ch1_ROM[ch1_ROM_ptr];
    assign ch2_settings = ch2_ROM[ch2_ROM_ptr];
    assign ch3_settings = ch3_ROM[ch3_ROM_ptr];
    assign ch4_settings = ch4_ROM[ch4_ROM_ptr];

    // Map the ROM to APU inputs
    logic [5:0]  ch1_length;
    logic        ch1_length_enable;
    logic [3:0]  ch1_volume;
    logic [10:0] ch1_frequency;
    logic        ch1_start;
    logic        ch1_enable;
    assign ch1_length           = ch1_settings[20:15];
    assign ch1_length_enable    = (ch1_length == 6'd0) ? 1'b0 : 1'b1;
    assign ch1_volume           = ch1_settings[14:11];
    assign ch1_frequency        = ch1_settings[10:0];
    assign ch1_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch1_enable           = 1'b1;

    logic [5:0]  ch2_length;
    logic        ch2_length_enable;
    logic [3:0]  ch2_volume;
    logic [10:0] ch2_frequency;
    logic        ch2_start;
    logic        ch2_enable;
    assign ch2_length           = ch2_settings[20:15];
    assign ch2_length_enable    = (ch2_length == 6'd0) ? 1'b0 : 1'b1;
    assign ch2_volume           = ch2_settings[14:11];
    assign ch2_frequency        = ch2_settings[10:0];
    assign ch2_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch2_enable           = 1'b1;

    logic [7:0]  ch3_length;
    logic        ch3_length_enable;
    logic [1:0]  ch3_volume;
    logic [10:0] ch3_frequency;
    logic        ch3_start;
    logic        ch3_enable;
    assign ch3_length           = ch3_settings[20:13];
    assign ch3_length_enable    = (ch3_length == 8'd0) ? 1'b0 : 1'b1;
    assign ch3_volume           = ch3_settings[12:11];
    assign ch3_frequency        = ch3_settings[10:0];
    assign ch3_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch3_enable           = 1'b1;

    logic [5:0]  ch4_length;
    logic        ch4_length_enable;
    logic [3:0]  ch4_volume;
    logic [3:0]  ch4_shift_clock_freq;
    logic        ch4_counter_width;
    logic [2:0]  ch4_freq_dividing_ratio;
    logic        ch4_start;
    logic        ch4_enable;
    assign ch4_length           = ch4_settings[20:15];
    assign ch4_length_enable    = (ch4_length == 6'd0) ? 1'b0 : 1'b1;
    assign ch4_volume           = ch4_settings[14:11];
    assign ch4_shift_clock_freq = ch4_settings[7:4];
    assign ch4_counter_width    = ch4_settings[3];
    assign ch4_freq_dividing_ratio = ch4_settings[2:0];
    assign ch4_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch4_enable           = 1'b1;

    // APU
    logic sound_enable;
    assign sound_enable = 1'b1;
    logic [15:0] audio_out;

    gb_APU APU (.*);

endmodule  // top
