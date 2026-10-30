module mem_addr_reg(
    input clk,
    input resetn, 
    input [4:0] mem_addr,
    input mar_latch,/* mar_en,*/
    output [5:0] mem_addr_to_addr_bus,
    output [4:0] mem_addr_to_data_bus
);
    reg [5:0] mem_addr_latched;
    
//    assign mem_addr_to_addr_bus = mar_en ? mem_addr_latched: 6'b0;
    
    assign mem_addr_to_addr_bus = mem_addr_latched;
    assign mem_addr_to_data_bus = mem_addr_latched[4:0];
     
    always @(posedge clk) begin
        if(~resetn) mem_addr_latched <= 6'b0;
        else begin
            if(mar_latch) mem_addr_latched <= {1'b0,mem_addr};
        end
    end
endmodule