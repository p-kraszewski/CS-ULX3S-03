`ifdef VERILATOR
// -----------------------------------------------------------------------------

// Begin of VERILATOR module header
//

module knight_rider(
        input i_clk,
        output [7:0] led
    );

    localparam ctr_width = 2;

    //
    // End of VERILATOR module header

`else

// -----------------------------------------------------------------------------


// Begin of real synthesis module header
//

module top(
        input clk_25mhz,
        output [7:0] led,
        output wifi_gpio0
    );

    wire i_clk;

    // Tie GPIO0, keep board from rebooting
    assign wifi_gpio0 = 1'b1;

    assign i_clk         = clk_25mhz;
    localparam ctr_width = 20;

`endif

    //
    // End of real synthesis module header

    // ------------------------------------------------------------------------

    // Begin of common code
    //
    reg [7:0] o_led         = 1;
    assign led              = o_led;
    reg [ctr_width-1:0] ctr = 1;
    reg dir                 = 0;

    always @(posedge i_clk) begin
        ctr <= ctr + 1;

        if (ctr == 0) begin
            if (dir) begin
                o_led[6:0] <= o_led[7:1];
                o_led[7]   <= o_led[0];
            end
            else
            begin
                o_led[7:1] <= o_led[6:0];
                o_led[0]   <= o_led[7];
            end

            if (o_led[6]) dir <= 1;
            if (o_led[1]) dir <= 0;
        end
    end

    //
    // End of common code

endmodule
