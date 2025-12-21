module alu(
	input wire [31:0] a,
	input wire [31:0] b,
	input wire [4:0] shamt, // shift miktarı
	input wire [4:0] sel, // alu_controlden gelen seçim kodu
	output wire [31:0] y,
	output wire zero // branch için sonuç sıfır mı
);

// --- Alt Modül: Shifter ---
    // Shifter sonucunu 'shift_result' kablosuna alalım.
    // Shifter mode girişi için sel'in son 2 bitini kullanabiliriz (SLL, SRL, SRA uyumluysa)
    // Bizim kodlarımızda: SLL(01000), SRL(01001), SRA(01010). 
    // sel[1:0] -> 00(SLL), 01(SRL), 10(SRA) uyumlu görünüyor.

wire [31:0] shift_result;
shifter shft_inst(
	.a(b), // genelde rt(b) kaydırılır
	.shamt(shamt),
	.mode(sel[1:0]), // 00, 01, 10
	.y(shift_result)
);

// --- Aritmetik ve Mantık İşlemleri ---
    wire [31:0] logic_res;
    wire [31:0] add_sub_res;
    wire        slt_res;
	 
// Toplama/Çıkarma (ADD, SUB)
// sel == 00110 (SUB) ise b'yi çıkar, yoksa topla
assign add_sub_res = (sel == 5'b00110) ? (a-b) : (a+b);

// SLT (Set Less Than) - İşaretli
assign slt_res = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;

// SLTU (Set Less Than Unsigned) - İşaretsiz
wire sltu_res = (a < b) ? 1'b1 : 1'b0;


// --- Sonuç Seçimi (Multiplexer) ---
assign y = (sel == 5'b00000) ? (a & b) : // and
				(sel == 5'b00001) ? (a | b) : // or
				(sel == 5'b00100) ? (a ^ b) : // xor
				(sel == 5'b00101) ? ~(a | b) : //nor
				(sel == 5'b00010) ? add_sub_res: // add
				(sel == 5'b00110) ? add_sub_res: //sub
				(sel == 5'b00111) ? {31'b0, slt_res} : //slt
				(sel == 5'b01011) ? {31'b0, sltu_res} : //sltu
				(sel[4:3] == 2'b01) ? shift_result: //shift işlemleri 01xxx
				32'b0;

// Zero Flag (Sonuç 0 ise 1 olur)
assign zero = (y == 32'b0) ? 1'b1 : 1'b0;

endmodule