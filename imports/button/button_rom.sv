module button_rom (
	input logic clock,
	input logic [8:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:399] /* synthesis ram_init_file = "./button/button.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
