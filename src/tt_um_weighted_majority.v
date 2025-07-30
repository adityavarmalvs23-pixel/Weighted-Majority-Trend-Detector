`default_nettype none

module tt_um_weighted_majority (
    input  wire [7:0]  ui_in,
    output wire [7:0]  uo_out,
    input  wire [7:0]  uio_in,
    output wire [7:0]  uio_out,
    output wire [7:0]  uio_oe,
    input  wire        ena,
    input  wire        clk,
    input  wire        rst_n
);

    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

    // Single bit input (use ui_in[0]) and single bit output (uo_out[0])
    wire in_bit = ui_in[0];
    reg [7:0] out_reg;
    assign uo_out = out_reg;

    // Window and weights
    reg [3:0] window;
    localparam integer W0 = 8; // Most recent
    localparam integer W1 = 4;
    localparam integer W2 = 2;
    localparam integer W3 = 1; // Oldest

    integer sum;
    reg trend;
    wire reset = ~rst_n;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window <= 0;
            trend <= 0;
            out_reg <= 0;
        end else begin
            // Shift window, add newest bit at LSB (window[0])
            window <= {window[2:0], in_bit};

            // Compute weighted sum (recent bits have more weight)
            sum = window[3]*W0 + window[2]*W1 + window[1]*W2 + window[0]*W3;

            // Hysteresis thresholds
            if (sum >= 8)
                trend <= 1;
            else if (sum < 4)
                trend <= 0;
            // else, keep previous value

            out_reg <= {7'd0, trend}; // Only uo_out[0] is used
        end
    end

endmodule
