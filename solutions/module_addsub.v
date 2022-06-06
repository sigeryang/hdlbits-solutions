module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire carry0;
    wire neg_b;
    wire [15:0] sum0, sum1;
    add16 add0(.a(a[15:0]), .b(b[15:0] ^ {16{sub}}), .cin(sub), .cout(carry0), .sum(sum0));
    add16 add1(.a(a[31:16]), .b(b[31:16] ^ {16{sub}}), .cin(carry0), .sum(sum1));
    assign sum = {sum1, sum0};
endmodule
