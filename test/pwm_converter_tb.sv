`timescale 1ns / 1ps

module pwm_converter_tb();
    logic clk;
    logic reset;
    logic [3:0] in;
    logic out;
    
    pwm_converter #(8) dut (.*);
    
    initial begin
        clk = 1'b0;
        forever #(10) clk <= ~clk;
    end
    
    initial begin
        reset <= 1'b1;
        in <= 4'd0;
        @(posedge clk);
        reset <= 1'b0;

        for (int i = 0; i < 16; i++) begin
            in <= i;
            repeat(128) @(posedge clk);
        end
        
        repeat(128) @(posedge clk);
        
        $stop();
    end

endmodule
