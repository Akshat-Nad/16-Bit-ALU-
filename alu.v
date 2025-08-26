module alu64 (
    input clk,                        
    input [63:0] A, B,
    input [3:0] op,
    output reg [63:0] Y,
    output reg ZF,
    output reg SF,
    output reg CF,
    output reg OF
);

    reg [63:0] add_res, sub_res, mul_res;
    reg c_add, c_sub;
    reg o_add, o_sub;

    always @(posedge clk) begin
        Y = 64'd0;
        CF = 0;
        OF = 0;
        {c_add, add_res} = A + B;
        {c_sub, sub_res} = A - B;
        mul_res = A * B;

        o_add = (~A[63] & ~B[63] & add_res[63]) | (A[63] & B[63] & ~add_res[63]);
        o_sub = (~A[63] & B[63] & sub_res[63]) | (A[63] & ~B[63] & ~sub_res[63]);

        case (op)
            4'b0000: begin Y = add_res; CF = c_add; OF = o_add; end
            4'b0001: begin Y = sub_res; CF = c_sub; OF = o_sub; end
            4'b0010: Y = mul_res;
            4'b0011: Y = A & B;
            4'b0100: Y = A | B;
            4'b0101: Y = A ^ B;
            4'b0110: Y = ~(A | B);
            4'b0111: Y = ~A;
            4'b1000: Y = ~(A & B);
            4'b1001: Y = ~(A ^ B);
            4'b1010: Y = A << B[5:0];
            4'b1011: Y = A >> B[5:0];
            4'b1100: Y = $signed(A) >>> B[5:0];
            4'b1101: begin Y = A + 64'd1; CF = (Y < A); OF = (A[63]==0 && Y[63]==1); end
            4'b1110: begin Y = A - 64'd1; CF = (A==0); OF = (A[63]==1 && Y[63]==0); end
            4'b1111: Y = A;
            default: Y = 64'd0;
        endcase
        ZF = (Y == 64'd0);
        SF = Y[63];
    end
endmodule
