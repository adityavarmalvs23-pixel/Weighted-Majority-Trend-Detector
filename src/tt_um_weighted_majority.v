// SPDX-License-Identifier: Apache-2.0
`default_nettype none

module tt_um_weighted_majority (
    input  wire [7:0]  ui_in,    // Inputs: [0] = bit stream in
    output wire [7:0]  uo_out,   // Outputs: [0] = trend output
    input  wire [7:0]  uio_in,
    output wire [7:0]  uio_out,
    output wire [7:0]  uio_oe,
    input  wire        ena,
    input  wire        clk,
    input  wire        rst_n
);

    // Tie off unused IOs
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

    wire in_bit = ui_in[0];
    wire trend_out;

    assign uo_out[0] = trend_out;
    assign uo_out[7:1] = 7'b0;

    // ---- Configurable Parameters ----
    parameter N = 4;
    parameter WIDTH = 4;

    reg [N-1:0] window;
    reg [WIDTH-1:0] weights [0:N-1];
    localparam [WIDTH-1:0] W0 = 8;
    localparam [WIDTH-1:0] W1 = 4;
    localparam [WIDTH-1:0] W2 = 2;
    localparam [WIDTH-1:0] W3 = 1;
    //localparam [WIDTH-1:0] default_weights [0:N-1] = '{8, 4, 2, 1};

    reg [WIDTH+N-1:0] sum;
    reg trend;
    wire reset = ~rst_n;

    assign trend_out = trend;

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            window <= 0;
            trend <= 0;
            for (i = 0; i < N; i = i + 1)
                weights[i] <= default_weights[i];
        end else begin
            window <= {window[N-2:0], in_bit};
            sum = 0;
            for (i = 0; i < N; i = i + 1)
                sum = sum + window[i] * weights[i];
            if (sum >= 8)
                trend <= 1;
            else if (sum < 4)
                trend <= 0;
            // else, hold previous trend (hysteresis)
        end
    end

endmodule
