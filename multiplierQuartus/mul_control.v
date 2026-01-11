module mul_control (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire cnt_zero,
    input  wire lsb_is_one,
    output reg  ld_operands,
    output reg  clr_product,
    output reg  add_enable,
    output reg  shift_enable,
    output reg  cnt_load,
    output reg  cnt_dec,
    output reg  sel_add_src, // PDF'te istenen port eklendi
    output reg  busy,
    output reg  done
);

    // Durum Kodlaması (State Encoding)
    localparam [1:0] 
        IDLE = 2'b00,
        LOAD = 2'b01,
        RUN  = 2'b10,
        DONE = 2'b11;

    reg [1:0] state, next_state;

    // 1. Always Block: State Register [cite: 148]
    always @(posedge clk) begin
        if (rst) 
            state <= IDLE;
        else 
            state <= next_state;
    end

    // 2. Always Block: Next-State Logic [cite: 149]
    always @* begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start && !busy) next_state = LOAD;
                else        next_state = IDLE;
            end
            LOAD: begin
                next_state = RUN;
            end
            RUN: begin
                if (cnt_zero) next_state = DONE;
                else          next_state = RUN;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // 3. Always Block: Output Logic [cite: 150]
    always @* begin
        // Varsayılan Değerler (Latch önlemek için)
        ld_operands  = 0;
        clr_product  = 0;
        add_enable   = 0;
        shift_enable = 0;
        cnt_load     = 0;
        cnt_dec      = 0;
        sel_add_src  = 0; // Varsayılan 0
        done         = 0;
        busy         = 1; // Genelde meşgul

        case (state)
            IDLE: begin
                busy = 0; // Sadece IDLE'da busy değil
            end
            LOAD: begin
                ld_operands = 1;
                clr_product = 1;
                cnt_load    = 1;
            end
            RUN: begin
                // Algoritma Adımları
                if (lsb_is_one) begin
                    add_enable = 1;
                end
                shift_enable = 1;
                cnt_dec      = 1;
            end
            DONE: begin
                done = 1;
                busy = 0;
            end
        endcase
    end

endmodule