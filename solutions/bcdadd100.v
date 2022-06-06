module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    // wire [3:0] [99:0] as, bs, sums;
    // wire [99:0] couts;
    // assign as = a;
    // assign bs = b;
    // bcd_fadd bfs[99:0] (.a(as), .b(bs), .cin({couts[98:0], cin}), .cout(couts), .sum(sums));
    // assign cout = couts[99];
    // assign sum = sums;
    genvar i;
    wire [99:0] couts;
    generate
        for (i = 0; i <= 99; i = i + 1) begin : bfadd_generation
            bcd_fadd bf (.a(a[4 * i + 3-:4]), .b(b[4 * i + 3-:4]), .cin(i == 0 ? cin : couts[i - 1]), .cout(couts[i]), .sum(sum[4 * i + 3-:4]));
        end
    endgenerate
    assign cout = couts[99];
endmodule
