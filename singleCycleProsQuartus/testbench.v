// Dosya adi: testbench.v
`timescale 1ns / 1ps

module testbench;

    // Inputs (Islemciye giden sinyaller)
    reg clk;
    reg reset;
    reg [31:0] instruction;

    // Outputs (Islemciden gelen sinyaller)
    wire [31:0] alu_result;
    wire [31:0] write_data;

    // 1. ISLEMCIYI CAGIRMA (INSTANTIATION)
    mips_single_cycle_datapath uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .alu_result(alu_result),
        .write_data(write_data)
    );

    // 2. CLOCK URETIMI (Her 5ns'de bir tersine doner -> Periyot 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 3. TEST SENARYOSU
    initial begin
        // --- BASLANGIC ---
        // Konsol ciktisini daha temiz gormek icin
        $display("--------------------------------------------------");
        $display("MIPS Single Cycle Processor - Test Basliyor");
        $display("--------------------------------------------------");

        // Resetle basla
        reset = 1;
        instruction = 32'h00000000; // NOP (Bos komut)
        #10;
        reset = 0;
        $display("Reset tamamlandi.");
        
        // --- TEST 1: ADDI $1, $0, 10 ---
        // Opcode: 001000 (ADDI)
        // rs: 00000 ($0)
        // rt: 00001 ($1)
        // imm: 0000000000001010 (10)
        // Hex: 2001000A
        instruction = 32'b001000_00000_00001_0000000000001010;
        #10; // Bir clock dongusu bekle
        $display("TEST 1 (ADDI): $1 = $0 + 10");
        $display("Beklenen: 10, Sonuclar -> ALU: %d, RegisterWriteData: %d", alu_result, write_data);
        $display("--------------------------------------------------");

        // --- TEST 2: ADDI $2, $0, 20 ---
        // Opcode: 001000 (ADDI)
        // rs: 00000 ($0)
        // rt: 00010 ($2)
        // imm: 20
        instruction = 32'b001000_00000_00010_0000000000010100;
        #10;
        $display("TEST 2 (ADDI): $2 = $0 + 20");
        $display("Beklenen: 20, Sonuclar -> ALU: %d, RegisterWriteData: %d", alu_result, write_data);
        $display("--------------------------------------------------");

        // --- TEST 3: ADD $3, $1, $2 ---
        // Hedef: $3 = 10 + 20 = 30 olmali.
        // Opcode: 000000 (R-Type)
        // rs: 00001 ($1)
        // rt: 00010 ($2)
        // rd: 00011 ($3)
        // shamt: 00000
        // funct: 100000 (ADD)
        instruction = 32'b000000_00001_00010_00011_00000_100000;
        #10;
        $display("TEST 3 (ADD): $3 = $1 + $2");
        $display("Beklenen: 30, Sonuclar -> ALU: %d, RegisterWriteData: %d", alu_result, write_data);
        $display("--------------------------------------------------");

        // --- TEST 4: SUB $4, $2, $1 ---
        // Hedef: $4 = 20 - 10 = 10 olmali.
        // funct: 100010 (SUB)
        instruction = 32'b000000_00010_00001_00100_00000_100010;
        #10;
        $display("TEST 4 (SUB): $4 = $2 - $1");
        $display("Beklenen: 10, Sonuclar -> ALU: %d, RegisterWriteData: %d", alu_result, write_data);
        $display("--------------------------------------------------");

        // --- TEST 5: AND $5, $1, $2 ---
        // Hedef: $5 = 10 & 20 -> (01010 & 10100) = 00000 (0)
        // funct: 100100 (AND)
        instruction = 32'b000000_00001_00010_00101_00000_100100;
        #10;
        $display("TEST 5 (AND): $5 = 10 & 20");
        $display("Beklenen: 0,  Sonuclar -> ALU: %d, RegisterWriteData: %d", alu_result, write_data);
        $display("--------------------------------------------------");
        
        // --- TEST 6: ORI $6, $2, 5 ---
        // Hedef: $6 = 20 | 5 -> (10100 | 00101) = 10101 (21)
        // Opcode: 001101 (ORI)
        instruction = 32'b001101_00010_00110_0000000000000101;
        #10;
        $display("TEST 6 (ORI): $6 = 20 | 5");
        $display("Beklenen: 21, Sonuclar -> ALU: %d, RegisterWriteData: %d", alu_result, write_data);
        $display("--------------------------------------------------");

        // --- BITIS ---
        $display("Tum testler tamamlandi.");
        $stop; // Simulasyonu durdur
    end

endmodule