module control_unit(
	input  wire [5:0] op,         // Instruction[31:26]
	input  wire [5:0] funct,      // Instruction[5:0] (JR için gerekli)
	input  wire [4:0] rt,         // Instruction[20:16] (BLTZ/BGEZ için gerekli)
 
	output wire       reg_dst,    // 1: rd, 0: rt
	output wire       alu_src,    // 1: Immediate, 0: Register
	output wire       mem_to_reg, // 1: Memory, 0: ALU Result
	output wire       reg_write,  // Register'a yazma izni
	output wire       mem_read,   // Hafızadan okuma izni
	output wire       mem_write,  // Hafızaya yazma izni
	output wire       branch,     // Branch komutu mu?
	output wire [2:0] branch_type,// 0:BEQ, 1:BNE, 2:BLTZ, 3:BGEZ, 4:BLEZ, 5:BGTZ
	output wire       jump,       // J veya JAL
	output wire       link,       // JAL veya JALR (PC+4 kaydetmek için)
	output wire       jr,         // JR komutu mu?
	output wire [3:0] alu_op      // ALU Control'e giden sinyal
);

// --- Opcode Tanımları (Okunabilirlik için) ---
    localparam R_TYPE = 6'b000000;
    localparam LW     = 6'b100011;
    localparam SW     = 6'b101011;
    localparam BEQ    = 6'b000100;
    localparam BNE    = 6'b000101;
    localparam ADDI   = 6'b001000;
    localparam ADDIU  = 6'b001001; // ADDI ile aynı işlem (overflow trap hariç)
    localparam ANDI   = 6'b001100;
    localparam ORI    = 6'b001101;
    localparam XORI   = 6'b001110;
    localparam SLTI   = 6'b001010;
    localparam SLTIU  = 6'b001011;
    localparam LUI    = 6'b001111; // Load Upper Immediate
    localparam J      = 6'b000010;
    localparam JAL    = 6'b000011;
    localparam REGIMM = 6'b000001; // BLTZ, BGEZ
    localparam BLEZ   = 6'b000110;
    localparam BGTZ   = 6'b000111;


// --- Sinyal Atamaları ---
    
    // R-Type kontrolü: Opcode 0 ise R-Type'dır.
    // Ancak JR (Jump Register) bir R-Type olmasına rağmen yazma yapmaz ve PC'yi değiştirir.
wire is_r_type = (op == R_TYPE);
wire is_jr = is_r_type && (funct == 6'b001000); // JR funct kodu 0x08

assign jr = is_jr;

// RegDst: R-Type işlemlerde (ADD vb.) hedef rd (1), I-Type (ADDI, LW) işlemlerde hedef rt (0)
assign reg_dst = is_r_type;

// ALUSrc: Immediate kullananlarda 1 (LW, SW, ADDI...), Register kullananlarda 0 (R-Type, BEQ)
assign alu_src = (op == LW || op == SW || op == ADDI || op == ADDIU ||
					op == ANDI || op == ORI || op == XORI || op == SLTI ||
					op == SLTIU || op == LUI);

// MemToReg: Hafızadan okunan veri mi (LW), yoksa ALU sonucu mu yazılsın?
assign mem_to_reg = (op == LW);

// RegWrite: Register'a yazılacak mı?
    // R-Type (JR hariç), LW, ADDI, ANDI, JAL vb. yazma yapar. BEQ, SW, J yazmaz.
assign reg_write = (is_r_type && !is_jr) ||
							(op == LW) || (op == ADDI) || (op == ADDIU) ||
							(op == ANDI) || (op == ORI) || (op == XORI) ||
							(op == SLTI) || (op == SLTIU) || (op == LUI) ||
							(op == JAL); // jal $31e yazar

// Hafıza Sinyalleri
assign mem_read = (op == LW);
assign mem_write = (op == SW);

// Branch sinyalleri
assign branch = (op == BEQ || op == BNE || op == BLEZ || op == BGTZ || op == REGIMM);

// Branch Type Encoding
    // 0:BEQ, 1:BNE, 2:BLTZ, 3:BGEZ, 4:BLEZ, 5:BGTZ
assign branch_type = (op == BEQ) ? 3'd0:
							(op == BNE) ? 3'd1 :
							(op == REGIMM && rt == 5'b00000) ? 3'd2 : // BLTZ
							(op == REGIMM && rt == 5'b00001) ? 3'd3 : // BGEZ
							(op == BLEZ) ? 3'd4 :
                     (op == BGTZ) ? 3'd5 : 3'd0;

// JUMP sinyalleri
assign jump = (op == J || op == JAL);
assign link = (op == JAL); // JALR eklenecekse buraya (is_r_type && funct==JALR) eklenmeli


// ALU Op Kodları (ALU Control modülüne gider)
    // 0000: LW/SW (ADD)
    // 0001: BEQ/BNE (SUB)
    // 0010: R-Type (Funct'a bak)
    // 0011: ANDI
    // 0100: ORI
    // 0101: SLTI
    // ... Tasarımcı seçimine bağlı. Biz alu_control'de şu varsayımı yapmıştık:
    // (alu_op == 4'b0010) ? r_type_sel
    // (alu_op == 4'b0000) ? ADD

assign alu_op = (is_r_type)   ? 4'b0010 :
                    (op == LW || op == SW || op == ADDI || op == ADDIU) ? 4'b0000 : 
                    (op == BEQ || op == BNE || op == BLEZ || op == BGTZ || op == REGIMM) ? 4'b0001 : // Karşılaştırma için çıkarma
                    (op == ANDI)  ? 4'b0011 :
                    (op == ORI)   ? 4'b0100 :
                    (op == SLTI)  ? 4'b0101 :
                    (op == LUI)   ? 4'b0110 : // ALU'da LUI işlemi tanımlı değilse Shift ile yapılabilir ama genelde ayrıdır
                    4'b0000; // Varsayılan

endmodule