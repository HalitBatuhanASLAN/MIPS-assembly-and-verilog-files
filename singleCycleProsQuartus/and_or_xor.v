module and_or_xor(
	input wire [3:0] a,
	input wire [3:0] b,
	input [1:0] sel,
	output [3:0] res
);

wire [3:0] wAnd;
wire [3:0] wOr;
wire [3:0] wXor;

wire [3:0] wMux0;
wire [3:0] wMux1;

genvar i;
generate
	for(i = 0;i<4;i = i +1)begin:loop
		and g0(wAnd[i],a[i],b[i]);
		or g1(wOr[i],a[i],b[i]);
		xor g2(wXor[i],a[i],b[i]);
	end
endgenerate

generate
	for(i = 0;i<4;i = i + 1) begin: l2
		mux2to1_1bit m0(
			.i0(wAnd[i]),
			.i1(wOr[i]),
			.sel(sel[0]),
			.out(wMux0[i])
			);
			
		mux2to1_1bit m1(
			.i0(wMux0[i]),
			.i1(wXor[i]),
			.sel(sel[1]),
			.out(wMux1[i])
			);
	end
endgenerate


endmodule