module imm_extender(
	input wire [15:0] imm,
	input wire sign,
	output wire [31:0] imm_ext
);

	assign imm_ext = (sign) ? {{16{imm[15]}},imm} : {16'b0, imm};

endmodule