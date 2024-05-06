/* Testbench for top module */
module top_tb ();

    logic clk, reset;
    logic [3:0] ch1_out;
    logic [3:0] ch2_out;
    logic [3:0] ch3_out;
    logic [3:0] ch4_out;
    logic [5:0] DAC_sum;

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
        sysReset();
        repeat (3999999) @(posedge clk);
        sysReset();
        repeat (3999999) @(posedge clk);
        $stop();
    end

endmodule  // top_tb
