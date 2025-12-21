module pc_reg(
	input wire clk,
	input wire rst,
	input wire [31:0] pc_next,
	output reg [31:0] pc
);

// Kaynak: 
    // Sequential Logic (Sadece saat kenarında veya resetle değişir)

always @(posedge clk or posedge rst) begin
	if(rst) begin
		pc <= 32'b0;
	end else begin
		pc <= pc_next;
	end
end


endmodule