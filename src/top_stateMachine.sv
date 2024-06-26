/* State Machine for Top-Level Logic

Handles loading notes, triggering channels, and letting notes play for a
fixed duration. Also handles reset requests.

Inputs:
    clk     - System Clock, 2^22 Hz
    reset   - System Reset
    length  - Length of Note, in clock cycles

Outputs:
    state:  - Current State (00=RESET, 01=LOAD, 10=START, 11=PLAY)
*/
module top_stateMachine(
    input logic clk,
    input logic reset,
    input logic [23:0] length,
    output logic [1:0] state
);

    localparam S_RESET = 2'b00;
    localparam S_LOAD = 2'b01;
    localparam S_START = 2'b10;
    localparam S_PLAY = 2'b11;

    // We stay in the 'play_note' state for the longest 'length' duration
    logic [23:0] tempo_counter;

    // Handle state progession
    logic [1:0] ns;
    always_comb begin
        case (state)
            S_RESET: begin
                ns = S_LOAD;
            end
            S_LOAD: begin
                ns = S_START;
            end
            S_START: begin
                ns = S_PLAY;
            end
            S_PLAY: begin
                ns = (tempo_counter == 20'd0) ? S_LOAD : S_PLAY;
            end
            default: ns = S_RESET;
        endcase
    end

    // Clock Logic
    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_RESET;
        end
        else begin
            tempo_counter <= (state == S_PLAY) ? tempo_counter - 24'd1 : length;
            state <= ns;
        end
    end

endmodule  // top_stateMachine
