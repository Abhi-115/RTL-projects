module pc(
    input clk,
    input rstn,
    input [31:0] pc_next,
    input pc_ce,
    output reg [31:0] pc_present
);
    always @(posedge clk) begin
        if(~rstn) pc_present <= 0;
        else if(~pc_ce) pc_present <= pc_present; 
        else    pc_present <= pc_next;
    end
endmodule