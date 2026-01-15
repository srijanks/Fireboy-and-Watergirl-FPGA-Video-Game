module fireboy_watergirl_final_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:19199] /* synthesis ram_init_file = "./fireboy_watergirl_final/fireboy_watergirl_final.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
