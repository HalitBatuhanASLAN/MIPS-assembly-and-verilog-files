`timescale 1ns/1ps

module seq_multiplier_tb;

    localparam N = 32;

    reg clk;
    reg rst;
    reg start;
    reg [N-1:0] multiplicand;
    reg [N-1:0] multiplier;

    wire [2*N-1:0] product;
    wire busy;
    wire done;

    reg [2*N-1:0] expected_product;
    integer error_count = 0;

    // Modulu Cagirma (UUT)
    seq_multiplier #(
        .N(N)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .busy(busy),
        .done(done)
    );

    // Saat sinyali
    initial clk = 0;
    always #5 clk = ~clk;

    // Test Senaryoları
    initial begin
        $display("------------------------------------------------");
        $display("TEST BASLIYOR: Sequential Multiplier (N=%0d)", N);
        $display("------------------------------------------------");
        
        rst = 1;
        start = 0;
        multiplicand = 0;
        multiplier = 0;

        // Reset bekle
        repeat (5) @(posedge clk);
        rst = 0;
        @(posedge clk);

        // Test 1: 10 * 5
        run_test(32'd10, 32'd5);

        // Test 2: 12345 * 0
        run_test(32'd12345, 32'd0);

        // Test 3: 999 * 1
        run_test(32'd999, 32'd1);

        // Test 4: Buyuk Sayilar
        run_test(32'hFFFF0000, 32'h0000FFFF);

        // Test 5: Rastgele
        repeat (10) begin
            run_test($random, $random);
        end

        $display("------------------------------------------------");
        if (error_count == 0)
            $display("SONUC: TUM TESTLER BASARIYLA GECTI (PASS)!");
        else
            $display("SONUC: %0d ADET HATA BULUNDU (FAIL)!", error_count);
        $display("------------------------------------------------");
        
        $stop; // Simulasyonu durdur
    end

    // Basitlestirilmis Test Taski (Quartus Dostu)
    task run_test;
        input [N-1:0] in_a;
        input [N-1:0] in_b;
        begin
            @(posedge clk);
            // Mesguliyet bitene kadar bekle
            while (busy) @(posedge clk);
            
            multiplicand = in_a;
            multiplier   = in_b;
            start = 1; 
            @(posedge clk);
            start = 0; 

            // Done sinyali gelene kadar bekle (Basit wait)
            wait(done);
            
            // Sonucu kontrol et
            expected_product = in_a * in_b;
            
            @(posedge clk); 
            
            if (product !== expected_product) begin
                $display("HATA: A=%0d, B=%0d | Beklenen=%0d, Alinan=%0d", 
                         in_a, in_b, expected_product, product);
                error_count = error_count + 1;
            end else begin
                $display("BASARILI: %0d * %0d = %0d", in_a, in_b, product);
            end
        end
    endtask

endmodule