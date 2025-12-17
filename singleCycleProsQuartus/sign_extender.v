module sign_extender(
	input wire [15:0] immediate_in, // 16-bit immediate from instruction
	output wire [31:0] immediate_out // 32-bit sign-extended value
);

assign immediate_out[15:0] = immediate_in[15:0];

genvar i;
generate
	for(i = 16;i<32;i = i + 1) begin:sExt
		assign immediate_out[i] = immediate_in[15];
	end
endgenerate

endmodule