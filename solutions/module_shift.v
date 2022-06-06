module top_module ( input clk, input d, output q );
	wire shift1, shift2;
    my_dff dff1(.clk(clk), .d(d), .q(shift1));
    my_dff dff2(.clk(clk), .d(shift1), .q(shift2));
    my_dff dff3(.clk(clk), .d(shift2), .q(q));
endmodule
