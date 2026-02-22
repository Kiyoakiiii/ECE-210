`default_nettype none

module tt_um_alif (
    input  wire [7:0] ui_in,    // Dedicated inputs (used as synaptic input current)
    output wire [7:0] uo_out,   // Dedicated outputs (used for spike output and state observation)
    input  wire [7:0] uio_in,   // Bidirectional I/O: Input path
    output wire [7:0] uio_out,  // Bidirectional I/O: Output path
    output wire [7:0] uio_oe,   // Bidirectional I/O: Enable path
    input  wire       ena,      // Chip enable signal
    input  wire       clk,      // Clock signal
    input  wire       rst_n     // Active-low reset
);

    // Set unused bidirectional pins to zero by default
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // ALIF core parameters
    parameter BASE_THETA = 8'd100; // Base threshold
    parameter THETA_STEP = 8'd40;  // Threshold increase step after each spike

    // Register states
    reg [7:0] membrane_v; // Membrane potential
    reg [7:0] theta;      // Dynamic adaptive threshold
    reg spike;            // Spike flag

    // Hardware pin mapping
    assign uo_out[0] = spike;        // uo_out[0] serves as the spike output
    assign uo_out[7:1] = theta[7:1]; // The remaining pins output the top 7 bits of the current threshold for debugging

    always @(posedge clk) begin
        if (!rst_n) begin
            // Reset all states
            membrane_v <= 8'd0;
            theta <= BASE_THETA;
            spike <= 1'b0;
        end else if (ena) begin
            if (spike) begin
                // If a spike was emitted in the previous cycle:
                // 1. Reset membrane potential to zero
                membrane_v <= 8'd0;
                // 2. Adaptively increase threshold (with overflow protection)
                if (theta + THETA_STEP < 8'd255)
                    theta <= theta + THETA_STEP;
                else
                    theta <= 8'd255;
                // 3. Pull down the spike signal
                spike <= 1'b0;
            end else begin
                // Normal integration and leak phase:
                // 1. Membrane potential = current potential - leak + input current
                // (membrane_v >> 3 is equivalent to dividing by 8, a hardware-efficient digital leak)
                membrane_v <= membrane_v - (membrane_v >> 3) + ui_in;

                // 2. Threshold leak: decay back to base value if it's higher than base
                if (theta > BASE_THETA)
                    theta <= theta - 1;

                // 3. Trigger condition: check if membrane potential reached the dynamic threshold
                if (membrane_v >= theta)
                    spike <= 1'b1;
                else
                    spike <= 1'b0;
            end
        end
    end
endmodule