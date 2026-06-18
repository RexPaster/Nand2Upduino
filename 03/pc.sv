`ifndef inc_16
    `include "../02/inc_16.sv"
`endif
`ifndef register_n2t
    `include "register_n2t.sv"
`endif
`define pc 1

module pc(
    input  [15:0] in,
    input         load,
    input         inc,
    input         reset,
    input         clk,
    output [15:0] out
);
    wire [15:0] incremented;
    wire [15:0] new_or_reset_value;

    inc_16 increment(out, incremented);

    assign new_or_reset_value = reset
        ? 16'b0
        : (load ? in : (inc ? incremented : in));

    register_n2t count(new_or_reset_value, load | inc | reset, clk, out);

endmodule
