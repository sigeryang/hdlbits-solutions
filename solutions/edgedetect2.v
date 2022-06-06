module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);
    wire [7:0] in_old;
    always @ (posedge clk) begin
        anyedge <= in ^ in_old;
        in_old <= in;
    end
endmodule
