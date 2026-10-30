`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Abhinava
// 
// Create Date: 01/27/2026 07:44:26 PM
// Design Name: AXI4-Lite Interface with on chip BRAM
// Module Name: axi4_lite_master
// Project Name: 
// Target Devices: Basys-3
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
 
`timescale 1ns / 1ps
 
module axi4_lite_master #(
    parameter integer AXI_ADDR_WIDTH = 8,
    parameter integer AXI_DATA_WIDTH = 32
    )
    (
    input wire M_AXI_ACLK,
    input wire M_AXI_ARESETN,
    
    // top interface signals
    input wire [15:0] input_cmd_packet,
    input wire [31:0] input_data_packet,
    output reg [31:0] output_data_packet,
    input start,
    output wire get_data, 
    output wire get_command,
    
    // AXI-Lite interface
    
    //aw
    output reg [AXI_ADDR_WIDTH-1:0] M_AXI_AWADDR,
    output reg M_AXI_AWVALID,
    input wire M_AXI_AWREADY,
    
    //w
    output reg [AXI_DATA_WIDTH-1:0] M_AXI_WDATA,
    output reg [AXI_DATA_WIDTH/8-1:0] M_AXI_WSTRB,
    output reg M_AXI_WVALID,
    input wire M_AXI_WREADY,
    
    //b
    input wire M_AXI_BVALID,
    output reg M_AXI_BREADY,
 
    //ar
    output reg [AXI_ADDR_WIDTH-1:0] M_AXI_ARADDR,
    output reg M_AXI_ARVALID,
    input wire M_AXI_ARREADY,
 
    //r
    input wire [AXI_DATA_WIDTH-1:0] M_AXI_RDATA,
    input wire M_AXI_RVALID,
    output reg M_AXI_RREADY
    );
 
    // State Machine States
    reg [2:0] current_state, next_state;
    
    localparam IDLE = 3'b000;
    localparam GET_COMMAND   = 3'b001;   
    localparam READ_ARADDR   = 3'b010;
    localparam READ_DATA   = 3'b011;
    localparam WRITE_AWADDR = 3'b100;
    localparam WRITE_DATA   = 3'b101;
    localparam WRITE_RESP   = 3'b110;
    localparam WRITE_DONE = 3'b111;
    
    // Internal signals
    wire input_cmd;  //0 -> Read, 1 -> Write
    wire [6:0] data_size;
    wire [7:0] start_addr;
    reg [6:0] data_count;
    
    reg axi_bvalid_d;
    wire axi_bvalid_negedge;
    
    always @(posedge M_AXI_ACLK or negedge M_AXI_ARESETN) begin
        if(!M_AXI_ARESETN) axi_bvalid_d <= 0;
        else axi_bvalid_d <= M_AXI_BVALID;
    end
    
    assign axi_bvalid_negedge = axi_bvalid_d & ~M_AXI_BVALID;   
    
    //chunk out the fields from the input command packet
    assign input_cmd = input_cmd_packet[15];
    assign data_size = input_cmd_packet[14:8];
    assign start_addr = input_cmd_packet[7:0];
      
    always @(posedge M_AXI_ACLK or negedge M_AXI_ARESETN) begin
        if(!M_AXI_ARESETN)
            data_count <= 0;
        else 
            if(axi_bvalid_negedge || M_AXI_RVALID) begin
                if (data_count >= data_size-1 || get_command)  //reset data_count to 0 every time a new command is fetched
                    data_count <= 0;
                else data_count <= data_count + 1; 
            end
    end
    
    // State transition logic
    always @(posedge M_AXI_ACLK or negedge M_AXI_ARESETN) begin
        if (!M_AXI_ARESETN)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
 
    // Next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                    if(start) next_state = GET_COMMAND;
                    
                  end
            GET_COMMAND: begin
                            if (input_cmd == 1'b0) 
                                next_state = READ_ARADDR;
                            else if (input_cmd == 1'b1) 
                                next_state = WRITE_AWADDR;
                         end
 
            READ_ARADDR: if (M_AXI_ARREADY) 
                            next_state = READ_DATA;
 
            READ_DATA: begin
                          if(M_AXI_RVALID) begin
                            if(data_count >= data_size-1)
                                next_state = GET_COMMAND;
                            else next_state = READ_ARADDR;
                          end
                       end
 
            WRITE_AWADDR: if(M_AXI_AWREADY) next_state = WRITE_DATA;
 
            WRITE_DATA: if (M_AXI_WREADY) 
                            next_state = WRITE_RESP;
 
            WRITE_RESP: if (M_AXI_BVALID) 
                            next_state = WRITE_DONE;
            
            WRITE_DONE: if(data_count >= data_size-1)
                             next_state = GET_COMMAND;
                        else next_state = WRITE_AWADDR;
 
            default: next_state = IDLE;
        endcase
    end
 
    assign get_command = (current_state == GET_COMMAND);
    assign get_data = (current_state == WRITE_AWADDR);
    
       
    // Control outputs
    always @(posedge M_AXI_ACLK or negedge M_AXI_ARESETN) begin
        if (!M_AXI_ARESETN) begin
            M_AXI_AWVALID <= 0;
            M_AXI_WVALID  <= 0;
            M_AXI_BREADY  <= 0;
            M_AXI_ARVALID <= 0;
            M_AXI_RREADY  <= 0;
        end 
        else begin
            case (current_state)
                IDLE: begin
                    M_AXI_AWVALID <= 0;
                    M_AXI_WVALID  <= 0;
                    M_AXI_BREADY  <= 0;
                    M_AXI_ARVALID <= 0;
                    M_AXI_RREADY  <= 0;
                end
                 
                READ_ARADDR: begin
                                M_AXI_ARADDR  <= start_addr + (data_count);
                                M_AXI_ARVALID <= 1;
                                M_AXI_RREADY  <= 1;
                            end
 
                READ_DATA: begin
                             M_AXI_ARVALID <= 0;
                             if (M_AXI_RVALID) begin
                                output_data_packet <= M_AXI_RDATA;
                                M_AXI_RREADY <= 0;
                             end
                           end
                        
                WRITE_AWADDR: begin
                                M_AXI_AWADDR  <= start_addr + (data_count);
                                M_AXI_AWVALID <= 1;
                             end
                 
                 WRITE_DATA: begin
                                M_AXI_WDATA   <= input_data_packet;
                                M_AXI_WSTRB   <= 4'b1111;
                                M_AXI_WVALID  <= 1;
                                M_AXI_AWVALID <= 0;
                            end
 
                WRITE_RESP: begin
                              M_AXI_WVALID  <= 0;
                              M_AXI_WSTRB   <= 4'b0000;
                              M_AXI_BREADY <= 1;
                            end
 
                WRITE_DONE: begin
                                M_AXI_BREADY <= 0;
                            end
           endcase
        end
    end
 
     
endmodule