module newcollision3_rom (
	input logic clock,
	input logic [18:0] address,
	output logic [0:0] q
);

logic [0:0] memory [0:307199] /* synthesis ram_init_file = "./newcollision3/newcollision3.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
