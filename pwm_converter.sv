// Module for converting a 4-bit value into a pulse wave signal each clock cycle

`define PULSE_BITS $clog2(PULSE_PERIOD)
`define INPUT_BITS 4

/**
    PULSE_PERIOD: The amount of clock cycles that make up a single period of the pulse wave. Max value is 2^15 samples
    clk: The clock signal for the module. Every clock cycle, the output progresses one sample. The input is
         polled every PULSE_PERIOD cycles. The clock speed should be decided accordingly
    reset: The reset signal for the module.
    input: 4 bit value representing the value of the current sample (i.e. volume)
    output: single bit digital signal, which is itself the pulse wave
*/
module pwm_converter #(parameter PULSE_PERIOD) (
    input logic clk,
    input logic reset,
    input logic [INPUT_BITS-1:0] input,
    output logic output
);
    // Counts down from the total number of samples per period to know when to get the next input and start
    //   another cycle. We set the bit width to be a factor of 2 just so that the math lines up for either skipping
    //   samples or holding a sample for double the time.
    logic [PULSE_BITS-1:0] full_width_counter;
    // Counts down from the value of the input each cycle (asterisk - see always_ff), determining how many
    //   samples to be high to create the duty cycle
    logic [INPUT_BITS-1:0] duty_cycle_counter;

    always_comb begin
        // If the duty cycle counter is positive, then the output of the signal is high. Otherwise, go
        //   low. This makes the average value of the cycle to be proportional to the input value
        if (!reset) begin
            output = duty_cycle_counter >= 0;
        end else begin
            output = 0;
        end
    end

    always_ff @(posedge clk) begin
        if (full_width_counter > 0 && !reset) begin
            // If not done with the cycle yet, decrement the full_width and duty_cycle counters by the correct
            //   amount(as long as both are positive)
            full_width_counter <= full_width_counter - 1;
            if(duty_cycle_counter > 0) begin
                if (PULSE_BITS > INPUT_BITS) begin
                    // If each pulse cycle is more than the input value, we may need to wait. We do this
                    //   with a clock divider. Each difference between the pulse length bits and the input
                    //   value bits increases the waiting by a factor of two 
                    if (full_width_counter[PULSE_BITS - INPUT_BITS - 1] == 1) {
                        duty_cycle_counter <= duty_cycle_counter - 1;
                    }
                end else if (PULSE_BITS < INPUT_BITS) begin
                    // If each pulse cycle is less than the input value, we need to skip bits. So first we
                    //   decrement one like normal, but decrement additionally the bit length difference between
                    //   the input signal and the pulse cycle.
                    duty_cycle_cunter <= duty_cycle_counter - 1 - (INPUT_BITS - PULSE_BITS);
                end else begin
                    // If the pulse cycle is the same as the input value, life is easy. Just decrement by one.
                    duty_cycle_cunter <= duty_cycle_counter - 1;
                end
            end
        end else begin
            // Otherwise, the cycle has finished, so restart the counters
            // Full width counter is set to all ones (using clog2 to get the bit length of the counter)
            full_width_counter <= {PULSE_BITS{1'b1}};
            // Duty cycle counter gets the value of the input
            duty_cycle_counter <= input;
        end
    end

endmodule // pwm_converter
