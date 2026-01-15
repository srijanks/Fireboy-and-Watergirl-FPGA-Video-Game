module backfinal_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	output logic [3:0] red, green, blue
);

logic [16:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
assign rom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);

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

backfinal_rom backfinal_rom (
	.clka   (negedge_vga_clk),
	.addra (rom_address),
	.douta       (rom_q)
);

backfinal_palette backfinal_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule





//module backfinal_example (
//	input logic vga_clk,
//	input logic [9:0] DrawX, DrawY,
//	input logic blank,
//	output logic [2:0] red, green, blue

//);

//logic [18:0] rom_address;
//logic [2:0] rom_q;

//logic [3:0] palette_red, palette_green, palette_blue;

//logic negedge_vga_clk;

////logic [3:0] counter = 4'b0; //NEW
////logic [18:0] rom_address_c; //NEW
//// //NEW

////logic [18:0] left, right, top, bottom;

//// read from ROM on negedge, set pixel on posedge
//assign negedge_vga_clk = ~vga_clk;

//// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
//// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 640) / 640) + (((DrawY * 480) / 480) * 640);

////assign leftf = fireLeft + (fireBottom - 15) * 640;
////assign rightf = fireRight + (fireBottom - 15) * 640;
////assign topf = (fireLeft + 13) + fireTop * 640;
////assign bottomf = (fireLeft + 13) + fireBottom * 640;

////assign leftw = waterLeft + (waterBottom - 25) * 640;
////assign rightw = waterRight + (waterBottom - 25) * 640;
////assign topw = (waterLeft + 25) + waterTop * 640;
////assign bottomw = (waterLeft + 25) + waterBottom * 640;



//always_ff @ (posedge vga_clk) begin
//	red <= 4'h0;
//	green <= 4'h0;
//	blue <= 4'h0;

//	if (blank) begin
//		red <= palette_red;
//		green <= palette_green;
//		blue <= palette_blue;
//	end
	
////	//NEW
////	unique case(counter)
////	   4'd0 : rom_address_c <= leftf;
////	   4'd1 : begin
////	           fLeft <= rom_c;
////	           rom_address_c <= rightf;
////	           end
////	   4'd2 : begin
////	           fRight <= rom_c;
////	           rom_address_c <= topf;
////	           end
////	   4'd3 : begin
////	           fTop <= rom_c;
////	           rom_address_c <= bottomf;
////	           end
////	   4'd4 : begin
////	           fBottom <= rom_c;
////	           rom_address_c <= leftw;
////	           end
////	   4'd5 : begin
////	           wLeft <= rom_c;
////	           rom_address_c <= rightw;
////	           end
////	   4'd6 : begin
////	           wRight <= rom_c;
////	           rom_address_c <= topw;
////	           end
////	   4'd7 : begin
////	           wTop <= rom_c;
////	           rom_address_c <= bottomw;
////	           end
////	   4'd8 : begin
////	           wBottom <= rom_c;
////	           end
////	endcase
	
////	if(counter == 4'd8) 
////	   begin
////	       counter <= 4'b0;
////	   end
////	else 
////	   begin
////	       counter <= counter + 1;
////	   end
//end

//backfinal_rom backfinal_rom (
//	.clka   (negedge_vga_clk),
//	.addra (rom_address),
//	.douta       (rom_q)
	
//);



//backfinal_palette backfinal_palette (
//	.index (rom_q),
//	.red   (palette_red),
//	.green (palette_green),
//	.blue  (palette_blue)
//);


//endmodule
