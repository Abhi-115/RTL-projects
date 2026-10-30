module imem(
//    input clk,
    input [7:0] imem_addr,
    output [31:0] insn
);

//dist_mem_gen_1 IMEM (
//  .a(imem_addr),      // input wire [7 : 0] a
//  .spo(insn)  // output wire [31 : 0] spo
//);
//dist_mem_gen_1 IMEM (
//  .a(imem_addr),      // input wire [7 : 0] a
//  .spo(insn)  // output wire [31 : 0] spo
//);

//dist_mem_gen_1 IMEM (   //sayo code as coe
//  .a(imem_addr),      // input wire [7 : 0] a
//  .spo(insn)  // output wire [31 : 0] spo
//);

dist_mem_gen_1 IMEM (
  .a(imem_addr),      // input wire [7 : 0] a
  .spo(insn)  // output wire [31 : 0] spo
);

//dist_mem_gen_2 IMEM (   // my code as coe
//  .a(imem_addr),      // input wire [7 : 0] a
//  .spo(insn)  // output wire [31 : 0] spo
//);
endmodule