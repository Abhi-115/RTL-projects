//`timescale 1ns / 1ps


//module SPI_BRAM_TB();
//    reg spi_clk, resetn, spi_mosi, spi_ss_n;
//    wire spi_miso;
//    integer i;
//    reg [31:0] data_in;
//    reg [7:0] cmd_in;
    
//    SPI_BRAM UUT_SPI_BRAM(spi_clk,spi_ss_n,spi_mosi,resetn,spi_miso);
    
//    always #5.5 spi_clk = ~spi_clk;
    
//    // Task to send 32-bit data serially
//    task send_serial_data32;
//        input [31:0] data;
//        begin
//            for (i = 31; i >= 0; i = i - 1) begin
//                spi_mosi = data[i]; // Send MSB first
//                #11; // Wait for one clock cycle (10ns)
//            end
//        end
//    endtask
    
//    task send_serial_data8;
//        input [7:0] data;
//        begin
//            for (i = 7; i >= 0; i = i - 1) begin
//                spi_mosi = data[i]; // Send MSB first
//                #11; // Wait for one clock cycle (10ns)
//            end
//        end
//    endtask

//    initial begin
//        spi_clk = 0;
//        resetn = 0; spi_ss_n =1;
//        spi_mosi = 0;
////        spi_ss_n = 0;
//        #154 resetn =1; 
//        spi_ss_n = 0;
////        #11;
//        cmd_in = 8'hBD;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'h03;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'hA0;
//        send_serial_data8(cmd_in);
           
//        data_in = 32'h05A5A5A5;
//        send_serial_data32(data_in);
//        data_in = 32'hb5b5b5b5;
//        send_serial_data32(data_in);
//        data_in = 32'hc5c5c5c5;
//        send_serial_data32(data_in);
////        data_in = 32'hd5d5d5d5;
////        send_serial_data32(data_in);
////        data_in = 32'he5e5e5e5;
////        send_serial_data32(data_in);
////        #10;
//        spi_ss_n = 1;
//        #11 spi_ss_n = 0;
////        #11;
//        cmd_in = 8'hDB;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'h02;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'hA0;
//        send_serial_data8(cmd_in);
        
//        #737; //#5.5;
//        spi_ss_n = 1;
//        #22 spi_ss_n = 0;
        
//        cmd_in = 8'hBD;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'h02;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'hA3;
//        send_serial_data8(cmd_in);
        
//        data_in = 32'hd5d5d5d5;
//        send_serial_data32(data_in);
//        data_in = 32'he5e5e5e5;
//        send_serial_data32(data_in);
        
//         spi_ss_n = 1;
//        #22 spi_ss_n = 0;
        
//        cmd_in = 8'hBD;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'h03;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'hA5;
//        send_serial_data8(cmd_in);
           
//        data_in = 32'h15151515;
//        send_serial_data32(data_in);
//        data_in = 32'h25252525;
//        send_serial_data32(data_in);
//        data_in = 32'h35353535;
//        send_serial_data32(data_in);
        
////        #10;
//        spi_ss_n = 1;
//        #22 spi_ss_n = 0;
        
//        cmd_in = 8'hDB;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'h03;
//        send_serial_data8(cmd_in);
//        cmd_in = 8'hA4;
//        send_serial_data8(cmd_in);
        
////        data_in = 32'hA5A5A5A5;
////        send_serial_data32(data_in);
////        data_in = 32'hb5b5b5b5;
////        send_serial_data32(data_in);
////        data_in = 32'hc5c5c5c5;
////        send_serial_data32(data_in);
////        data_in = 32'hd5d5d5d5;
////        send_serial_data32(data_in);
////        data_in = 32'he5e5e5e5;
////        send_serial_data32(data_in);
//        #2500;
//        $finish;
//    end
//endmodule

////`timescale 1ns / 1ps
 
 
////module SPI_BRAM_TB();
////    reg spi_clk, resetn, spi_mosi, spi_ss_n;
////    wire spi_miso;
////    integer i=0;
////    reg [31:0] data_in=0;
////    reg [7:0] cmd_in=0;
////    SPI_BRAM UUT_SPI_BRAM(spi_clk,spi_ss_n,spi_mosi,resetn,spi_miso);
////    always #6 spi_clk = ~spi_clk;
////    // Task to send 32-bit data serially
////    task send_serial_data32;
////        input [31:0] data;
////        begin
////            for (i = 31; i >= 0; i = i - 1) begin
////                spi_mosi = data[i]; // Send MSB first
////                #12; // Wait for one clock cycle (10ns)
////            end
////        end
////    endtask
////    task send_serial_data8;
////        input [7:0] data;
////        begin
////            for (i = 7; i >= 0; i = i - 1) begin
////                spi_mosi = data[i]; // Send MSB first
////                #12; // Wait for one clock cycle (10ns)
////            end
////        end
////    endtask
 
////    initial begin
////        spi_clk = 0;
////        resetn = 0; spi_ss_n =1;
////        spi_mosi = 0;
////        #150 resetn =1; 
////        spi_ss_n = 0;
//////        #12;
//////        #8;
////        // write 3 words starting a0
////        cmd_in = 8'hDD;
////        send_serial_data8(cmd_in);
////        cmd_in = 8'hCD;
////        send_serial_data8(cmd_in);
////        cmd_in = 8'hBD;
////        send_serial_data8(cmd_in);
////        cmd_in = 8'h03;
////        send_serial_data8(cmd_in);
////        cmd_in = 8'hA0;
////        send_serial_data8(cmd_in);
////        data_in = 32'hA5A5A5A5;
////        send_serial_data32(data_in);
////        data_in = 32'hb5b5b5b5;
////        send_serial_data32(data_in);
////        data_in = 32'hc5c5c5c5;
////        send_serial_data32(data_in);
////        spi_ss_n = 1;
////        #12 spi_ss_n = 0;
//////        #12; //#12;
////        // read 3 words starting a0
////        cmd_in = 8'hDB;
////        send_serial_data8(cmd_in);
////        cmd_in = 8'h03;
////        send_serial_data8(cmd_in);
////        cmd_in = 8'hA0;
////        send_serial_data8(cmd_in);
////        #1188;
//////        #792;
////        // write 3 words starting a3
//////        cmd_in = 8'hBD;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'h03;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'hA3;
//////        send_serial_data8(cmd_in); 
//////        data_in = 32'h15151515;
//////        send_serial_data32(data_in);
//////        data_in = 32'h25252525;
//////        send_serial_data32(data_in);
//////        data_in = 32'h35353535;
//////        send_serial_data32(data_in);
//////        #12;
//////        // read 3 words starting a3
//////        cmd_in = 8'hDB;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'h03;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'hA3;
//////        send_serial_data8(cmd_in);
//////        #1188;
////////        #792;
//////        // write 3 words starting a6
//////        cmd_in = 8'hBD;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'h03;//02;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'hA6;
//////        send_serial_data8(cmd_in); 
//////        data_in = 32'h45454545;
//////        send_serial_data32(data_in);
//////        data_in = 32'h65656565;
//////        send_serial_data32(data_in);
//////        data_in = 32'h75757575;
//////        send_serial_data32(data_in);
//////        #12;
//////        // read 3 words starting a6
//////        cmd_in = 8'hDB;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'h03;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'hA6;//A7
//////        send_serial_data8(cmd_in);
//////        #1188;
//////        // write 3 words starting a9
//////        cmd_in = 8'hBD;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'h03;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'hA9;//A9
//////        send_serial_data8(cmd_in); 
//////        data_in = 32'hA5A5A5A5;
//////        send_serial_data32(data_in);
//////        data_in = 32'hb5b5b5b5;
//////        send_serial_data32(data_in);
//////        data_in = 32'hc5c5c5c5;
//////        send_serial_data32(data_in);
//////        #12;
//////        // read 6 words starting a6
//////        cmd_in = 8'hDB;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'h06;
//////        send_serial_data8(cmd_in);
//////        cmd_in = 8'hA6;//A7
//////        send_serial_data8(cmd_in);
//////        #1188;
//////        #1188;
////        #50;
////        $finish;
////    end
////endmodule

`timescale 1ns / 1ps

 
 
module SPI_BRAM_TB();
    reg spi_clk, resetn, spi_mosi, spi_ss_n;
    wire spi_miso;
    integer i;
    reg [31:0] data_in;
    reg [7:0] cmd_in;
    SPI_BRAM UUT_SPI_BRAM(spi_clk,spi_ss_n,spi_mosi,resetn,spi_miso);
    always #5.5 spi_clk = ~spi_clk;
    // Task to send 32-bit data serially
    task send_serial_data32;
        input [31:0] data;
        begin
            for (i = 31; i >= 0; i = i - 1) begin
                spi_mosi = data[i]; // Send MSB first
                #11; // Wait for one clock cycle (10ns)
            end
        end
    endtask
    task send_serial_data8;
        input [7:0] data;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                spi_mosi = data[i]; // Send MSB first
                #11; // Wait for one clock cycle (10ns)
            end
        end
    endtask
 
    initial begin
        spi_clk = 0;
        resetn = 0; spi_ss_n =1;
        spi_mosi = 0;
//        spi_ss_n = 0;
        #154 resetn =1; 
        spi_ss_n = 0;
//        #11;
        cmd_in = 8'hBD;
        send_serial_data8(cmd_in);
        cmd_in = 8'h03;
        send_serial_data8(cmd_in);
        cmd_in = 8'hA0;
        send_serial_data8(cmd_in);
        data_in = 32'hA5A5A5A5;
        send_serial_data32(data_in);
        data_in = 32'hb5b5b5b5;
        send_serial_data32(data_in);
        data_in = 32'hc5c5c5c5;
        send_serial_data32(data_in);
//        data_in = 32'hd5d5d5d5;
//        send_serial_data32(data_in);
//        data_in = 32'he5e5e5e5;
//        send_serial_data32(data_in);
//        #10;
        #11;
        spi_ss_n = 1;
        #11 spi_ss_n = 0;
//        #11;
        cmd_in = 8'hDB;
        send_serial_data8(cmd_in);
        cmd_in = 8'h02;
        send_serial_data8(cmd_in);
        cmd_in = 8'hA0;
        send_serial_data8(cmd_in);
        #737; //#5.5;
        #11;
        spi_ss_n = 1;
        #22 spi_ss_n = 0;
        cmd_in = 8'hBD;
        send_serial_data8(cmd_in);
        cmd_in = 8'h02;
        send_serial_data8(cmd_in);
        cmd_in = 8'hA3;
        send_serial_data8(cmd_in);
        data_in = 32'hd5d5d5d5;
        send_serial_data32(data_in);
        data_in = 32'he5e5e5e5;
        send_serial_data32(data_in);
        #11;
         spi_ss_n = 1;
        #22 spi_ss_n = 0;
        cmd_in = 8'hBD;
        send_serial_data8(cmd_in);
        cmd_in = 8'h03;
        send_serial_data8(cmd_in);
        cmd_in = 8'hA5;
        send_serial_data8(cmd_in);
        data_in = 32'h15151515;
        send_serial_data32(data_in);
        data_in = 32'h25252525;
        send_serial_data32(data_in);
        data_in = 32'h35353535;
        send_serial_data32(data_in);
        #11;
        spi_ss_n = 1;
        #22 spi_ss_n = 0;
        cmd_in = 8'hDB;
        send_serial_data8(cmd_in);
        cmd_in = 8'h04;
        send_serial_data8(cmd_in);
        cmd_in = 8'hA0;
        send_serial_data8(cmd_in);
        
        #1441;
        #11;
        spi_ss_n = 1;
        #22 spi_ss_n = 0;
        cmd_in = 8'hDB;
        send_serial_data8(cmd_in);
        cmd_in = 8'h01;
        send_serial_data8(cmd_in);
        cmd_in = 8'hA4;
        send_serial_data8(cmd_in);
//        data_in = 32'hA5A5A5A5;
//        send_serial_data32(data_in);
//        data_in = 32'hb5b5b5b5;
//        send_serial_data32(data_in);
//        data_in = 32'hc5c5c5c5;
//        send_serial_data32(data_in);
//        data_in = 32'hd5d5d5d5;
//        send_serial_data32(data_in);
//        data_in = 32'he5e5e5e5;
//        send_serial_data32(data_in);
        #1441;#22;
        spi_ss_n = 1;
        
        #300;
        
        $finish;
    end
endmodule