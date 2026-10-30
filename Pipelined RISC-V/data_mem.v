module data_mem(
    input [9:0] mem_addr,
    input clk,
    input dmw, dmr,
    input lb,lbu,lh,lhu,lw,
    input sw,sh,sb,
    input [31:0] mem_write_data_in,
    output [31:0] mem_read_data_out
);
wire [31:0] mem_read_data;
wire [31:0] mem_write_data;
reg [7:0] data_byte0_L1, data_byte2_L1;
wire [7:0] data_byte1_L1, data_byte1_L2;

wire [3:0] byte_write_enable;

wire w1, w2;
wire [1:0] w3;

dist_mem_gen_0 data_7_0 (
  .a(mem_addr[9:2]),      // input wire [7 : 0] a
  .d(mem_write_data[7:0]),      // input wire [7 : 0] d
  .clk(clk),  // input wire clk
  .we(byte_write_enable[0] & dmw),    // input wire we
  .qspo_ce(dmr),  // input wire qspo_ce
  .qspo(mem_read_data[7:0])        // output wire [7 : 0] qspo
);

dist_mem_gen_0 data_15_8 (
  .a(mem_addr[9:2]),      // input wire [7 : 0] a
  .d(mem_write_data[15:8]),      // input wire [7 : 0] d
  .clk(clk),  // input wire clk
  .we(byte_write_enable[1] & dmw),    // input wire we
  .qspo_ce(dmr),  // input wire qspo_ce
  .qspo(mem_read_data[15:8])        // output wire [7 : 0] qspo
);

dist_mem_gen_0 data_23_16 (
  .a(mem_addr[9:2]),      // input wire [7 : 0] a
  .d(mem_write_data[23:16]),      // input wire [7 : 0] d
  .clk(clk),  // input wire clk
  .we(byte_write_enable[2] & dmw),    // input wire we
  .qspo_ce(dmr),  // input wire qspo_ce
  .qspo(mem_read_data[23:16])        // output wire [7 : 0] qspo
);

dist_mem_gen_0 data_31_24 (
  .a(mem_addr[9:2]),      // input wire [7 : 0] a
  .d(mem_write_data[31:24]),      // input wire [7 : 0] d
  .clk(clk),  // input wire clk
  .we(byte_write_enable[3] & dmw),    // input wire we
  .qspo_ce(dmr),  // input wire qspo_ce
  .qspo(mem_read_data[31:24])        // output wire [7 : 0] qspo
);

/********************************************/
/*********** RV32 Aligned Read HW ***********/
/********************************************/

always @(*) begin
    case((mem_addr[1:0])&(lb|lbu))
        2'b00: data_byte0_L1 = mem_read_data[7:0];
        2'b01: data_byte0_L1= mem_read_data[15:8];
        2'b10: data_byte0_L1= mem_read_data[23:16];
        2'b11: data_byte0_L1 = mem_read_data[31:24];
    endcase
end

assign mem_read_data_out[7:0] = lw ? mem_read_data[7:0] : (lh | lhu) ? (mem_addr[1] ? mem_read_data[23:16] : mem_read_data[7:0]) : data_byte0_L1;

assign data_byte1_L1 = ({lb,lbu} == 2'b10) ? {8{data_byte0_L1[7]}} : 8'b0;
assign data_byte1_L2 = mem_addr[1] ? mem_read_data[31:24] : mem_read_data[15:8];

assign mem_read_data_out[15:8] = lw ? mem_read_data[15:8] : (lh | lhu) ? data_byte1_L2 : data_byte1_L1;

always @(*) begin
    case({lh,lhu})
        2'b10: data_byte2_L1 = {8{data_byte1_L2[7]}};
        2'b00: data_byte2_L1 = data_byte1_L1;
        default: data_byte2_L1 = 8'b0;
    endcase
end

assign mem_read_data_out[23:16] = lw ? mem_read_data[23:16] : data_byte2_L1;

assign mem_read_data_out[31:24] = lw ? mem_read_data[31:24] : data_byte2_L1;

/********************************************/

/*********************************************/
/*********** RV32 Aligned Write HW ***********/
/*********************************************/

assign w1 = (sb && mem_addr[1:0] == 2'b01) ? 1'b1 : 1'b0;
assign w2 = (sb|sh && mem_addr[1:0] == 2'b10) ? 1'b1 : 1'b0;
assign w3 = (sb && mem_addr[1:0] == 2'b11) ? 2'd2 : (sh && mem_addr[1:0] == 2'b10) ? 2'd1: 2'd0;

assign mem_write_data[7:0] = mem_write_data_in[7:0];
assign mem_write_data[15:8] = w1 ? mem_write_data_in[7:0] : mem_write_data_in[15:8];
assign mem_write_data[23:16] = w2 ? mem_write_data_in[7:0] : mem_write_data_in[23:16];
assign mem_write_data[31:24] = (w3 == 2'd2) ? mem_write_data_in[7:0] : (w3 == 2'd1) ? mem_write_data_in[15:8] : mem_write_data_in[31:24];

assign byte_write_enable[3] = ((sw && mem_addr[1:0] == 2'b00) | (sh && mem_addr[1:0] == 2'b10) | (sb && mem_addr[1:0] == 2'b11)) ? 1'b1 : 1'b0;
assign byte_write_enable[2] = ((sw && mem_addr[1:0] == 2'b00) | (sh && mem_addr[1:0] == 2'b10) | (sb && mem_addr[1:0] == 2'b10)) ? 1'b1 : 1'b0;
assign byte_write_enable[1] = ((sw && mem_addr[1:0] == 2'b00) | (sh && mem_addr[1:0] == 2'b00) | (sb && mem_addr[1:0] == 2'b01)) ? 1'b1 : 1'b0;
assign byte_write_enable[0] = ((sw && mem_addr[1:0] == 2'b00) | (sh && mem_addr[1:0] == 2'b00) | (sb && mem_addr[1:0] == 2'b00)) ? 1'b1 : 1'b0;
 
/********************************************/

endmodule