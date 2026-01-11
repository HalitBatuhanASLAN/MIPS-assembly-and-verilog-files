module seq_multiplier #(
    parameter N = 32
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire [N-1:0] multiplicand,
    input  wire [N-1:0] multiplier,
    output wire [2*N-1:0] product,
    output wire busy,
    output wire done
);

    // Modüller arası bağlantı kabloları
    wire ld_operands;
    wire clr_product;
    wire add_enable;
    wire shift_enable;
    wire cnt_load;
    wire cnt_dec;
    wire sel_add_src; // Yeni eklenen kablo
    wire cnt_zero;
    wire lsb_is_one;

    // Control Unit Instantiation [cite: 124]
    mul_control ctrl_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .cnt_zero(cnt_zero),
        .lsb_is_one(lsb_is_one),
        .ld_operands(ld_operands),
        .clr_product(clr_product),
        .add_enable(add_enable),
        .shift_enable(shift_enable),
        .cnt_load(cnt_load),
        .cnt_dec(cnt_dec),
        .sel_add_src(sel_add_src),
        .busy(busy),
        .done(done)
    );

    // Datapath Instantiation [cite: 82]
    mul_datapath #(.N(N)) dp_inst (
        .clk(clk),
        .rst(rst),
        .ld_operands(ld_operands),
        .clr_product(clr_product),
        .add_enable(add_enable),
        .shift_enable(shift_enable),
        .cnt_load(cnt_load),
        .cnt_dec(cnt_dec),
        .sel_add_src(sel_add_src),
        .cnt_zero(cnt_zero),
        .lsb_is_one(lsb_is_one),
        .multiplicand_in(multiplicand),
        .multiplier_in(multiplier),
        .product_out(product)
    );

endmodule