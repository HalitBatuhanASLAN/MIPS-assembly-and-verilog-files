module mux2to1_1bit(

	input wire i0,
	input wire i1,
	input wire sel,
	output wire out
);

wire not_sel;
wire a,b;

not u1(not_sel,sel);
and u2(a,i0,not_sel);
and u3(b,i1,sel);
or u4(out,a,b);

endmodule