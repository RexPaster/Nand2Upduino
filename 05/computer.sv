`define computer 1

module computer(
    input reset,
    input clock,
    input [15:0] scancode //Keyboard Scancode Passthrough
);
  wire writeM;

  wire [15:0] cpuValueToMemory;

  wire [14:0] pc;
  wire [14:0] addressM;
  wire [15:0] instruction;
  wire [15:0] value_to_cpu;

  memory memory(cpuValueToMemory, !clock, writeM, addressM, value_to_cpu, scancode);
  rom_32K rom(pc, instruction);

  cpu_jopdorp_optimized cpu(value_to_cpu,
    instruction,
    reset,
    clock,
    cpuValueToMemory,
    writeM,
    addressM,
    pc);
endmodule
