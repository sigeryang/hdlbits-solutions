module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire carry;
    wire [15:0] sum1, sum2;
    add16 add1(.cin(0), .a(a[15:0]), .b(b[15:0]), .cout(carry), .sum(sum1));
    add16 add2(.cin(carry), .a(a[31:16]), .b(b[31:16]), .cout(), .sum(sum2));
    assign sum = {sum2, sum1};
endmodule
