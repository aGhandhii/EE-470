`timescale 1ns / 1ps

module top_top_tb();
    logic sysclk;
    logic sw0;
    logic pwm_aud;
    logic [3:0] leds;
    
    top_top dut (.*);
    
    initial begin
        sysclk = 1'b1;
        forever #(10) sysclk = ~sysclk;
    end
    
    initial begin
        sw0 <= 0;
        @(posedge sysclk);
        sw0 <= 1;
        @(posedge sysclk);
        sw0 <= 0;
        repeat(10000000) @(posedge sysclk);
        $stop();
    end
endmodule
