module end_screen_half_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:76799] /* synthesis ram_init_file = "./end_screen_half/end_screen_half.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
