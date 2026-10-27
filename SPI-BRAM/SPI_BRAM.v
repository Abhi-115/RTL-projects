//`timescale 1ns / 1ps

module SPI_BRAM(
    input spi_clk,
    input spi_ss_n,
    input spi_mosi,
    input resetn,
    output spi_miso
    );
 
    wire [31:0] data_in, data_out;
    wire [7:0] addra;
    wire byte_done, data_write_done, data_read_start;
    reg size_count_done;
    reg en_sipo8, en_sipo32, en_piso32, en_size, wea;
    reg [7:0] size,addr,count_size;
    wire [7:0] cmd_byte;
    sipo_8 cmd_bytes_sipo(
        .clk(spi_clk),
        .resetn(resetn),
        .ss_n(spi_ss_n),
        .enable_sipo8(en_sipo8),
        .serial_in(spi_mosi),
        .EN(byte_done),
        .parallel_out(cmd_byte)
    );
    sipo_32 in_data_4byte_sipo(
        .clk(spi_clk),
        .resetn(resetn),
        .ss_n(spi_ss_n),
        .enable_sipo32(en_sipo32),
        .serial_in(spi_mosi),
        .EN(data_write_done),
        .parallel_out(data_in)
    );
    piso_32 out_data_4byte_piso(
        .clk(spi_clk),
        .resetn(resetn),
        .ss_n(spi_ss_n),
        .enable_piso32(en_piso32),
        .parallel_in(data_out),
        .EN(data_read_start),
        .serial_out(spi_miso)
    );
    blk_mem_gen_1 bram_peripheral (
      .clka(spi_clk),    // input wire clka
      .ena(~spi_ss_n),      // input wire ena
      .wea(wea),      // input wire [0 : 0] wea
      .addra(addra),  // input wire [7 : 0] addra
      .dina(data_in),    // input wire [31 : 0] dina
      .douta(data_out)  // output wire [31 : 0] douta
    );
    parameter init = 3'd0, write_size = 3'd1, read_size = 3'd2, write_addr = 3'd3, read_addr = 3'd4, write_data = 3'd5,read_data = 3'd6,read_latency = 3'd7;
    reg [2:0] present_state, next_state;
    reg en_latency_count,latency_count_done;
    reg [1:0] latency_count;
    always @(posedge spi_clk) begin
        if (~resetn || spi_ss_n) begin // || spi_ss_n
                latency_count <= 0; 
                latency_count_done <= 0; 
            end
        else begin
            if (en_latency_count) begin
                if (latency_count == 2'd2) begin
                    latency_count <= 0;
                    latency_count_done <= 1;
                end
                else begin
                    latency_count <= latency_count + 1;
                    latency_count_done <= 0;
                end
            end
        end
     end
    always @(posedge spi_clk) begin
        if (~resetn || spi_ss_n) begin 
            present_state <= init; 
        end
        else begin
            present_state <= next_state;
        end
    end
    always @(*) begin
        case (present_state)
             init: begin
                    if (spi_ss_n) next_state = init;
                    else begin
                    if (byte_done) begin
                        if (cmd_byte == 8'hBD) next_state = write_size;
                        else if (cmd_byte == 8'hDB) next_state = read_size;
                        else next_state = init;
                    end
                    else next_state = init;
                  end
                  end
             write_size: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (byte_done) next_state = write_addr;
                        else next_state = write_size;
                    end
                    end
             read_size: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (byte_done) next_state = read_addr;
                        else next_state = read_size;
                   end
                    end
             write_addr: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (byte_done) next_state = write_data;
                        else next_state = write_addr;
                    end
                    end
             read_addr: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (byte_done) next_state = read_data;
                        else next_state = read_addr;
                   end
                    end
             write_data: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (size_count_done) next_state = init;
                        else next_state = write_data;
                    end
                    end
             read_data: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (size_count_done) next_state = read_latency;
                        else next_state = read_data;
                   end
                    end
             read_latency: begin 
                    if (spi_ss_n) next_state = init;
                    else begin
                        if (latency_count_done) next_state = init;
                        else next_state = read_latency;
                    end
                    end
//             default: next_state = init;
        endcase
    end
    always @(*) begin
        case (next_state)
            init: begin
                    en_sipo8 = 1;
                    en_sipo32 = 0;
                    en_piso32 = 0;
                    en_size = 0;
                    wea = 0;
                    en_latency_count = 0;
                  end
             write_size: begin
                    en_sipo8 = 1;
                    en_sipo32 = 0;
                    en_piso32 = 0;
                    en_size = 0;
                    wea = 0;
//                    size = cmd_byte;
                    en_latency_count = 0;
                  end
             read_size:begin
                    en_sipo8 = 1;
                    en_sipo32 = 0;
                    en_piso32 = 0;
                    en_size = 0;
//                    size = cmd_byte;
                    en_latency_count = 0;
                    wea = 0;
                  end
             write_addr:begin
                    en_sipo8 = 1;
                    en_sipo32 = 0;
                    en_piso32 = 0;
                    en_size = 0;
                    wea = 0;
                    en_latency_count = 0;
                  end
             read_addr:begin
                    en_sipo8 = 1;
                    en_sipo32 = 0;
                    en_piso32 = 0;
                    en_size = 0;
                    wea = 0;
                    en_latency_count = 0;
                  end
             write_data:begin
                    en_sipo8 = 0;
                    en_sipo32 = 1;
                    en_piso32 = 0;
                    en_size = 1;
                    wea = 1;
                    en_latency_count = 0;
                  end
             read_data:begin
                    en_sipo8 = 0;
                    en_sipo32 = 0;
                    en_piso32 = 1;
                    en_size = 1;
                    en_latency_count = 0;
                    wea = 0;
                  end
             read_latency:begin
                    en_sipo8 = 0;
                    en_sipo32 = 0;
                    en_piso32 = 1;
                    en_size = 1;
                    wea = 0;
                    en_latency_count = 1;
                  end
//             default:begin
//                    en_sipo8 = 1;
//                    en_sipo32 = 0;
//                    en_piso32 = 0;
//                    en_size = 0;
//                    wea = 0;
//                  end        
        endcase
    end
    always @(posedge spi_clk) begin
        if (~resetn || spi_ss_n) begin // || spi_ss_n
            size <= 0;
            addr <= 0;
        end
        else begin
            if ((byte_done==1) && ((present_state == write_size)||(present_state == read_size))) size <= cmd_byte;
//            else size <= 0;
            if ((byte_done==1) && ((present_state == write_addr)||(present_state == read_addr))) addr <= cmd_byte;
//            else addr <= 0;
        end
    end
    always @(posedge spi_clk) begin: size_counter
        if (~resetn || spi_ss_n) begin // || spi_ss_n
             count_size <= 0;
             size_count_done <= 0;
        end
        else begin
            if (en_size) begin
                if (data_write_done || data_read_start) begin
                    if (count_size == size-1) begin
                        count_size <= 0;
                        size_count_done <= 1;
                    end    
                    else begin
                        count_size <= count_size + 1;
                        size_count_done <= 0;
                    end
                end
            end
            else begin 
                count_size <= 0;
                size_count_done <= 0;
            end               
        end  
   end
//   always @ (posedge spi_clk) begin
//        if(~resetn) begin addra <= 0; end
//        else if (en_size)
//            addra <= addr + count_size;
//        else addra <= 0;
//   end
   assign addra = /*(en_size) ? */addr + count_size/*: 8'b0*/; 
endmodule