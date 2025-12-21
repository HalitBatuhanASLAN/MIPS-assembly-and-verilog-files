module dmem(
	input wire clk,
	input wire mem_write,
	input wire mem_read, 
	input wire [31:0] addr,
	input wire [31:0] wd, //write data
	output wire [31:0] rd // read data
);


// 256 kelimelik veri hafızası
reg [31:0] RAM [0:255];

// Okuma (Word aligned)
    // mem_read sinyaline bakabiliriz veya sürekli okuyabiliriz. 
    // Basitlik için sürekli okuma (Single Cycle'da sorun olmaz).
assign rd = RAM[addr[31:2]];

// yazma
always @(posedge clk) begin
	if(mem_write) begin
		RAM[addr[31:2]] <= wd;
	end
end

endmodule