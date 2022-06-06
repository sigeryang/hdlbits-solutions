module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    wire [7:0] in_old;
    always @ (posedge clk) begin
        pedge <= in & ~in_old;
        in_old <= in;
    end
endmodule
