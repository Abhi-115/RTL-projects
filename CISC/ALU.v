module ALU(
//    input clk,
//    input reset,
    input [1:0] alu_sel,
    input [15:0] tr_1_data,
    input [15:0] tr_2_data,
    output /*reg*/ [15:0] alu_out,
    output /*reg*/ carry_flag, zero_flag
);
    localparam ADD = 2'b00, SHIFTL = 2'b01, RRC = 2'b10, DECR = 2'b11;
    reg [15:0] alu_out_int;
//    wire carry_flag_int, zero_flag_int; 
    always @(*) begin
        case(alu_sel)
            ADD: alu_out_int = tr_1_data + tr_2_data;
            SHIFTL: alu_out_int = {tr_1_data[14:0],1'b0}; //tr_1_data << 1;
            RRC: begin 
//                    carry_flag = tr_1_data[0];
                    alu_out_int = {tr_1_data[15],tr_1_data[15:1]}; //tr_1_data >> 1;
                 end
            DECR: begin
                    alu_out_int = tr_1_data - 1;
//                    zero_flag = ~(|tr_1_data);
                  end
        endcase
    end
    
    assign carry_flag = (alu_sel == RRC)? tr_1_data[0] : 1'b0;
    assign zero_flag = (alu_sel == DECR)? ~(|alu_out_int): 1'b0;
    
//    always @(posedge clk) begin
//        if(reset) begin
//            alu_out <= 16'b0;
//            carry_flag <= 1'b0;
//            zero_flag <= 1'b0;
//        end
//        else begin 
//            alu_out <= alu_out_int;
//            carry_flag <= carry_flag_int;
//            zero_flag <= zero_flag_int; 
//        end   
//    end

    assign alu_out = alu_out_int;
    
endmodule