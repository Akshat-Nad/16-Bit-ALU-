`timescale 1ns/1ps

module tb_alu64;
    reg clk;
    reg [63:0] A, B;
    reg [3:0] op;
    wire [63:0] Y;
    wire ZF, SF, CF, OF;

    alu64 uut (.clk(clk), .A(A), .B(B), .op(op), .Y(Y), .ZF(ZF), .SF(SF), .CF(CF), .OF(OF));
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        A = 64'd10; B = 64'd5; op = 4'b0000; // ADD
        #10 op = 4'b0001;                    // SUB
        #10 op = 4'b0010;                    // MUL
        #10 op = 4'b0011;                    // AND
        #10 op = 4'b0100;                    // OR
        #10 op = 4'b0101;                    // XOR
        #10 op = 4'b0111;                    // NOT
        #10 op = 4'b1111;                    // PASS A
        #20 $finish;
    end
    initial begin
        $display("Time\tOp\tA\tB\tY\tZF\tSF\tCF\tOF");
        $monitor("%0dns\t%b\t%0d\t%0d\t%0d\t%b\t%b\t%b\t%b", $time, op, A, B, Y, ZF, SF, CF, OF);
    end
endmodule
