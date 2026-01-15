module collision_endgame_palette (
	input logic [0:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:1][11:0] palette = {
	{4'h6, 4'h5, 4'h2},
	{4'h1, 4'h1, 4'h0}
};

assign {red, green, blue} = palette[index];

endmodule
