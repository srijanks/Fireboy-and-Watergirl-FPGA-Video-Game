module lever_off_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	input logic lever_flipped,
	output logic [3:0] red, green, blue
);

logic [8:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = (DrawX - (146 - 10)) + (DrawY - (329 - 10)) * 20;

always_comb
    begin
        if(lever_flipped)
            rom_address = ((20 - 1) - (DrawX - (146 - 10))) + (DrawY - (329 - 10)) * 20;
         else
            rom_address = (DrawX - (146 - 10)) + (DrawY - (329 - 10)) * 20;
    end

always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

lever_off_rom lever_off_rom (
	.clka   (negedge_vga_clk),
	.addra (rom_address),
	.douta       (rom_q)
);

lever_off_palette lever_off_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
