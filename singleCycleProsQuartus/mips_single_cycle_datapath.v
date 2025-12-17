// Dosya adi: mips_single_cycle_datapath.v
module mips_single_cycle_datapath(
    input wire clk,
    input wire reset,
    input wire [31:0] instruction, // Disaridan gelen komut
    output wire [31:0] alu_result, // Test icin sonuc ciktisi
    output wire [31:0] write_data  // Test icin register'a yazilan veri
);

    // --- 1. KOMUT PARCALAMA (INSTRUCTION DECODING) ---
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs     = instruction[25:21];
    wire [4:0] rt     = instruction[20:16];
    wire [4:0] rd     = instruction[15:11];
    wire [5:0] funct  = instruction[5:0];
    wire [15:0] imm16 = instruction[15:0];

    // --- 2. KONTROL SINYALLERI (WIRES) ---
    wire reg_dst;
    wire alu_src;
    wire reg_write;
    wire [1:0] alu_op;
    wire [3:0] alu_control_signal;
    wire zero_flag;

    // --- 3. DATAPATH SINYALLERI (WIRES) ---
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] sign_ext_imm;
    wire [4:0]  write_reg;      // Mux sonucunda secilen yazma adresi
    wire [31:0] alu_operand_b;  // Mux sonucunda secilen ALU 2. girisi
    
    // write_data sinyali zaten output olarak tanimli, onu direkt kullanacagiz.
    // Structural mantikta: ALU sonucu -> Write Data olur (LW komutu olmadigi icin).
    assign write_data = alu_result; 

    // ========================================================================
    // MODUL BAGLANTILARI (INSTANTIATION)
    // ========================================================================

    // 1. MAIN CONTROL UNIT
    control_unit ctrl_unit (
        .opcode(opcode),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .alu_op(alu_op)
    );

    // 2. WRITE REGISTER MUX (5-bit)
    // RegDst=0 ise rt (input0), RegDst=1 ise rd (input1) secilir.
    mux2to1_5bit mux_reg_dst (
        .input0(rt),
        .input1(rd),
        .select(reg_dst),
        .out(write_reg)
    );

    // 3. REGISTER FILE
    register_file reg_file (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_reg),   // Mux'tan gelen adres
        .write_data(write_data), // ALU'dan donen sonuc (Loopback)
        .read_data1(read_data1), // ALU A girisine gidecek
        .read_data2(read_data2)  // Mux B'ye gidecek
    );

    // 4. SIGN EXTENDER
    sign_extender sign_ext (
        .immediate_in(imm16),
        .immediate_out(sign_ext_imm)
    );

    // 5. ALU SOURCE MUX (32-bit)
    // ALUSrc=0 ise Register B (input0), ALUSrc=1 ise Immediate (input1) secilir.
    mux2to1_32bit mux_alu_src (
        .input0(read_data2),
        .input1(sign_ext_imm),
        .select(alu_src),
        .out(alu_operand_b)
    );

    // 6. ALU CONTROL UNIT
    alu_control alu_ctrl (
        .alu_op(alu_op),
        .funct(funct),
        .alu_control(alu_control_signal)
    );

    // 7. ALU (ARITHMETIC LOGIC UNIT)
    alu main_alu (
        .a(read_data1),
        .b(alu_operand_b),       // Mux'tan gelen secilmis veri
        .alu_control(alu_control_signal),
        .result(alu_result),     // Output'a ve RegFile'a gider
        .zero(zero_flag)         // Bu odevde bosta kalabilir veya output yapilabilir
    );

endmodule