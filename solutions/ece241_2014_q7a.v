module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //
    count4 the_counter (.clk(clk), .enable(c_enable), .load(c_load), .d(c_d), .Q(Q));
	assign c_enable = enable;
    assign c_load = reset || (c_enable && Q[3] && Q[2]);
    assign c_d = c_load ? 4'b0001 : 4'b0000;
    // always @ (posedge clk) begin
    // end
endmodule
