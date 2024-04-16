/* Testbench for Top-Level State Machine */
module top_stateMachine_tb();

    // IO
    logic clk, reset;
    logic [1:0] state;

    // Clock Emulation
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // Instance
    top_stateMachine dut(.*);

    // Tasks
    task sysReset();
        reset = 1'b1;
        @(posedge clk);
        reset = 1'b0;
    endtask

    // Testbench
    initial begin
        sysReset();
        repeat(400) @(posedge clk);
        sysReset();
        repeat(10) @(posedge clk);
        $stop();
    end

endmodule  // top_stateMachine_tb
