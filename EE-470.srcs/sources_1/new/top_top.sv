
`define PWM_CYCLE_WIDTH 2048
`define AUDIO_INPUT_BITS 16
`define CLOCK_DIVISION 5
`define AUDIO_CH_INPUT_BITS 4
module top_top(
    input logic sysclk,
    input logic sw0,
    output logic pwm_aud,
    output logic pwm_aud_1,
    output logic pwm_aud_2,
    output logic pwm_aud_3,
    output logic pwm_aud_4,
    output logic [3:0] leds
);
    logic gb_clk;
    logic [`CLOCK_DIVISION-1:0] clk_counter;
    logic [`AUDIO_INPUT_BITS-1:0] gb_audio_out;
    logic [3:0] ch1;
    logic [3:0] ch2;
    logic [3:0] ch3;
    logic [3:0] ch4;

    top top(.clk(gb_clk), .reset(sw0), .audio_out(gb_audio_out), .ch1_out(ch1), .ch2_out(ch2), .ch3_out(ch3), .ch4_out(ch4));
    pwm_converter #(`PWM_CYCLE_WIDTH, `AUDIO_INPUT_BITS) pwm_conv (
        .clk(sysclk),
        .reset(sw0),
        .in(gb_audio_out),
        .out(pwm_aud)
    );
    pwm_converter #(`PWM_CYCLE_WIDTH, `AUDIO_CH_INPUT_BITS) pwm_conv_ch1 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch1),
        .out(pwm_aud_1)
    );
    pwm_converter #(`PWM_CYCLE_WIDTH, `AUDIO_CH_INPUT_BITS) pwm_conv_ch2 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch2),
        .out(pwm_aud_2)
    );
    pwm_converter #(`PWM_CYCLE_WIDTH, `AUDIO_CH_INPUT_BITS) pwm_conv_ch3 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch3),
        .out(pwm_aud_3)
    );
    pwm_converter #(`PWM_CYCLE_WIDTH, `AUDIO_CH_INPUT_BITS) pwm_conv_ch4 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch4),
        .out(pwm_aud_4)
    );
    
    always_comb begin
        gb_clk = clk_counter[`CLOCK_DIVISION-1];
        leds[0] = sw0;
    end
    
    always_ff @(posedge sysclk) begin
        if (sw0) begin
            clk_counter <= `CLOCK_DIVISION'd0;
        end else begin
            clk_counter <= clk_counter + `CLOCK_DIVISION'd1;
        end
    end
endmodule
