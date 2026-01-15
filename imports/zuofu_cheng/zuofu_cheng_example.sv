module zuofu_cheng_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic [9:0] FireX, FireY,
	input logic [1:0] animation_frame,
	input logic blank,
	input logic right_moving,
	input logic left_moving,
	output logic [3:0] red, green, blue
);

logic [10:0] rom_address;
logic [5:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 78) / 640) + (((DrawY * 26) / 480) * 78);
parameter width = 26;
parameter horizontal  = 78;  

logic [9:0] x = left_moving ? (width-1 - (DrawX - (FireX - 13))) : (DrawX - (FireX - 13));
logic [9:0] y = DrawY - (FireY - 12);


assign rom_address = (x + animation_frame*width) + y*horizontal;


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

zuofu_cheng_rom zuofu_cheng_rom (
	.clka   (negedge_vga_clk),
	.addra (rom_address),
	.douta       (rom_q)
);

zuofu_cheng_palette zuofu_cheng_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
