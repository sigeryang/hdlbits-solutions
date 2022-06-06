module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output [7:0] q 
);
    wire [7:0] shift0, shift1, shift2;
    my_dff8 dff0(.clk(clk), .d(d), .q(shift0));
    my_dff8 dff1(.clk(clk), .d(shift0), .q(shift1));
    my_dff8 dff2(.clk(clk), .d(shift1), .q(shift2));
    always @ (*) begin
        case (sel)
            2'b00: q = d;
            2'b01: q = shift0;
            2'b10: q = shift1;
            2'b11: q = shift2;
        endcase
    end
endmodule
