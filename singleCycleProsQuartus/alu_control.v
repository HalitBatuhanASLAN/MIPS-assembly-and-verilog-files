module alu_control(
    input wire [1:0] alu_op,      // Main Control Unit'ten gelir
    input wire [5:0] funct,       // Instruction [5:0]
    output wire [3:0] alu_control // ALU'ya giden kontrol sinyali
);

    // --- 1. ALU Opcode Decoding ---
    wire not_op1, not_op0;
    wire op_addi, op_slti, op_rtype, op_logic_imm;

    not (not_op1, alu_op[1]);
    not (not_op0, alu_op[0]);

    and (op_addi, not_op1, not_op0);        // 00: ADDI
    and (op_slti, not_op1, alu_op[0]);      // 01: SLTI
    and (op_rtype, alu_op[1], not_op0);     // 10: R-Type
    and (op_logic_imm, alu_op[1], alu_op[0]); // 11: ANDI/ORI/XORI

    // --- 2. Funct Bit Inversions ---
    wire not_f2, not_f0;
    
    // Sadece kullanılan bitlerin tersini alıyoruz
    not (not_f2, funct[2]);
    not (not_f0, funct[0]);

    // --- 3. ALU Control Signal Generation ---

    // Bit 3: Always 0 (Bu proje kapsaminda 4. bit kullanilmiyor)
    assign alu_control[3] = 1'b0;

    // Bit 2: SUB (0110) veya SLT (0111)
    // Mantık: (R-Type VE funct[1]=1 VE funct[2]=0) VEYA SLTI
    wire term_not_xor;
    wire r_sub_slt;
    
    and (term_not_xor, funct[1], not_f2);   // XOR'u (funct[2]=1) elemek için
    and (r_sub_slt, op_rtype, term_not_xor);
    or  (alu_control[2], r_sub_slt, op_slti);

    // Bit 1: ADD, SUB, XOR, SLT (Arithmetic or Logic-XOR)
    // Mantık: ADDI VEYA SLTI VEYA (Op_Dependent VE (funct[1]=1 VEYA funct[2]=0))
    wire op_any_func_dependent;
    wire term_funct1_or_notf2;
    wire term_arith_logic;

    or  (op_any_func_dependent, op_rtype, op_logic_imm);
    or  (term_funct1_or_notf2, funct[1], not_f2);
    and (term_arith_logic, op_any_func_dependent, term_funct1_or_notf2);
    
    or  (alu_control[1], op_addi, op_slti, term_arith_logic);

    // Bit 0: OR, XOR, SLT
    // Mantık: SLTI VEYA (Op_Dependent VE (funct[0] VEYA (funct[1] VE (funct[2] VEYA funct[3]))))
    wire f2_or_f3;
    wire f1_and_others;
    wire term_bit0_funct;
    wire term_bit0_final;

    or  (f2_or_f3, funct[2], funct[3]);
    and (f1_and_others, funct[1], f2_or_f3);
    or  (term_bit0_funct, funct[0], f1_and_others);
    and (term_bit0_final, op_any_func_dependent, term_bit0_funct);

    or  (alu_control[0], op_slti, term_bit0_final);

endmodule
