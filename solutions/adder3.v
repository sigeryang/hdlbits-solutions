module top_module( 
    input [2:0] a, b,
    input cin,
    output [2:0] cout,
    output [2:0] sum );
    wire sum0, sum1, sum2;
    fadd f0 (.a(a[0]), .b(b[0]), .cin(cin), .cout(cout[0]), .sum(sum0));
    fadd f1 (.a(a[1]), .b(b[1]), .cin(cout[0]), .cout(cout[1]), .sum(sum1));
    fadd f2 (.a(a[2]), .b(b[2]), .cin(cout[1]), .cout(cout[2]), .sum(sum2));
    assign sum = {sum2, sum1, sum0};
endmodule

module fadd( 
    input a, b, cin,
    output cout, sum );
    assign cout = (a && b) || (cin && (a || b));
    assign sum = a ^ b ^ cin;
endmodule
