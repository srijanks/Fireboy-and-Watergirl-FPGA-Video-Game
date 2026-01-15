module fireboy_watergirl_final_palette (
	input logic [4:0] index,
	input logic [4:0] index2,
	output logic [3:0] red, green, blue,
	output logic [3:0] red_g, green_g, blue_g
);

localparam [0:31][11:0] palette = {
	{4'hE, 4'h4, 4'hB},
	{4'h6, 4'h8, 4'h9},
	{4'h7, 4'h3, 4'h2},
	{4'hE, 4'h6, 4'h3},
	{4'h0, 4'h0, 4'h0},
	{4'h7, 4'hD, 4'hF},
	{4'h0, 4'hB, 4'hF},
	{4'h0, 4'h6, 4'h8},
	{4'hA, 4'h3, 4'h1},
	{4'hF, 4'h0, 4'h0},
	{4'h1, 4'h4, 4'h5},
	{4'h5, 4'h7, 4'h9},
	{4'hA, 4'h3, 4'h8},
	{4'h5, 4'h1, 4'h0},
	{4'hF, 4'h7, 4'h5},
	{4'h7, 4'h2, 4'h6},
	{4'h7, 4'h8, 4'hA},
	{4'hC, 4'h5, 4'h2},
	{4'h4, 4'h1, 4'h3},
	{4'hC, 4'h4, 4'hA},
	{4'h2, 4'h0, 4'h1},
	{4'h0, 4'h9, 4'hD},
	{4'h0, 4'h8, 4'hA},
	{4'hC, 4'h0, 4'h0},
	{4'h4, 4'hC, 4'hE},
	{4'h4, 4'h6, 4'h8},
	{4'hB, 4'h7, 4'hB},
	{4'hF, 4'h3, 4'h0},
	{4'h0, 4'h2, 4'h2},
	{4'h9, 4'h0, 4'h0},
	{4'h7, 4'hA, 4'hB},
	{4'h8, 4'h2, 4'h0}
};

assign {red, green, blue} = palette[index];
assign {red_g, green_g, blue_g} = palette[index2];

endmodule
