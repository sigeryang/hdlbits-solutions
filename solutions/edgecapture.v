module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    wire [31:0] in_old;
    always @ (posedge clk) begin
        if (reset) begin
        	out <= 32'd0;
        end
        else begin
            out <= out | in_old & ~in;
        end
        in_old <= in;
    end
endmodule
