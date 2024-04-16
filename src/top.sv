/* Top-Level Module

Stores ROM for channel notes and loads them into channels following the tempo.

Inputs:
    clk     - 2^22 Hz
    reset   - System Reset
Outputs:

*/
module top();

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
    logic [] ch1_ROM [];
    logic [] ch2_ROM [];
    logic [] ch3_ROM [];
    logic [] ch4_ROM [];
    initial begin : loadChannelROM
        $readmemb("./CHANNEL_1_DATA.mif", ch1_ROM);
        $readmemb("./CHANNEL_2_DATA.mif", ch2_ROM);
        $readmemb("./CHANNEL_3_DATA.mif", ch3_ROM);
        $readmemb("./CHANNEL_4_DATA.mif", ch4_ROM);
    end

    // Index of ROM to feed into the APU
    logic [] ch1_ROM_ptr, ch2_ROM_ptr, ch3_ROM_ptr, ch4_ROM_ptr;
    logic [] ch1_settings, ch2_settings, ch3_settings, ch4_settings;
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
    assign ch1_length           = ch1_settings[];
    assign ch1_length_enable    = ch1_settings[];
    assign ch1_volume           = ch1_settings[];
    assign ch1_frequency        = ch1_settings[];
    assign ch1_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch1_enable           = 1'b1;

    logic [5:0]  ch2_length;
    logic        ch2_length_enable;
    logic [3:0]  ch2_volume;
    logic [10:0] ch2_frequency;
    logic        ch2_start;
    logic        ch2_enable;
    assign ch2_length           = ch2_settings[];
    assign ch2_length_enable    = ch2_settings[];
    assign ch2_volume           = ch2_settings[];
    assign ch2_frequency        = ch2_settings[];
    assign ch2_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch2_enable           = 1'b1;

    logic [7:0]  ch3_length;
    logic        ch3_length_enable;
    logic [1:0]  ch3_volume;
    logic [10:0] ch3_frequency;
    logic        ch3_start;
    logic        ch3_enable;
    assign ch3_length           = ch3_settings[];
    assign ch3_length_enable    = ch3_settings[];
    assign ch3_volume           = ch3_settings[];
    assign ch3_frequency        = ch3_settings[];
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
    assign ch4_length           = ch4_settings[];
    assign ch4_length_enable    = ch4_settings[];
    assign ch4_volume           = ch4_settings[];
    assign ch4_shift_clock_freq = ch4_settings[];
    assign ch4_counter_width    = ch4_settings[];
    assign ch4_freq_dividing_ratio = ch4_settings[];
    assign ch4_start            = (state == S_START) ? 1'b1 : 1'b0;
    assign ch4_enable           = 1'b1;

    // APU
    logic sound_enable, audio_out;
    assign sound_enable = 1'b1;
    gb_APU APU (.*);

endmodule  // top
