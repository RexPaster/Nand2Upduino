`define mux 1

module mux(
    input  a,
    input  b,
    input  select,
    output out
);
  assign out = select ? b : a;
endmodule
