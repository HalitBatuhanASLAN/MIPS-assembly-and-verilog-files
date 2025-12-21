module imem(
    input wire [31:0] addr,
    output wire [31:0] instr
);

    // Simulasyon icin 256 kelimelik (1KB) hafiza
    reg [31:0] RAM [0:255];

    // Word hizali okuma: PC 4 artar ama index 1 artar.
    // Bu yuzden son 2 biti atiyoruz (4'e bolme).
    assign instr = RAM[addr[31:2]];

    initial begin
        // Simulasyon basladiginda programi yuklemek icin:
         $readmemh("prog.hex", RAM);
    end

endmodule