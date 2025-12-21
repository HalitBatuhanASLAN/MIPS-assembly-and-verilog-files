module shifter(
	input wire [31:0] a,
	input wire [4:0] shamt, // aydırma miktarı (Shift Amount)
	input wire [1:0] mode, //00:SLL, 01:SRL, 10:SRA
	output wire [31:0] y

);

// Verilog'da ">>>" operatörü sadece veri "signed" ise aritmetik kaydırır.
    // Bu yüzden $signed(a) diyerek derleyiciye işaretli olduğunu belirtiyoruz.

assign y = (mode == 2'b00) ? (a << shamt): // SLL
				(mode == 2'b01) ? (a >> shamt) : // SRL
				(mode == 2'b10) ? ($signed(a) >>> shamt) : //SRA -> sayının solunu sıfırla değil, MSB ne ise onunla doldurur yani sayının işareti değişmemiş olur
				32'b0;
endmodule