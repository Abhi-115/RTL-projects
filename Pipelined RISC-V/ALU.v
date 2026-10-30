module ALU(
    input [31:0] in1,
    input [31:0] in2,
    input [3:0] ALU_control, 
    input is_unsigned,
    output [31:0] out,
    output zero//, carry
);
    wire [31:0] cout;
    wire set_MSB, set_u_MSB, set_in;
    
    
    //assign carry = cout[31];
    
    genvar i;
    
    assign set_in = is_unsigned ? set_u_MSB : set_MSB;
    
    ALU_1bit alu_1bit_LSB_uut(.a(in1[0]),.b(in2[0]),.cin(ALU_control[2]),.less(set_in),.ALU_cntrl(ALU_control),.cout(cout[0]),.result(out[0]));
    
    generate 
        for(i = 1; i<=30; i = i+1) begin
            ALU_1bit alu_1bit_uut(.a(in1[i]),.b(in2[i]),.cin(cout[i-1]),.less(1'b0),.ALU_cntrl(ALU_control),.cout(cout[i]),.result(out[i]));
        end
    endgenerate
    
    ALU_1bit_MSB alu_1bit_MSB_uut(.a(in1[31]),.b(in2[31]),.cin(cout[30]),.less(1'b0),.ALU_cntrl(ALU_control),.cout(cout[31]),.set(set_MSB),.set_u(set_u_MSB),.overflow(overflow),.result(out[31]));
    
    
    
    assign zero = ~(|out);
    
endmodule