module top_module (input x, input y, output z);
    wire [1:0] or0_ops, and0_ops, xor0_ops;
    mod_a a1 (.x(x), .y(y), .z(or0_ops[0]));
    mod_b b1 (.x(x), .y(y), .z(or0_ops[1]));
    mod_a a2 (.x(x), .y(y), .z(and0_ops[0]));
    mod_b b2 (.x(x), .y(y), .z(and0_ops[1]));
    assign xor0_ops[0] = | or0_ops;
    assign xor0_ops[1] = & and0_ops;
    assign z = ^ xor0_ops;
endmodule

module mod_a (input x, input y, output z);
    assign z = (x ^ y) && x;
endmodule

module mod_b (input x, input y, output z);
    assign z = !(x ^ y);
endmodule
