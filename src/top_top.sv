`define PWM_CYCLE_WIDTH 2048
`define AUDIO_INPUT_BITS 6
`define CLOCK_DIVISION 4
`define AUDIO_CH_INPUT_BITS 4

/* Top Module for FPGA, to be synthesized

Takes APU outputs and converts to PWM for audio output over GPIO.
Also takes FPGA system clock and divides to approximate the GameBoy system clock

Inputs:
    sysclk      - 125MHz system clock
    sw0         - Switch 0 on FPGA, will be used as a reset signal

Outputs:
    pwm_aud*    - pwm output for specified channel or mixed audio
    leds        - FPGA leds
*/
module top_top (
    input  logic sysclk,
    input  logic sw0,
    output logic pwm_aud,
    output logic pwm_aud_1,
    output logic pwm_aud_2,
    output logic pwm_aud_3,
    output logic pwm_aud_4,
    output logic [3:0] leds
);
    logic gb_clk;
    logic [`CLOCK_DIVISION-1:0] clk_counter;
    logic posedge_reset;
    logic [3:0] ch1;
    logic [3:0] ch2;
    logic [3:0] ch3;
    logic [3:0] ch4;
    logic [5:0] audio_out;

    // APU Top Module Instance
    top top (
        .clk(gb_clk),
        .reset(sw0),
        .ch1(ch1),
        .ch2(ch2),
        .ch3(ch3),
        .ch4(ch4),
        .audio_out(audio_out)
    );

    // PWM Outputs for Individual Channels and Mixed Output
    pwm_converter #(
        .PULSE_PERIOD(`PWM_CYCLE_WIDTH),
        .INPUT_BITS(`AUDIO_INPUT_BITS)
    ) pwm_out_mixed (
        .clk(sysclk),
        .reset(sw0),
        .in(audio_out),
        .out(pwm_aud)
    );
    pwm_converter #(
        .PULSE_PERIOD(`PWM_CYCLE_WIDTH),
        .INPUT_BITS(`AUDIO_CH_INPUT_BITS)
    ) pwm_out_ch1 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch1),
        .out(pwm_aud_1)
    );
    pwm_converter #(
        .PULSE_PERIOD(`PWM_CYCLE_WIDTH),
        .INPUT_BITS(`AUDIO_CH_INPUT_BITS)
    ) pwm_out_ch2 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch2),
        .out(pwm_aud_2)
    );
    pwm_converter #(
        .PULSE_PERIOD(`PWM_CYCLE_WIDTH),
        .INPUT_BITS(`AUDIO_CH_INPUT_BITS)
    ) pwm_out_ch3 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch3),
        .out(pwm_aud_3)
    );
    pwm_converter #(
        .PULSE_PERIOD(`PWM_CYCLE_WIDTH),
        .INPUT_BITS(`AUDIO_CH_INPUT_BITS)
    ) pwm_out_ch4 (
        .clk(sysclk),
        .reset(sw0),
        .in(ch4),
        .out(pwm_aud_4)
    );

    // Only detect positive reset edge for clock division
    edgeDetector posedgeReset (
        .clk(sysclk),
        .i(sw0),
        .o(posedge_reset)
    );

    // Divide the system clock as close to 4MHz as possible
    always_comb begin
        gb_clk = clk_counter[`CLOCK_DIVISION-1];
        leds[0] = sw0;
    end
    always_ff @(posedge sysclk) begin
        if (posedge_reset)
            clk_counter <= `CLOCK_DIVISION'd0;
        else
            clk_counter <= clk_counter + `CLOCK_DIVISION'd1;
    end

endmodule  // top_top
