/* Top-Level APU Testbench */
module gb_APU_tb();

    // IO Replicate
    logic clk;
    logic reset;
    logic [3:0]  ch1_volume;
    logic [10:0] ch1_frequency;
    logic        ch1_start;
    logic        ch1_enable;
    logic [3:0]  ch2_volume;
    logic [10:0] ch2_frequency;
    logic        ch2_start;
    logic        ch2_enable;
    logic [1:0]  ch3_volume;
    logic [10:0] ch3_frequency;
    logic        ch3_start;
    logic        ch3_enable;
    logic [3:0]  ch4_volume;
    logic [3:0]  ch4_shift_clock_freq;
    logic        ch4_counter_width;
    logic [2:0]  ch4_freq_dividing_ratio;
    logic        ch4_start;
    logic        ch4_enable;
    logic        sound_enable;
    logic [3:0] ch1, ch2, ch3, ch4;
    logic [5:0] audio_out;

    // Instance
    gb_APU dut(.*);

    // Clock
    initial begin
        clk = 1'b0;
        forever #(10) clk <= ~clk;
    end

    // Tasks
    task sysReset();
        reset = 1'b1;
        sound_enable = 1'b0;
        @(posedge clk);
        reset = 1'b0;
        sound_enable = 1'b1;
    endtask

    bit[3:0] activeChannels;

    task triggerChannel(bit[3:0] activeChannels);
        ch1_start = 1'b0;
        ch2_start = 1'b0;
        ch3_start = 1'b0;
        ch4_start = 1'b0;
        @(posedge clk);
        ch1_start = activeChannels[0] ? 1'b1 : 1'b0;
        ch2_start = activeChannels[1] ? 1'b1 : 1'b0;
        ch3_start = activeChannels[2] ? 1'b1 : 1'b0;
        ch4_start = activeChannels[3] ? 1'b1 : 1'b0;
        @(posedge clk)
        ch1_start = 1'b0;
        ch2_start = 1'b0;
        ch3_start = 1'b0;
        ch4_start = 1'b0;
    endtask

    // Testbench
    initial begin
        // Set the active channels
        activeChannels[0] = 1'b1;
        activeChannels[1] = 1'b1;
        activeChannels[2] = 1'b1;
        activeChannels[3] = 1'b1;

        // Channel 1 settings
        ch1_volume = 4'b1111;
        ch1_frequency = 11'b11111111111;

        // Channel 2 settings
        ch2_volume = 4'b1111;
        ch2_frequency = 11'b11111111111;

        // Channel 3 settings
        ch3_volume = 2'b01;
        ch3_frequency = 11'b11111111111;

        // Channel 4 settings
        ch4_volume = 4'b1111;
        ch4_shift_clock_freq = 4'b0001;
        ch4_counter_width = 1'b1;
        ch4_freq_dividing_ratio = 3'b000;

        // Declare active channels
        ch1_enable = 1'b1;
        ch2_enable = 1'b1;
        ch3_enable = 1'b1;
        ch4_enable = 1'b1;

        // Run the simulation
        sound_enable = 1'b1;
        sysReset();
        triggerChannel(activeChannels);
        repeat(999999) @(posedge clk);
        $stop();
    end

endmodule  // gb_APU_tb
