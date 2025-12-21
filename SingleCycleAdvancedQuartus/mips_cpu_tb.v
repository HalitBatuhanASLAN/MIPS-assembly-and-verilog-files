`timescale 1ns/1ps

module mips_cpu_tb;

    // Sinyaller
    reg clk;
    reg rst;
    wire [31:0] dbg_pc;
    wire [31:0] dbg_instr;

    // İşlemciyi (DUT: Device Under Test) çağır
    mips_cpu dut (
        .clk(clk),
        .rst(rst),
        .dbg_pc(dbg_pc),
        .dbg_instr(dbg_instr)
    );

    // Saat Sinyali (Clock) Üretimi
    // Her 5ns'de bir terslenir -> 10ns periyot
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Senaryosu
    initial begin
        // 1. Başlangıç ve Reset
        rst = 1;
        #20; // Biraz bekle
        rst = 0; // Reset'i bırak, işlemci çalışmaya başlasın
        
        $display("Simulasyon Basladi...");

        // 2. İşlemcinin komutları yürütmesi için bekle
        // Programımız yaklaşık 8-9 komutluk, 200ns yeterli olur.
        #200;

        // 3. Sonuçları Kontrol Et (Self-Checking)
        // Beklenen: Register 3'te 30 (0x1E) değeri olmalı (10 + 20).
        // DUT modülünün içindeki register file'a erişip kontrol ediyoruz.
        
        if (dut.rf_inst.registers[3] === 32'd30) begin
            $display("TEST 1 (ADD) PASSED: $3 = %d", dut.rf_inst.registers[3]);
        end else begin
            $display("TEST 1 (ADD) FAILED: Beklenen 30, Alinan %d", dut.rf_inst.registers[3]);
        end

        // Beklenen: Register 5'te 1 değeri olmalı (BEQ çalıştıysa sona ulaşıp 1 yazar)
        if (dut.rf_inst.registers[5] === 32'd1) begin
            $display("TEST 2 (BRANCH) PASSED: Kod basariyla sona ulasti.");
        end else begin
            $display("TEST 2 (BRANCH) FAILED: Branch calismadi veya yanlis yere gitti.");
        end

        $display("Simulasyon Tamamlandi.");
        $stop;
    end

endmodule