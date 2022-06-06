module top_module( 
    input [99:0] a, b,
    input cin,
    output cout,
    output [99:0] sum );
    wire [99:0] couts;
    fadd f[99:0] (.a(a), .b(b), .cin({couts[98:0], cin}), .cout(couts), .sum(sum));
    assign cout = couts[99];
endmodule

module fadd(input a, b, cin, output cout, sum);
    assign cout = (a && b) || (cin && (a || b));
    assign sum = a ^ b ^ cin;
endmodule
