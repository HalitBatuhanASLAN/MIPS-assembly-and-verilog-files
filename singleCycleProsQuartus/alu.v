module alu(
	input wire [31:0] a,
	input wire [31:0] b, // Second operand (from rt or immediate)
	input wire [3:0] alu_control, // Operation select
	output wire [31:0] result, // ALU result
	output wire zero // Zero flag (result == 0)
);

wire [31:0] add_res, sub_res, or_res, and_res, xor_res, slt_res;
wire carry_adder, carry_subt;

adder_32bit adder_unit(
	.a(a),
	.b(b),
	.sum(add_res),
	.carry_out(carry_adder)
);

subtractor_32bit subtractor_unit(
	.a(a),
	.b(b),
	.difference(sub_res),
	.borrow_out(carry_subtract)
);

genvar i;
generate
	for(i = 0;i<32;i = i+1) begin: logic_unit
		and g1(and_res[i],a[i],b[i]);
		or	g2(or_res[i],a[i],b[i]);
		xor g3(xor_res[i],a[i],b[i]);
	end
endgenerate

assign slt_res[0] = sub_res[31];
generate
	for(i = 1;i<32;i = i + 1) begin: sltLoop
		assign slt_res[i] = 1'b0;
	end
endgenerate

wire [31:0] mux1_out,mux2_out,mux3_out, mux4_out;

mux2to1_32bit mux1(
	.input0(and_res),
	.input1(or_res),
	.select(alu_control[0]),
	.out(mux1_out)
);

mux2to1_32bit mux2(
	.input0(add_res),
	.input1(xor_res),
	.select(alu_control[0]),
	.out(mux2_out)
);

mux2to1_32bit mux3(
	.input0(mux1_out),
	.input1(mux2_out),
	.select(alu_control[1]),
	.out(mux3_out)
);

mux2to1_32bit mux4(
	.input0(sub_res),
	.input1(slt_res),
	.select(alu_control[0]),
	.out(mux4_out)
);

mux2to1_32bit mux_final(
	.input0(mux3_out),
	.input1(mux4_out),
	.select(alu_control[2]),
	.out(result)
);


wire [31:0] or_chain;
assign or_chain[0] = result[0];

generate
  for (i = 1; i < 32; i = i + 1) begin : zero_loop
		or g_z (or_chain[i], or_chain[i-1], result[i]);
  end
endgenerate

not g_not (zero, or_chain[31]);

endmodule