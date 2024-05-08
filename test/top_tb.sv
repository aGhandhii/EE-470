/* Testbench for top module */
module top_tb ();

    logic clk, reset;
    logic sweep_enable, envelope_enable;
    logic [3:0] ch1;
    logic [3:0] ch2;
    logic [3:0] ch3;
    logic [3:0] ch4;
    logic [5:0] audio_out;

    initial begin
        clk = 1'b1;
        forever #(10) clk = ~clk;
    end

    top dut(.*);

    // Tasks
    task sysReset();
        reset = 1'b0;
        @(posedge clk);
        reset = 1'b1;
        @(posedge clk);
        reset = 1'b0;
    endtask

    initial begin
        sweep_enable    = 1'b1;
        envelope_enable = 1'b1;
        sysReset();
        repeat (5999999) @(posedge clk);
        sysReset();
        repeat (5999999) @(posedge clk);
        $stop();
    end

endmodule  // top_tb
