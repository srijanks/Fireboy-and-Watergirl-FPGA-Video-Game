module dl266_rom (
	input logic clock,
	input logic [10:0] address,
	output logic [5:0] q
);

logic [5:0] memory [0:2027] /* synthesis ram_init_file = "./dl266/dl266.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
