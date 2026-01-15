module end_screen_final_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:19199] /* synthesis ram_init_file = "./end_screen_final/end_screen_final.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
