module cache_imem(
    input clk,// rst,
    input [31:0] addr,
    input cache_en, main_imem_en,
    output reg [31:0] insn
);
    wire [127:0] cache_insn;
    wire [127:0] main_imem_insn;
    
     
    blk_mem_gen_0 main_imem (
    .clka(clk),    // input wire clka
    .ena(main_imem_en),      // input wire ena
    .addra(addr[11:4]),  // input wire [7 : 0] addra
    .douta(main_imem_insn)  // output wire [127 : 0] douta
    );
    
    
    dist_c_imem_gen_1 cache_imem (
      .a(addr[7:4]),      // input wire [3 : 0] a
      .d(main_imem_insn),      // input wire [127 : 0] d
      .clk(clk),  // input wire clk
      .we(cache_en),    // input wire we
      .spo(cache_insn)  // output wire [127 : 0] spo
    );
    
    always @(*) begin
        case(addr[3:2])
            2'b00: insn = cache_insn[31:0];
            2'b01: insn = cache_insn[63:32];
            2'b10: insn = cache_insn[95:64];
            2'b11: insn = cache_insn[127:96];
         endcase
    end
    
endmodule