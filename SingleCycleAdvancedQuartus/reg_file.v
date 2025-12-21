module reg_file(
	input wire clk,
	input wire rst,
	input wire we, // write enable
	input wire [4:0] ra1, // read adress 1
	input wire [4:0] ra2, // read adress 2
	input wire [4:0] wa, // write adress
	input wire [31:0] wd, // write data
	output wire [31:0] rd1, // read data 1
	output wire [31:0] rd2 // read data 2
);

reg [31:0] registers [31:0];
integer i;

// Asenkron Okuma (Adres değişince veri hemen gelir)
    // Register 0 her zaman 0 okunmalıdır.

assign rd1 = (ra1 == 5'b0) ? 32'b0: registers[ra1];
assign rd2 = (ra2 == 5'b0) ? 32'b0: registers[ra2];

// Senkron Yazma (Saat vuruşuyla)
always @(posedge clk or posedge rst) begin
	if(rst) begin
		// Reset anında tüm registerları temizle (Simülasyon için iyidir)
		for(i = 0;i< 32;i = i +1) begin
			registers[i] <= 32'b0;
		end
	end else begin
		// Eğer yazma aktifse VE yazılacak adres 0 değilse yaz
		if(we && (wa != 5'b0)) begin
			registers[wa] <= wd;
		end
	end
end


endmodule