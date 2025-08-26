module alu64_tb;

    // Inputs
    reg clk
    reg [63:0] a, b;
    reg [3:0] sel;

    // Outputs
    wire [63:0] result;
    wire zero_flag, sign_flag, carry_flag, overflow_flag;

    // Instantiate the ALU
    alu64 uut (
	.clk(clk),        
	.a(a),
        .b(b),
        .sel(sel),
        .result(result),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag)
    );
    initial clk = 0;
always #5 clk = ~clk

    // Task to display results
    task display_output;
        begin
            $display("ALU_OP = %b | A = %d | B = %d | Result = %d | Zero = %b | Sign = %b | Carry = %b | Overflow = %b", 
                     sel, a, b, result, zero_flag, sign_flag, carry_flag, overflow_flag);
        end
    endtask

    initial begin
        $display("Starting ALU Testbench");

        // ADD
        a = 64'd20; b = 64'd30; sel = 4'b0000; #10; display_output();

        // SUB
        a = 64'd50; b = 64'd20; sel = 4'b0001; #10; display_output();

        // MUL
        a = 64'd7; b = 64'd6; sel = 4'b0010; #10; display_output();

        // AND
        a = 64'hFF00FF00FF00FF00; b = 64'h0F0F0F0F0F0F0F0F; sel= 4'b0011; #10; display_output();

        // OR
        sel = 4'b0100; #10; display_output();

        // XOR
        sel = 4'b0101; #10; display_output();

        // NOR
        sel = 4'b0110; #10; display_output();

        // NOT
        sel = 4'b0111; #10; display_output();

        // NAND
        sel = 4'b1000; #10; display_output();

        // XNOR
        sel = 4'b1001; #10; display_output();

        // SLL (Logical Left Shift)
        a = 64'd2; b = 64'd2; sel = 4'b1010; #10; display_output();

        // SRL (Logical Right Shift)
        a = 64'd16; b = 64'd2; sel = 4'b1011; #10; display_output();

        // SRA (Arithmetic Right Shift)
        a = -64'sd16; b = 64'd2; sel = 4'b1100; #10; display_output();

        // INC
        a = 64'd99; sel = 4'b1101; #10; display_output();

        // DEC
        a = 64'd1; sel = 4'b1110; #10; display_output();

        // PASS A
        a = 64'd1234; sel = 4'b1111; #10; display_output();

        // Zero result case
        a = 64'd10; b = 64'd10; sel = 4'b0001; #10; display_output(); // SUB resulting in zero

        // Negative result case
        a = 64'd10; b = 64'd20; sel = 4'b0001; #10; display_output(); // SUB negative

        $display("Testbench Completed");
        $finish;
    end

endmodule
