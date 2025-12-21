module alu_control(
	input wire [3:0] alu_op,
	input wire [5:0] funct , // R type için komutun son 6 biti
	output wire [4:0] alu_sel // aluya giden komut sinyali
);

// ALU Seçim Kodları (alu_sel) için Kendi Standardımız:
    // 00000: AND
    // 00001: OR
    // 00010: ADD
    // 00100: XOR
    // 00101: NOR
    // 00110: SUB
    // 00111: SLT (Set Less Than)
    // 01000: SLL
    // 01001: SRL
    // 01010: SRA
    // 01011: SLTU (Unsigned comparison)

    // Kombinasyonel mantık (assign ile):
    // R-Type (alu_op bazen 4 bit tanımlanır ama MIPS standardında genelde 2 bittir. 
    // Ancak hocanın şablonunda alu_op 4 bit verilmiş, biz standart R-type'ı "0010" kabul edelim veya
    // hocanın main control tasarımına göre değişebilir. 
    // GENEL KABUL: alu_op[2] biti 1 ise R-type gibi düşünelim.

wire [4:0] r_type_sel;

assign r_type_sel = (funct == 6'h20) ? 5'b00010: // add
							(funct == 6'h21) ? 5'b00010: // addu add ile aynı işlem
							(funct == 6'h22) ? 5'b00110: // sub
							(funct == 6'h23) ? 5'b00110: // subu
							(funct == 6'h24) ? 5'b00000: // and
							(funct == 6'h25) ? 5'b00001: // or
							(funct == 6'h26) ? 5'b00100: // xor
							(funct == 6'h27) ? 5'b00101: // nor
							(funct == 6'h2A) ? 5'b00111: // slt
							(funct == 6'h2B) ? 5'b01011: // sltu
							(funct == 6'h20) ? 5'b01000: // sll
							(funct == 6'h00) ? 5'b01001: // srl
							(funct == 6'h02) ? 5'b00010: // sra
							5'b11111;

// Nihai seçim: alu_op R-type değilse (örneğin LW/SW/BEQ/I-Type) direkt işlemi seç
    // Not: Bu kısım Main Control tasarımımıza göre netleşecek. 
    // Şimdilik standart MIPS varsayımı yapıyoruz:
    // alu_op = 0000 (LW/SW) -> ADD
    // alu_op = 0001 (BEQ)   -> SUB
    // alu_op = 0010 (R-Type)-> r_type_sel kullan
    // alu_op = 0011 (ANDI)  -> AND
    // alu_op = 0100 (ORI)   -> OR
    // alu_op = 0101 (SLTI)  -> SLT

assign alu_sel = (alu_op == 4'b0010) ? r_type_sel: // R-Type ise funct'a bak
						(alu_op == 4'b0000) ? 5'b00010: // LW, SW -> ADD
						(alu_op == 4'b0001) ? 5'b00110: // BEQ, BNE -> SUB
						(alu_op == 4'b0011) ? 5'b00000: // ANDI -> AND
						(alu_op == 4'b0100) ? 5'b00001: // ORI -> OR
						(alu_op == 4'b0101) ? 5'b00111: // SLTI -> SLT
						5'b00010; // Varsayılan ADD
endmodule