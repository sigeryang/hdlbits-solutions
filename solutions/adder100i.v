module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    // fadd fs[99:0] (.a(a), .b(b), .cin({cout[98:0], cin}), .cout(cout), .sum(sum));
    genvar i;
    generate
        for (i = 0; i <= 99; i = i + 1) begin : fadd_generation
            fadd f (.a(a[i]), .b(b[i]), .cin(i == 0 ? cin : cout[i - 1]), .cout(cout[i]), .sum(sum[i]));
        end
    endgenerate
endmodule

module fadd( 
    input a, b, cin,
    output cout, sum );
    assign cout = (a && b) || (cin && (a || b));
    assign sum = a ^ b ^ cin;
endmodule