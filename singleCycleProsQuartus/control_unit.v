module control_unit(
	input wire [5:0] opcode,
	output wire reg_dst, // 0: rt (I-type), 1: rd (R-type)
	output wire alu_src, // 0: register, 1: immediate
	output wire reg_write, // Enable register file write
	output wire [1:0] alu_op
);

wire r_type, addi, andi, ori, xori, slti;
wire [5:0] not_op;

genvar i;
generate
	for(i = 0;i<6;i = i+1) begin: notOp
		not inv(not_op[i],opcode[i]);
	end
endgenerate

and (r_type,not_op[5],not_op[4],not_op[3],not_op[2],not_op[1],not_op[0]);
and (addi,not_op[5],not_op[4],opcode[3],not_op[2],not_op[1],not_op[0]);
and (andi,not_op[5],not_op[4],opcode[3],opcode[2],not_op[1],not_op[0]);
and (ori,not_op[5],not_op[4],opcode[3],opcode[2],not_op[1],opcode[0]);
and (xori,not_op[5],not_op[4],opcode[3],opcode[2],opcode[1],not_op[0]);
and (slti,not_op[5],not_op[4],opcode[3],not_op[2],opcode[1],not_op[0]);

assign reg_dst = r_type;

or (alu_src,addi,andi,ori,xori,slti);
or (reg_write,r_type,addi,andi,ori,xori,slti);

wire andi_ori_xori;
or (andi_ori_xori,andi,ori,xori);

or (alu_op[1],r_type,andi_ori_xori);
or (alu_op[0],slti,andi_ori_xori);

endmodule