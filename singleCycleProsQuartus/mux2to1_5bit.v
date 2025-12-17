// Dosya adi: mux2to1_5bit.v
module mux2to1_5bit(
    input wire [4:0] input0, // I-Type icin (rt)
    input wire [4:0] input1, // R-Type icin (rd)
    input wire select,       // RegDst sinyali
    output wire [4:0] out
);

    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : mux_loop
            mux2to1_1bit mux_inst (
                .i0(input0[i]),
                .i1(input1[i]),
                .sel(select),
                .out(out[i])
            );
        end
    endgenerate

endmodule