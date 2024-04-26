/* Testbench for top module */
module top_tb ();

    logic clk, reset;

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
        repeat (69999999) @(posedge clk);
        $stop();
    end

endmodule  // top_tb
