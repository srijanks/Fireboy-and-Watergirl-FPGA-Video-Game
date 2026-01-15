module fireboy_watergirl_final_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	input logic [9:0] FireX, FireY,
	input logic [9:0] BallX, BallY,
	output logic [3:0] red, green, blue,
	output logic [3:0] red_g, green_g, blue_g
);

logic [14:0] rom_address;
logic [14:0]  rom_address_girl;
logic [4:0] rom_q;
logic [4:0] rom_q_girl;

logic [3:0] palette_red, palette_green, palette_blue;
logic [3:0] palette_red_g, palette_green_g, palette_blue_g;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);
//assign rom_address = (DrawX - (FireX - 26)) + (DrawY - (FireY - 30)) * 160;
//assign rom_address_girl = (DrawX - (BallX - 26)) + (DrawY - ((BallY - 30) + 60)) * 160;

//assign rom_address = (((DrawX - (FireX - 10)) * 53) / 20) +((((DrawY - (FireY - 10)) * 40) / 20) + 0) * 160;

//assign rom_address_girl =(((DrawX - (BallX - 10)) * 53) / 20) +((((DrawY - (BallY + 10)) * 40) / 20) + 40) * 160;

assign rom_address = (((DrawX - (FireX - 10)) * 53) / 26) + ((((DrawY - (FireY - 7)) * 40) / 26) + 0) * 160;

assign rom_address_girl =(((DrawX - (BallX - 10)) * 53) / 26) + ((((DrawY - (BallY - 10)) * 40) / 26) + 60) * 160;




always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
		red_g <= palette_red_g;
		green_g <= palette_green_g;
		blue_g <= palette_blue_g;
		
	end
end

fireboy_watergirl_final_rom fireboy_watergirl_final_rom (
	.clka   (negedge_vga_clk),
	.addra (rom_address),
	.douta       (rom_q),
	.clkb   (negedge_vga_clk),
	.addrb (rom_address_girl),
	.doutb       (rom_q_girl)
);

fireboy_watergirl_final_palette fireboy_watergirl_final_palette (
	.index (rom_q),
	.index2 (rom_q_girl),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue),
	.red_g   (palette_red_g),
    .green_g (palette_green_g),
    .blue_g  (palette_blue_g)
);

endmodule
