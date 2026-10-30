`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/31/2026 11:18:08 AM
// Design Name: 
// Module Name: axi4_top
// Project Name: 
// Target Devices: 
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


module AXI4_LITE_TOP(
        input CLK,
        input RESETN,
        input START,
        input [15:0] CMD_IN,
        input [31:0] DATA_IN,
        output GET_DATA,
        output GET_CMD,
        output [31:0] DATA_OUT
    );
    
    
    wire [7:0] m_axi_awaddr;
    wire       m_axi_awvalid;
    wire       s_axi_awready;
    
    wire [31:0] m_axi_wdata;
    wire        m_axi_wvalid;
    wire        s_axi_wready;
    wire [3:0]  m_axi_wstrb;
    
    wire [7:0] m_axi_araddr;
    wire       m_axi_arvalid;
    wire       s_axi_arready;
    
    wire [31:0] s_axi_rdata;
    wire        s_axi_rvalid;
    wire        m_axi_rready;
    wire [1:0]  s_axi_rresp;
    
    wire [1:0] s_axi_bresp;
    wire       s_axi_bvalid;
    wire       m_axi_bready;
    
    wire error;
    assign error = (s_axi_bresp == 2'b01) || (s_axi_rresp == 2'b01);
     
    axi4_lite_master master_uut(
            .M_AXI_ACLK(CLK),
            .M_AXI_ARESETN(RESETN),
            .input_cmd_packet(CMD_IN),
            .input_data_packet(DATA_IN),
            .output_data_packet(DATA_OUT),
            .start(START),
            .get_data(GET_DATA), 
            .get_command(GET_CMD),
//            .done(),
            .M_AXI_AWADDR(m_axi_awaddr),
            .M_AXI_AWVALID(m_axi_awvalid),
            .M_AXI_AWREADY(s_axi_awready),
            .M_AXI_WDATA(m_axi_wdata),
            .M_AXI_WSTRB(m_axi_wstrb),
            .M_AXI_WVALID(m_axi_wvalid),
            .M_AXI_WREADY(s_axi_wready),
            .M_AXI_BVALID(s_axi_bvalid),
            .M_AXI_BREADY(m_axi_bready),
//            .M_AXI_BRESP(s_axi_bresp),
            .M_AXI_ARADDR(m_axi_araddr),
            .M_AXI_ARVALID(m_axi_arvalid),
            .M_AXI_ARREADY(s_axi_arready),
            .M_AXI_RDATA(s_axi_rdata),
            .M_AXI_RVALID(s_axi_rvalid),
            .M_AXI_RREADY(m_axi_rready)//,
//            .M_AXI_RRESP(s_axi_rresp)
    );
    
    axi4_lite_slave slave_uut(
            .S_AXI_ACLK(CLK),
            .S_AXI_ARESETN(RESETN),
            .S_AXI_AWADDR(m_axi_awaddr),
            .S_AXI_AWVALID(m_axi_awvalid),
            .S_AXI_AWREADY(s_axi_awready),
            .S_AXI_WDATA(m_axi_wdata),
            .S_AXI_WSTRB(m_axi_wstrb),
            .S_AXI_WVALID(m_axi_wvalid),
            .S_AXI_WREADY(s_axi_wready),
            .S_AXI_BRESP(s_axi_bresp),
            .S_AXI_BVALID(s_axi_bvalid),
            .S_AXI_BREADY(m_axi_bready),
            .S_AXI_ARADDR(m_axi_araddr),
            .S_AXI_ARVALID(m_axi_arvalid),
            .S_AXI_ARREADY(s_axi_arready),
            .S_AXI_RDATA(s_axi_rdata),
            .S_AXI_RRESP(s_axi_rresp),
            .S_AXI_RVALID(s_axi_rvalid),
            .S_AXI_RREADY(m_axi_rready)
    );
endmodule
