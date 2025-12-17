module full_adder_1bit(

	input wire a,
	input wire b,
	input wire cin,
	output wire sum,
	output wire cout
);


wire aXORb;
wire a_and_b;
wire cin_and_aXORb;

//sum
xor g1(aXORb,a,b);
xor g2(sum,cin,aXORb);

//carry out
and g3(a_and_b,a,b);
and g4(cin_and_aXORb,cin,aXORb);
or g5(cout,cin_and_aXORb,a_and_b);

endmodule