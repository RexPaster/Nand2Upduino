`include "05/computer.sv"
`include "ps2/ps2_to_hack_decoder.sv"
`include "ps2/ps2_listener.sv"
`include "05/cpu_jopdorp_optimized.sv"
`include "05/rom_32K.sv"
`include "05/memory.sv"
`include "03/ram_16K_optimized.sv"
`include "05/screen_8K.sv"
`include "02/alu_optimized.sv"
module top #(
    parameter bit SIMULATION = 1'b0
) (
    input logic clk_12mhz,
    input logic rst_n,
    input logic ps2_clk,
    input logic ps2_data
);

computer computer(
    .reset(rst_n),
    .clock(clk_12mhz),
    .scancode(scancode)
);


logic [31:0] ps2_out;
ps2_listener ps2_listener (
    .reset(rst_n),

    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),

    .lastFourBytes(ps2_out)
);


logic [15:0] scancode;
ps2_to_hack_decoder ps2_decoder(
    .lastFourBytes(ps2_out),
    .hack_code(scancode)
);

endmodule
