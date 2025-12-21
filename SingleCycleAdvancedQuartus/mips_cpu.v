module mips_cpu (
    input  wire        clk,
    input  wire        rst,
    output wire [31:0] dbg_pc,    // Testbench izlemesi için PC
    output wire [31:0] dbg_instr  // Testbench izlemesi için Instruction
);

    // --- Kablolar (Wires) ---
    wire [31:0] pc, pc_next, pc_plus4;
    wire [31:0] instr;
    wire [31:0] rd1, rd2;       // Register okuma çıkışları
    wire [31:0] result_w;       // Register'a yazılacak nihai veri
    wire [31:0] sign_imm, zero_imm, imm_ext; // Immediate değerler
    wire [31:0] src_a, src_b;   // ALU girişleri
    wire [31:0] alu_result;
    wire [31:0] read_data;      // Data Memory'den okunan veri
    wire [4:0]  write_reg;      // Yazılacak register adresi (rd veya rt)
    wire [31:0] branch_target;  // Branch hedef adresi
    wire [31:0] jump_target;    // Jump hedef adresi

    // Kontrol Sinyalleri
    wire reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write;
    wire branch, jump, link, jr;
    wire [2:0] branch_type;
    wire [3:0] alu_op;
    wire [4:0] alu_sel;
    wire zero_flag; // ALU Zero Flag

    // Debug Çıkışları
    assign dbg_pc = pc;
    assign dbg_instr = instr;

    // ----------------------------------------------------------------
    // 1. Instruction Fetch (Komut Getirme)
    // ----------------------------------------------------------------
    
    pc_reg pcreg_inst (
        .clk(clk),
        .rst(rst),
        .pc_next(pc_next),
        .pc(pc)
    );

    imem imem_inst (
        .addr(pc),
        .instr(instr)
    );

    // PC + 4 Hesaplayıcı
    add32 pc_adder (
        .a(pc),
        .b(32'd4),
        .y(pc_plus4)
    );

    // ----------------------------------------------------------------
    // 2. Decode & Control (Çözme ve Kontrol)
    // ----------------------------------------------------------------

    control_unit ctrl_inst (
        .op(instr[31:26]),
        .funct(instr[5:0]),
        .rt(instr[20:16]),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .branch_type(branch_type),
        .jump(jump),
        .link(link),
        .jr(jr),
        .alu_op(alu_op)
    );

    // Yazılacak Register Seçimi (MUX):
    // reg_dst=1 ise 'rd' (instr[15:11]), reg_dst=0 ise 'rt' (instr[20:16])
    // Eğer 'link' (JAL) varsa $31 seçilir.
    wire [4:0] write_reg_tmp;
    assign write_reg_tmp = (reg_dst) ? instr[15:11] : instr[20:16];
    assign write_reg = (link) ? 5'd31 : write_reg_tmp;

    // Register File
    reg_file rf_inst (
        .clk(clk),
        .rst(rst),
        .we(reg_write),
        .ra1(instr[25:21]), // rs
        .ra2(instr[20:16]), // rt
        .wa(write_reg),
        .wd(result_w),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Immediate Genişletme (Sign Extend)
    imm_extender ext_inst (
        .imm(instr[15:0]),
        .sign(1'b1), // Aritmetik işlemler genelde sign-extend ister
        .imm_ext(sign_imm)
    );
    // Logic işlemler (ANDI, ORI) için Zero Extend gerekebilir, 
    // ama basitlik için ALU mux'ında veya extender içinde halledilebilir.
    // Biz burada genel kullanım için sign_imm'i ana immediate olarak alalım.
    assign imm_ext = sign_imm;

    // ----------------------------------------------------------------
    // 3. Execute (Yürütme)
    // ----------------------------------------------------------------

    // ALU Control
    alu_control alu_ctrl_inst (
        .alu_op(alu_op),
        .funct(instr[5:0]),
        .alu_sel(alu_sel)
    );

    // ALU Giriş MUX'ları
    // SrcA genelde rs verisidir (rd1). Shift işlemlerinde "shamt" olabilir.
    // Ancak basit MIPS tasarımında Shifter ALU içindeyse SrcA = rd1'dir.
    assign src_a = rd1;

    // SrcB seçimi: alu_src=1 ise Immediate, alu_src=0 ise Register (rd2)
    assign src_b = (alu_src) ? imm_ext : rd2;

    // ALU
    alu alu_inst (
        .a(src_a),
        .b(src_b),
        .shamt(instr[10:6]), // Shift Amount
        .sel(alu_sel),
        .y(alu_result),
        .zero(zero_flag)
    );

    // ----------------------------------------------------------------
    // 4. Memory (Hafıza)
    // ----------------------------------------------------------------

    dmem dmem_inst (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(alu_result),
        .wd(rd2), // Store işleminde rt verisi yazılır
        .rd(read_data)
    );

    // ----------------------------------------------------------------
    // 5. Write Back (Geri Yazma) & LUI Handling
    // ----------------------------------------------------------------
    
    // LUI (Load Upper Immediate) Özel İşlemi:
    // opcode LUI ise (0x0F), immediate 16 bit sola kaydırılıp yazılır.
    wire is_lui = (instr[31:26] == 6'b001111);
    wire [31:0] lui_result = {instr[15:0], 16'b0};

    // result_w Seçim Mantığı (Büyük MUX):
    // link (JAL) -> PC + 4
    // LUI -> lui_result
    // mem_to_reg -> read_data (Memory'den gelen)
    // Diğer -> alu_result
    assign result_w = (link)       ? pc_plus4 :
                      (is_lui)     ? lui_result :
                      (mem_to_reg) ? read_data : 
                                     alu_result;

    // ----------------------------------------------------------------
    // 6. Branch & Jump Logic (PC Güncelleme)
    // ----------------------------------------------------------------

    // Branch Adres Hesabı: PC+4 + (Imm << 2)
    wire [31:0] branch_offset = {imm_ext[29:0], 2'b00};
    add32 br_adder (
        .a(pc_plus4),
        .b(branch_offset),
        .y(branch_target)
    );

    // Jump Adres Hesabı: {PC+4[31:28], instr[25:0], 00}
    assign jump_target = {pc_plus4[31:28], instr[25:0], 2'b00};

    // Branch Kararı (Branch Decision)
    // branch_type: 0:BEQ, 1:BNE, 2:BLTZ, 3:BGEZ, 4:BLEZ, 5:BGTZ
    // ALU sonuçlarını kontrol edelim. 
    // ALU'dan gelen 'alu_result' R-type olmayan (Branch gibi) komutlarda
    // (rs - rt) veya (rs - 0) işlemini içerir (Control Unit tasarımımıza göre).
    
    // ALU Zero flag = 1 ise (a == b)
    // Negatiflik kontrolü: alu_result[31] (MSB) 1 ise negatiftir.
    
    wire is_equal = zero_flag;
    wire is_neg   = alu_result[31]; // Sonuç negatif (MSB=1)
    wire is_pos   = !is_neg && !is_equal; // Pozitif (>0)
    
    reg take_branch;
    always @(*) begin
        case (branch_type)
            3'd0: take_branch = is_equal;            // BEQ
            3'd1: take_branch = !is_equal;           // BNE
            3'd2: take_branch = is_neg;              // BLTZ
            3'd3: take_branch = !is_neg;             // BGEZ (>=0)
            3'd4: take_branch = is_neg || is_equal;  // BLEZ (<=0)
            3'd5: take_branch = is_pos;              // BGTZ (>0)
            default: take_branch = 1'b0;
        endcase
    end

    // PC_NEXT Seçimi (Priority MUX)
    // 1. JR (Jump Register) -> rs (rd1)
    // 2. Jump (J/JAL) -> jump_target
    // 3. Branch Taken -> branch_target
    // 4. Normal -> PC + 4

    assign pc_next = (jr) ? rd1 :
                     (jump) ? jump_target :
                     (branch && take_branch) ? branch_target :
                     pc_plus4;

endmodule