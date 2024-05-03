
`define PWM_CYCLE_WIDTH 2048
`define AUDIO_INPUT_BITS 16
`define CLOCK_DIVISION 5
module top_top(
    input logic sysclk,
    input logic sw0,
    output logic pwm_aud,
    output logic [3:0] leds
);
    logic gb_clk;
    logic [`CLOCK_DIVISION-1:0] clk_counter;
    logic [`AUDIO_INPUT_BITS-1:0] gb_audio_out;

    top top(.clk(gb_clk), .reset(sw0), .audio_out(gb_audio_out));
    pwm_converter #(`PWM_CYCLE_WIDTH, `AUDIO_INPUT_BITS) pwm_conv (
        .clk(sysclk),
        .reset(sw0),
        .in(gb_audio_out),
        .out(pwm_aud)
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
