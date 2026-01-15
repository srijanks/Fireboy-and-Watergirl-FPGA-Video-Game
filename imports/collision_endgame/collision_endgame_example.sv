module collision_endgame_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	input logic [9:0] fireLeft, fireRight, fireTop, fireBottom, //NEW
	input logic [9:0] waterLeft, waterRight, waterTop, waterBottom, //NEW
	output logic [2:0] fLeft, fRight, fTop, fBottom, //NEW
    output logic [2:0] wLeft, wRight, wTop, wBottom, //NEW
    output logic [18:0] rom_address_c,
	output logic [2:0] rom_c
);

//logic [18:0] rom_address;
//logic [2:0] rom_q;

//logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
logic [4:0] counter = 5'b0; //NEW
 //NEW
 //NEW

logic [18:0] left, right, top, bottom;
logic [18:0] leftf, rightf, topf, bottomf;
logic [18:0] leftw, rightw, topw, bottomw;
// leftf_1, rightf_1, topf_1, botomf_1, leftf_2, rightf_2, topf_2, botomf_2;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 640) / 640) + (((DrawY * 480) / 480) * 640);

//assign leftf = fireLeft + (fireBottom - 15) * 640;
//assign rightf = fireRight + (fireBottom - 15) * 640;
//assign topf = (fireLeft + 13) + fireTop * 640;
//assign bottomf = (fireLeft + 13) + fireBottom * 640;

//assign leftw = waterLeft + (waterBottom - 25) * 640;
//assign rightw = waterRight + (waterBottom - 25) * 640;
//assign topw = (waterLeft + 25) + waterTop * 640;
//assign bottomw = (waterLeft + 25) + waterBottom * 640;

// ------------------------------- NEW -----------------
logic [9:0] fire_y, water_y, fire_top_y, water_top_y;

// Clamp the Y values to prevent underflow
assign fire_y = (fireBottom < 15) ? 0 : (fireBottom - 15);
assign water_y = (waterBottom < 25) ? 0 : (waterBottom - 25);
// This checks for the underflow (a very large number)
assign fire_top_y = (fireTop > 10'd480) ? 0 : fireTop; 
assign water_top_y = (waterTop > 10'd480) ? 0 : waterTop;

assign leftf = fireLeft + fire_y * 640;
assign rightf = fireRight + fire_y * 640;
assign topf = (fireLeft + 13) + fire_top_y * 640;
assign bottomf = (fireLeft + 13) + fireBottom * 640;

assign leftw = waterLeft + water_y * 640;
assign rightw = waterRight + water_y * 640;
assign topw = (waterLeft + 25) + water_top_y * 640;
assign bottomw = (waterLeft + 25) + waterBottom * 640;

always_ff @ (posedge vga_clk) begin
	
	//NEW
	unique case(counter)
	   5'd0 : rom_address_c <= leftf;
	   5'd1 : ;
	   5'd2 : ;
	   5'd3 : begin
	           fLeft <= rom_c;
	           rom_address_c <= rightf;
	           end
	   5'd4 : ;
	   5'd5 : ;
	   5'd6 : begin
	           fRight <= rom_c;
	           rom_address_c <= topf;
	           end
	   5'd7 : ;
	   5'd8 : ;
	   5'd9 : begin
	           fTop <= rom_c;
	           rom_address_c <= bottomf;
	           end
	   5'd10 : ;
	   5'd11 : ;
	   5'd12 : begin
	           fBottom <= rom_c;
	           rom_address_c <= leftw;
	           end
	   5'd13 : ;
	   5'd14 : ;
	   5'd15 : begin
	           wLeft <= rom_c;
	           rom_address_c <= rightw;
	           end
	   5'd16 : ;
	   5'd17 : ;
	   5'd18 : begin
	           wRight <= rom_c;
	           rom_address_c <= topw;
	           end
	   5'd19 : ;
	   5'd20 : ;
	   5'd21 : begin
	           wTop <= rom_c;
	           rom_address_c <= bottomw;
	           end
	   5'd22 : ;
	   5'd23 : ;
	   5'd24 : begin
	           wBottom <= rom_c;
	           end
	           
	endcase
	
	if(counter == 5'd24) 
	   begin
	       counter <= 5'b0;
	   end
	else 
	   begin
	       counter <= counter + 1;
	   end
end

collision_endgame_rom collision_endgame_rom (
	.clka   (negedge_vga_clk),
	.addra (rom_address_c),
	.douta       (rom_c)
);

//collision_endgame_palette collision_endgame_palette (
//	.index (rom_q),
//	.red   (palette_red),
//	.green (palette_green),
//	.blue  (palette_blue)
//);

endmodule
