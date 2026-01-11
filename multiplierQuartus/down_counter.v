module down_counter #(
    parameter W = 6 // N=32 için log2(32)+1 = 6 bit yeterli
)(
    input  wire clk,
    input  wire rst,
    input  wire load,
    input  wire dec,
    input  wire [W-1:0] init_val,
    output wire is_zero,
    output reg  [W-1:0] value
);

    assign is_zero = (value == 0);

    always @(posedge clk) begin
        if (rst) begin
            value <= 0;
        end else if (load) begin
            value <= init_val;
        end else if (dec) begin
            value <= value - 1;
        end
    end

endmodule