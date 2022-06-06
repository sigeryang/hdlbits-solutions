module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry0;
    wire [15:0] sum0, sum1_cin0, sum1_cin1;
    add16 add0(.cin(0), .a(a[15:0]), .b(b[15:0]), .sum(sum0), .cout(carry0));
    add16 add1_cin0(.cin(0), .a(a[31:16]), .b(b[31:16]), .sum(sum1_cin0));
    add16 add1_cin1(.cin(1), .a(a[31:16]), .b(b[31:16]), .sum(sum1_cin1));
    assign sum = {carry0 ? sum1_cin1 : sum1_cin0, sum0};
endmodule
