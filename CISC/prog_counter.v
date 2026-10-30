module prog_counter(
    input clk,
    input resetn,
    input pc_is, pc_latch, //pc_en,
    input [4:0] pc_addr_in,
    output [5:0] pc_addr_out
);
    reg [5:0] pc_addr_int;
    wire [5:0] pc_addr_next;
    wire [4:0] pc_addr_in_selected;
   
    assign pc_addr_next = pc_addr_int + 1;
    assign pc_addr_in_selected = pc_is ? pc_addr_in: pc_addr_next[4:0];
        
    always @(posedge clk) begin
        if(~resetn)
            pc_addr_int <= 6'b0;
        else begin
            if(pc_latch) pc_addr_int <= {1'b0, pc_addr_in_selected};
        end  
    end
    
    //assign pc_addr_out = pc_en ? pc_addr_int : 6'b0;
    assign pc_addr_out = pc_addr_int;
    
endmodule