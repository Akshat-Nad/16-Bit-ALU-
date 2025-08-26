module alu64 (
    input clk,                        
    input [63:0] a, b,
    input [3:0] sel,
    output reg [63:0] result,
    output reg zero_flag,
    output reg sign_flag,
    output reg carry_flag,
    output reg overflow_flag
);

    reg [63:0] sum, diff, mul;
    reg carry_out_add, carry_out_sub;
    reg overflow_add, overflow_sub;

    always @(posedge clk) begin       
        // Default values
        result = 64'd0;
        carry_flag = 0;
        overflow_flag = 0;

        // Arithmetic helpers
        {carry_out_add, sum} = a + b;
        {carry_out_sub, diff} = a - b;
        mul = a * b;

        // Overflow detection (signed overflow)
        overflow_add = (~a[63] & ~b[63] & sum[63]) | (a[63] & b[63] & ~sum[63]);
        overflow_sub = (~a[63] & b[63] & diff[63]) | (a[63] & ~b[63] & ~diff[63]);

        // ALU operations
        case (sel)
            4'b0000: begin result = sum;  carry_flag = carry_out_add; overflow_flag = overflow_add; end // ADD
            4'b0001: begin result = diff; carry_flag = carry_out_sub; overflow_flag = overflow_sub; end // SUB
            4'b0010: result = mul;                                          // MUL
            4'b0011: result = a & b;                                        // AND
            4'b0100: result = a | b;                                        // OR
            4'b0101: result = a ^ b;                                        // XOR
            4'b0110: result = ~(a | b);                                     // NOR
            4'b0111: result = ~a;                                           // NOT (on A only)
            4'b1000: result = ~(a & b);                                     // NAND
            4'b1001: result = ~(a ^ b);                                     // XNOR
            4'b1010: result = a << b[5:0];                                  // SLL
            4'b1011: result = a >> b[5:0];                                  // SRL
            4'b1100: result = $signed(a) >>> b[5:0];                        // SRA
            4'b1101: begin                                                  // INC (A + 1)
                result = a + 64'd1;
                carry_flag = (result < a);                                  // Unsigned overflow
                overflow_flag = (a[63] == 0 && result[63] == 1);            // Signed overflow
            end
            4'b1110: begin                                                  // DEC (A - 1)
                result = a - 64'd1;
                carry_flag = (a == 0);                                      // Borrow
                overflow_flag = (a[63] == 1 && result[63] == 0);            // Signed overflow
            end
            4'b1111: result = a;                                            // PASS A
            default: result = 64'd0;
        endcase

        // Common flags
        zero_flag = (result == 64'd0);
        sign_flag = result[63];
    end

endmodule
