module axi4_lite_slave#(
    parameter integer AXI_ADDR_WIDTH = 8,
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer MEM_SIZE = 256
    )
    (
    input wire                           S_AXI_ACLK,
    input wire                           S_AXI_ARESETN,
    
    // aw
    input wire [AXI_ADDR_WIDTH-1 : 0]   S_AXI_AWADDR,
    input wire                          S_AXI_AWVALID,
    output wire                         S_AXI_AWREADY,

    // w
    input wire [AXI_DATA_WIDTH-1 : 0]     S_AXI_WDATA,
    input wire [AXI_DATA_WIDTH/8-1 : 0]   S_AXI_WSTRB,
    input wire                            S_AXI_WVALID,
    output wire                           S_AXI_WREADY,

    // b resp
    output wire [1 : 0]                   S_AXI_BRESP,
    output wire                           S_AXI_BVALID,
    input wire                            S_AXI_BREADY,

    // ar
    input wire [AXI_ADDR_WIDTH-1 : 0]     S_AXI_ARADDR,
    input wire                            S_AXI_ARVALID,
    output wire                           S_AXI_ARREADY,

    // r
    output wire [AXI_DATA_WIDTH-1 : 0]    S_AXI_RDATA,
    output wire [1 : 0]                   S_AXI_RRESP,
    output wire                           S_AXI_RVALID,
    input wire                            S_AXI_RREADY
);
    
    wire [AXI_DATA_WIDTH-1 : 0] dout_out_from_bram;
    assign S_AXI_RDATA = dout_out_from_bram;
    
    
    reg axi_arready;
    assign S_AXI_ARREADY = axi_arready;
      
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if(~S_AXI_ARESETN) begin
            axi_arready <= 0;
        end
        else if(S_AXI_ARVALID & !axi_arready)
            axi_arready <= 1'b1;
        else axi_arready <= 0;
    end
    
    reg axi_rvalid_temp, axi_rvalid_temp1, axi_rvalid;
    assign S_AXI_RVALID = axi_rvalid;
    
    
    reg [AXI_ADDR_WIDTH-1 : 0]   addr_in_to_bram;
    
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if(~S_AXI_ARESETN) begin
            axi_rvalid_temp <= 0;
        end
        else if(S_AXI_ARREADY && S_AXI_ARVALID) begin
            axi_rvalid_temp <= 1;
        end
        else if(S_AXI_RREADY)
            axi_rvalid_temp <= 0;
        else axi_rvalid_temp <= axi_rvalid_temp;
    end
    
    //incorporate 2 cycle read latency for BRAM
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if(~S_AXI_ARESETN) begin
            axi_rvalid_temp1 <= 0;
            axi_rvalid <= 0;
        end
        else begin
            axi_rvalid_temp1 <= axi_rvalid_temp;
            axi_rvalid <= axi_rvalid_temp1;
        end
    end
    
    reg [1:0] axi_rresp;
    assign S_AXI_RRESP = axi_rresp;
    
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) 
            axi_rresp <= 2'b0;
        else begin
            if(S_AXI_ARVALID & (S_AXI_ARADDR > MEM_SIZE))//Memory out of bounds
               axi_rresp <= 2'b01;
            else
               axi_rresp <= 2'b00; 
          end
    end
    
    reg axi_awready;
    assign S_AXI_AWREADY = axi_awready;
      
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if(~S_AXI_ARESETN) begin
            axi_awready <= 0;
        end
        else if(S_AXI_AWVALID & !axi_awready)
            axi_awready <= 1'b1;
        else axi_awready <= 0;
    end
    
    
    
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if(~S_AXI_ARESETN) begin
            addr_in_to_bram <= 0;
        end
        else if(S_AXI_AWVALID && S_AXI_AWREADY)
            addr_in_to_bram <= S_AXI_AWADDR;
        else if (S_AXI_ARVALID && S_AXI_ARREADY)
            addr_in_to_bram <= S_AXI_ARADDR;
        else addr_in_to_bram <= addr_in_to_bram;
    end
    
    reg axi_wready, axi_wvalid_reg;
    reg [AXI_DATA_WIDTH-1 : 0] data_in_to_bram;
    
    assign S_AXI_WREADY = axi_wready;
    
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            axi_wready <= 1'b0;
            axi_wvalid_reg <= 1'b0;
	        data_in_to_bram <= 'b0;
        end else begin
            axi_wvalid_reg <= S_AXI_WVALID;
            axi_wready <=  S_AXI_WVALID & ~axi_wvalid_reg ;
            if(S_AXI_WVALID)
                data_in_to_bram <= S_AXI_WDATA;
            else
                data_in_to_bram <= data_in_to_bram;
            end
    end    
    
    reg axi_bvalid;
    assign S_AXI_BVALID = axi_bvalid;
    
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            axi_bvalid <= 1'b0;
        end
        else begin
            if(S_AXI_WREADY && S_AXI_WVALID)
                axi_bvalid <= 1'b1;
            else if(S_AXI_BREADY) 
                axi_bvalid <= 1'b0;
            else 
                axi_bvalid <= axi_bvalid;
        end
    end
    
    reg [1:0] axi_bresp;
    assign S_AXI_BRESP = axi_bresp;
    
    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) 
            axi_bresp <= 2'b0;
        else begin
            if(S_AXI_AWVALID & (S_AXI_AWADDR > MEM_SIZE))//Memory out of bounds
               axi_bresp <= 2'b01;
            else if(S_AXI_BREADY)
               axi_bresp <= 2'b00; 
          end
    end 
    
    blk_mem_gen_0 bram1 (
      .clka(S_AXI_ACLK),            // input wire clka
      .ena(S_AXI_ARESETN),          // input wire ena
      .wea(S_AXI_WSTRB),            // input wire [3 : 0] wea
      .addra(addr_in_to_bram),      // input wire [3 : 0] addra
      .dina(data_in_to_bram),       // input wire [31 : 0] dina
      .douta(dout_out_from_bram)    // output wire [31 : 0] douta
    );
endmodule