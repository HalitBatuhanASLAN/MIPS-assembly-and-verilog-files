module adder_32bit(

	input wire [31:0] a,
	input wire [31:0] b,
	output wire [31:0] sum,
	output wire carry_out
);

wire [32:0] carry;

assign carry[0] = 1'b0;

genvar i;

generate
	for(i = 0;i<32;i = i + 1) begin : adder

		full_adder_1bit bit_adder(
			.a(a[i]),
			.b(b[i]),
			.cin(carry[i]),
			.sum(sum[i]),
			.cout(carry[i+1])
		);
	end
endgenerate

assign carry_out = carry[32];

endmodule