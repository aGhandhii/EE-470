// Module for converting a 4-bit value into a pulse wave signal each clock cycle

/**
    PULSE_PERIOD: The amount of clock cycles that make up a single period of the pulse wave. Max value is 2^15 samples
    clk: The clock signal for the module. Every clock cycle, the output progresses one sample. The input is
         polled every PULSE_PERIOD cycles. The clock speed should be decided accordingly
    reset: The reset signal for the module.
    input: 4 bit value representing the value of the current sample (i.e. volume)
    output: single bit digital signal, which is itself the pulse wave
*/
`define PULSE_BITS $clog2(PULSE_PERIOD)
module pwm_converter #(parameter PULSE_PERIOD = 16, parameter INPUT_BITS = 4) (
    input logic clk,
    input logic reset,
    input logic [3:0] in,
    output logic out
);
    // Counts down from the total number of samples per period to know when to get the next input and start
    //   another cycle. We set the bit width to be a factor of 2 just so that the math lines up for either skipping
    //   samples or holding a sample for double the time.
    logic [`PULSE_BITS-1:0] full_width_counter;
    // Counts down from the value of the input each cycle (asterisk - see always_ff), determining how many
    //   samples to be high to create the duty cycle
    logic [INPUT_BITS-1:0] duty_cycle_val;

    always_ff @(posedge clk) begin
        if (full_width_counter > 0 && !reset) begin
            // If not done with the cycle yet, decrement the full_width and duty_cycle counters by the correct
            //   amount(as long as both are positive)
            full_width_counter <= full_width_counter - 1;
            if(duty_cycle_val > 0) begin
                if (`PULSE_BITS > INPUT_BITS) begin
                    // If the pulse cycle bits are more than the input bits, we may need to wait. We do this
                    //   with a clock divider. Each difference between the pulse length bits and the input
                    //   value bits increases the waiting by a factor of two. Subtract 5 because it's the
                    //   minimum value that the clog2 can have if there are more pulse cycle bits.
                    if (full_width_counter[`PULSE_BITS - INPUT_BITS - 1] == 0) begin
                        duty_cycle_val <= duty_cycle_val - 1;
                        // If the next iteration of duty_cycle_val will loop around, or if it will become 0, the
                        //   cycle is over and we can stop outputting.
                        if (duty_cycle_val - 1 > duty_cycle_val || duty_cycle_val - 1 == 0) begin
                            out <= 0;
                        end
                    end
                end else if (`PULSE_BITS < 4) begin
                    // If the pulse cycle bits are less than the input bits, we need to skip bits. So first we
                    //   decrement one like normal, but decrement additionally the bit length difference between
                    //   the input signal and the pulse cycle.
                    duty_cycle_val <= duty_cycle_val - 1 - (INPUT_BITS - `PULSE_BITS);
                    // If the next iteration of duty_cycle_val will loop around, the cycle is over and we can 
                    //   stop outputting.
                    if (duty_cycle_val - 1 - (INPUT_BITS - `PULSE_BITS) > duty_cycle_val) begin
                        out <= 0;
                    end
                    // If the next iteration of duty_cycle_val will be 0, the cycle is over and we can 
                    //   stop outputting.
                    if (duty_cycle_val - 1 - (INPUT_BITS - `PULSE_BITS) == 0) begin
                        out <= 0;
                    end
                end else begin
                    // If the pulse cycle is the same as the input value, life is easy. Just decrement by one.
                    duty_cycle_val <= duty_cycle_val - 1;
                    // If the next iteration of duty_cycle_val will loop around, or if it will become 0, the
                    //   cycle is over and we can stop outputting.
                    if (duty_cycle_val - 1 > duty_cycle_val || duty_cycle_val - 1 == 0) begin
                        out <= 0;
                    end
                end
            end
        end else begin
            // Otherwise, the cycle has finished, so restart the counters
            // Full width counter is set to all ones (using clog2 to get the bit length of the counter)
            full_width_counter <= {$clog2(PULSE_PERIOD){1'b1}};
            // Duty cycle counter gets the value of the input
            duty_cycle_val <= in;
            // If the input value is 0, there is nothing to do. Otherwise, cycle is not done; start outputting.
            out <= in != 0;
        end
    end

endmodule // pwm_converter
