module pc(
    input clk,
    input rstn,
    input [7:0] pc_next,
    output reg [7:0] pc_present
);
    always @(posedge clk) begin
        if(~rstn) pc_present <= 0;
        else
            pc_present <= pc_next;
    end
endmodule