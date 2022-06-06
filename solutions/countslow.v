module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);
    always @ (posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end
        else begin
            if (slowena) begin
                q <= (q >= 4'd9 ? 4'd0 : q + 4'd1);
            end
            else begin
            	q <= q;
            end
        end
    end
endmodule
