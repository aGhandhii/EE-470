module top_top_tb ();
    logic sysclk;
    logic sw0;
    logic button0;
    logic button1;
    logic pwm_aud;
    logic pwm_aud_1;
    logic pwm_aud_2;
    logic pwm_aud_3;
    logic pwm_aud_4;
    logic [3:0] leds;

    top_top dut (.*);

    initial begin
        sysclk = 1'b1;
        forever #(10) sysclk = ~sysclk;
    end

    task reset();
        sw0 <= 0;
        @(posedge sysclk);
        sw0 <= 1;
        repeat(100) @(posedge sysclk);
        sw0 <= 0;
    endtask

    initial begin
        button0 = 1'b0;
        button1 = 1'b1;
        reset();
        repeat(90000000) @(posedge sysclk);
        sw0 <= 1;
        repeat(100000) @(posedge sysclk);
        sw0 <= 0;
        repeat(50000000) @(posedge sysclk);
        $stop();
    end
endmodule
