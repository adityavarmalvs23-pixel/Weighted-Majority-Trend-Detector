`default_nettype none
`timescale 1ns / 1ps

module tb ();

    reg clk, rst_n, ena;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    wire [7:0] uio_in, uio_out, uio_oe;

//`ifdef GL_TEST
//    supply1 VPWR;
//    supply0 VGND;
//`endif

    tt_um_weighted_majority dut (
//`ifdef GL_TEST
//        .VPWR(VPWR),
//        .VGND(VGND),
//`endif
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe)
    );

    assign uio_in = 8'd0;

    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
        clk = 0;
        rst_n = 1;
        ena = 1;
        ui_in = 8'b00000000;

        #20 rst_n = 0;
        #20 rst_n = 1;

        // Send '0' bits
        repeat (4) begin
            ui_in[0] = 0;
            #10;
        end

        // Send '1' bits
        repeat (5) begin
            ui_in[0] = 1;
            #10;
        end

        // Send '0' bits again
        repeat (6) begin
            ui_in[0] = 0;
            #10;
        end

        #100 $finish;
    end

    //initial begin
    //    $monitor("T=%0t | ui_in[0]=%b | uo_out[0]=%b", $time, ui_in[0], uo_out[0]);
    //end

endmodule
