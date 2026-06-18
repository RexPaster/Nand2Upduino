`include "../03/ram_16K_optimized.sv"
`include "screen_8K.sv"

module memory(input[15:0] in, input clock, load, input[14:0] address, output[15:0] out);
  wire[15:0] outM, outS, outSK;
  wire Mload, Sload;

  assign Mload = ~address[14] & load;
  assign Sload = address[14] & load;

  ram_16K_optimized ram16k(in, address[13:0], Mload,clock, outM);
  screen_8K screen(in, address[12:0], Sload, clock, outS);
  reg [15:0] scancode /*verilator public*/;

  assign outSK = address[13] ? scancode : outS;
  assign out = address[14] ? outSK : outM;
endmodule
