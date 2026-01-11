module mul_datapath #(
    parameter N = 32
)(
    input  wire clk,
    input  wire rst,
    // Control Signals [cite: 96-105]
    input  wire ld_operands,
    input  wire clr_product,
    input  wire add_enable,
    input  wire shift_enable,
    input  wire cnt_load,
    input  wire cnt_dec,
    input  wire sel_add_src, // PDF port listesinde var
    // Status Signals [cite: 107-111]
    output wire cnt_zero,
    output wire lsb_is_one,
    // Data Interfaces [cite: 114-119]
    input  wire [N-1:0] multiplicand_in,
    input  wire [N-1:0] multiplier_in,
    output wire [2*N-1:0] product_out
);

    // İç Registerlar
    reg [2*N-1:0] mcand_reg; // Kaydırılacak Çarpılan
    reg [N-1:0]   mplier_reg; // Kaydırılacak Çarpan
    reg [2*N-1:0] prod_reg;   // Sonuç (Accumulator)

    // Adder ve Counter bağlantı kabloları
    wire [2*N-1:0] sum_result;
    wire [5:0]     cnt_value; // Counter değeri (Debugging için tutulabilir)
    
    // Çıkış Atamaları
    assign product_out = prod_reg;
    assign lsb_is_one  = mplier_reg[0];

    // --- 1. Submodule: Adder (Toplayıcı) ---
    // PDF'te verilen add2N modülünü kullanıyoruz [cite: 43, 171]
    add2N #(.N(N)) adder_inst (
        .a(prod_reg),
        .b(mcand_reg),
        .y(sum_result)
    );

    // --- 2. Submodule: Counter (Sayaç) ---
    // PDF'te verilen down_counter modülünü kullanıyoruz [cite: 45, 152]
    // N=32 için 6 bit genişlik (W=6) yeterli. init_val = N (32)
    down_counter #(.W(6)) counter_inst (
        .clk(clk),
        .rst(rst),
        .load(cnt_load),
        .dec(cnt_dec),
        .init_val(6'd32), // Parametrik olması için N kullanılabilir ama W=6 sabitse 32 uygundur.
        .is_zero(cnt_zero),
        .value(cnt_value)
    );

    // --- 3. Sequential Logic (Register Yönetimi) ---
    always @(posedge clk) begin
        if (rst) begin
            mcand_reg  <= 0;
            mplier_reg <= 0;
            prod_reg   <= 0;
        end else begin
            // Yükleme
            if (ld_operands) begin
                mcand_reg  <= { {N{1'b0}}, multiplicand_in }; // Zero padding
                mplier_reg <= multiplier_in;
            end

            // Temizleme
            if (clr_product) begin
                prod_reg <= 0;
            end

            // Toplama (Accumulate)
            if (add_enable) begin
                // add2N modülünden gelen sonucu kaydet
                prod_reg <= sum_result; 
            end

            // Kaydırma (Shift) [cite: 44]
            if (shift_enable) begin
                mcand_reg  <= mcand_reg << 1;
                mplier_reg <= mplier_reg >> 1;
            end
        end
    end

endmodule