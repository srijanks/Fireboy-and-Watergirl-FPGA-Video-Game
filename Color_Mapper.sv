//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
                       input  logic [9:0] FireX, FireY, Fire_size,
                       input  logic [9:0] timerX, timerY, timerX2, timerY2, // new
                       input  logic [9:0] timerX3, timerY3,
                       input  logic [9:0] timerX4, timerY4,
                       input logic [3:0] Red_timer, Green_timer, Blue_timer, Red_timer2, Green_timer2, Blue_timer2,// new
                       input logic [3:0] Red_timer3, Green_timer3, Blue_timer3,
                       input logic [3:0] Red_timer4, Green_timer4, Blue_timer4,
                       input logic [3:0] Red_img, Green_img, Blue_img,
                       input logic [3:0] Red_back, Green_back, Blue_back,
                       input logic [3:0] Red_fire, Green_fire, Blue_fire,
                       input logic [3:0] Red_rd, Green_rd, Blue_rd,
                       input logic [3:0] Red_rd2, Green_rd2, Blue_rd2,
                       input logic [3:0] Red_rd3, Green_rd3, Blue_rd3,
                       input logic [3:0] Red_bd, Green_bd, Blue_bd,
                       input logic [3:0] Red_bd2, Green_bd2, Blue_bd2,
                       input logic [3:0] Red_bd3, Green_bd3, Blue_bd3,
                       input logic [3:0] Red_button, Green_button, Blue_button,
                       input logic [3:0] Red_lever, Green_lever, Blue_lever,
                       input logic [3:0] Red_rod1, Green_rod1, Blue_rod1,
                       input logic [3:0] Red_rod2, Green_rod2, Blue_rod2,
                       input logic [3:0] Red_start, Green_start, Blue_start,
                       input logic [3:0] Red_end, Green_end, Blue_end,
                       input logic vsync,
                       input logic reset,
                       input logic time_out,
                       input logic [7:0] keycode,
                       output logic lever_flipped,
                       output logic button_pressed,
                       output logic game_started,
                       output logic game_won,
                       output logic game_lost,
                       output logic [3:0]  Red, Green, Blue );
                      
    
    logic [1:0] ball_on;
    
    //new 
    logic timer_on;
    logic timer_on2;
    logic timer_on3;
    logic timer_on4;
    logic red_diamond_on;
    logic red_diamond_on2;
    logic red_diamond_on3;
    logic blue_diamond_on;
    logic blue_diamond_on2;
    logic blue_diamond_on3;
    logic button_on;
    logic lever_on;
    logic rod1_on;
    logic rod2_on;
    logic red_diamond_collected; 
    logic red_diamond_collected2; 
    logic red_diamond_collected3; 
    logic blue_diamond_collected;
    logic blue_diamond_collected1;
    logic blue_diamond_collected2;
    logic blue_diamond_collected3;
   // logic [9:0] timer_size;
    
    //assign timer_size = 25; 
    
    // game state--------------------
    
    logic red_lava;
    logic blue_lava;
    logic green_lava;
    logic red_door;
    logic blue_door;
    logic game_end;
    
 // for sprites:
 always_ff @(posedge vsync) 
 begin
         if(reset == 1'b1)
            begin
                red_diamond_collected <= 1'b0;
                red_diamond_collected2 <= 1'b0;
                red_diamond_collected3 <= 1'b0;
                blue_diamond_collected <= 1'b0;
                blue_diamond_collected2 <= 1'b0;
                blue_diamond_collected3 <= 1'b0;
                lever_flipped <= 1'b0;
                button_pressed <= 1'b0;
                game_started <= 1'b0;
                red_lava <= 1'b0;
                blue_lava <= 1'b0;
                green_lava <= 1'b0;
                red_door <= 1'b0;
                blue_door <= 1'b0;
                game_won <= 1'b0;
                game_lost <= 1'b0;
                game_end <= 1'b0;
            end
          else
            begin
                if (!game_started) 
                    begin
                         if (keycode == 8'h28) // Enter key
                                game_started <= 1'b1;
                  end
               else
               begin
                if (!red_diamond_collected)
                    begin
                        if ((FireX >= 338 - 10) && (FireX <= 338 + 10) &&(FireY >= 424 - 10) && (FireY <= 424 + 10))
                            begin
                                red_diamond_collected <= 1;
                            end
                     end
                   if (!red_diamond_collected2)
                    begin
                        if ((FireX >= 176 - 10) && (FireX <= 176 + 10) &&(FireY >= 224 - 10) && (FireY <= 224 + 10))
                            begin
                                red_diamond_collected2 <= 1;
                            end
                     end
                   if (!red_diamond_collected3)
                    begin
                        if ((FireX >= 53 - 10) && (FireX <= 53 + 10) &&(FireY >= 71 - 10) && (FireY <= 71 + 10))
                            begin
                                red_diamond_collected3 <= 1;
                            end
                     end  
                  if (!blue_diamond_collected)
                    begin
                        if ((BallX >= 470 - 10) && (BallX <= 470 + 10) && (BallY >= 424 - 10) && (BallY <= 424 + 10))
                            begin
                                blue_diamond_collected <= 1'b1;
                            end                            
                      end
                   if (!blue_diamond_collected2)
                    begin
                        if ((BallX >= 518 - 10) && (BallX <= 518 + 10) && (BallY >= 160 - 10) && (BallY <= 160 + 10))
                            begin
                                blue_diamond_collected2 <= 1'b1;
                            end                            
                      end
                    if (!blue_diamond_collected3)
                    begin
                        if ((BallX >= 320 - 10) && (BallX <= 320 + 10) && (BallY >= 92 - 10) && (BallY <= 92 + 10))
                            begin
                                blue_diamond_collected3 <= 1'b1;
                            end                            
                      end
                   if (!lever_flipped)
                    begin
                        if (((BallX >= 146 - 10) && (BallX <= 146 + 10) && (BallY >= 329 - 10) && (BallY <= 329 + 10)) || 
                            ((FireX >= 146 - 10) && (FireX <= 146 + 10) &&(FireY >= 329 - 10) && (FireY <= 329 + 10)))
                            begin
                                lever_flipped <= 1'b1;
                            end                            
                      end
                    if (!button_pressed)
                    begin
                        if (((BallX >= 515 - 10) && (BallX <= 515 + 10) && (BallY >= 263 - 10) && (BallY <= 263 + 10)) || 
                            ((FireX >= 515 - 10) && (FireX <= 515 + 10) &&(FireY >= 263 - 10) && (FireY <= 263 + 10)))
                            begin
                                button_pressed <= 1'b1;
                            end                            
                      end
                    if (!red_lava)
                    begin
                        if ((BallX >= 13'h0131) && (BallX <= 13'h0170) && (BallY >= 13'h01C5) && (BallY <= 13'h01CE))
                            begin
                                red_lava <= 1'b1;
                            end                            
                      end
                    if (!blue_lava)
                    begin
                        if ((FireX >= 13'h01AF) && (FireX <= 13'h01FA) && (FireY >= 13'h01C5) && (FireY <= 13'h01CE))
                            begin
                                blue_lava <= 1'b1;
                            end                            
                      end
                   if (!green_lava)
                    begin
                        if (((BallX >= 13'h0191) && (BallX <= 13'h01D6) && (BallY >= 13'h0161) && (BallY <= 13'h0170)) || 
                            ((FireX >= 13'h0191) && (FireX <= 13'h01D6) &&(FireY >= 13'h0161) && (FireY <= 13'h0170)))
                            begin
                                green_lava <= 1'b1;
                            end                            
                      end
                    if (!red_door)
                    begin
                        if ((FireX >= 13'h020C) && (FireX <= 13'h0233) && (FireY >= 13'h0023) && (FireY <= 13'h005F))
                            begin
                                red_door <= 1'b1;
                            end                            
                      end 
                      if (!blue_door)
                    begin
                        if ((BallX >= 13'h0248) && (BallX <= 13'h0263) && (BallY >= 13'h0023) && (BallY <= 13'h005F))
                            begin
                                blue_door <= 1'b1;
                            end                            
                      end
                    if (red_door && blue_door)
                        begin
                         game_won <= 1'b1;
                        end 
                    if (red_lava || blue_lava || green_lava || time_out)
                        begin
                            game_lost <= 1'b1;
                        end
                    if(game_won || game_lost)
                        begin
                            game_end <= 1'b1;
                        end
             end
             end
    end
 
 
 
  
 always_comb
    begin:Timer
       if((DrawX >= timerX) && ( DrawX <= (timerX + 7))
            &&(DrawY >= timerY) && (DrawY <= (timerY + 16)))
            timer_on = 1'b1 ; 
        else
            timer_on = 1'b0; 
          
    end
  always_comb
    begin:Timer2
       if((DrawX >= timerX2) && ( DrawX <= (timerX2 + 7))
            &&(DrawY >= timerY2) && (DrawY <= (timerY2 + 16)))
            timer_on2 = 1'b1 ; 
        else
            timer_on2 = 1'b0; 
          
    end
     always_comb
    begin:Timer3
       if((DrawX >= timerX3) && ( DrawX <= (timerX3 + 7))
            &&(DrawY >= timerY3) && (DrawY <= (timerY3 + 16)))
            timer_on3 = 1'b1 ; 
        else
            timer_on3 = 1'b0; 
          
    end
     always_comb
    begin:Timer4
       if((DrawX >= timerX4) && ( DrawX <= (timerX4 + 7))
            &&(DrawY >= timerY4) && (DrawY <= (timerY4 + 16)))
            timer_on4 = 1'b1 ; 
        else
            timer_on4 = 1'b0; 
          
    end
    
   always_comb
    begin:Sprites
         red_diamond_on = 1'b0;
         red_diamond_on2 = 1'b0;
         red_diamond_on3 = 1'b0;
         blue_diamond_on = 1'b0;
         blue_diamond_on2 = 1'b0;
         blue_diamond_on3 = 1'b0;
         button_on = 1'b0;
         lever_on = 1'b0;
         rod1_on = 1'b0;
         rod2_on = 1'b0;
          if ((DrawX >= 338 - 10) &&(DrawX <= 338 + 10) &&(DrawY >= 424 - 10) && (DrawY <= 424 + 10) && (!red_diamond_collected))
             red_diamond_on = 1'b1;
          if ((DrawX >= 176 - 10) &&(DrawX <= 176 + 10) &&(DrawY >= 224 - 10) && (DrawY <= 224 + 10) && (!red_diamond_collected2))
             red_diamond_on2 = 1'b1;
           if ((DrawX >= 53 - 10) &&(DrawX <= 53 + 10) &&(DrawY >= 71 - 10) && (DrawY <= 71 + 10) && (!red_diamond_collected3))
             red_diamond_on3 = 1'b1;
          if ((DrawX >= 470 - 10) &&(DrawX <= 470 + 10) &&(DrawY >= 424 - 10) && (DrawY <= 424 + 10) && (!blue_diamond_collected))
              blue_diamond_on = 1'b1;
          if ((DrawX >= 518 - 10) &&(DrawX <= 518 + 10) &&(DrawY >= 160 - 10) && (DrawY <= 160 + 10) && (!blue_diamond_collected2))
              blue_diamond_on2 = 1'b1;
           if ((DrawX >= 320 - 10) &&(DrawX <= 320 + 10) &&(DrawY >= 92 - 10) && (DrawY <= 92 + 10) && (!blue_diamond_collected3))
              blue_diamond_on3 = 1'b1;
          if ((DrawX >= 515 - 10) &&(DrawX <= 515 + 10) &&(DrawY >= 263 - 10) && (DrawY <= 263 + 10)) 
              button_on = 1'b1;
          if ((DrawX >= 146 - 10) &&(DrawX <= 146 + 10) &&(DrawY >= 329 - 10) && (DrawY <= 329 + 10)) 
              lever_on = 1'b1;
          if ((DrawX >= 50 - 32) &&(DrawX <= 50 + 32) &&(DrawY >= 263 - 5) && (DrawY <= 263 + 5)) 
              rod1_on = 1'b1;
          if ((DrawX >= 596 - 32) &&(DrawX <= 596 + 32) &&(DrawY >= 215 - 5) && (DrawY <= 215 + 5)) 
              rod2_on = 1'b1;
         
    end
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )
// --------------timer--------------------------
     assign timer_size = 25;
     assign timer_on = 0; 
     input logic [3:0] Red_timer, Green_timer, Blue_timer
     
// always_comb
//    begin:Timer
//       if((DrawX >= timerX - timer_size) && ( DrawX <= timerX + timer_size)
            &&(DrawY >= timerY - timer_size) && (drawY <= timerY + timer_size))
            timer_on = 1'b1 ; 
          
//    end
    
//--------------timer end----------------------- 

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
    assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = Ball_size;
  
    always_comb
    begin:Ball_on_proc
        if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + (Ball_size - 2)))
            ball_on = 2'b01;
        else if ((DrawX >= FireX - (Fire_size - 2)) &&
       (DrawX <= FireX + Fire_size) &&
       (DrawY >= FireY - Fire_size) &&
       (DrawY <= FireY + Fire_size))
            ball_on = 2'b10;
        else 
            ball_on = 2'b0;
     end 
 
 logic [11:0] color1, color2, color3;
 assign color1 = 12'hC3B;
 assign color2 = 12'hD3D;
 assign color3 = 12'hE3D;
 
    always_comb  // {4'hE, 4'h3, 4'hD}
    begin:RGB_Display
         if (!game_started)
            begin
        // Draw Start Screen
                Red = Red_start;
                Green = Green_start;
                Blue = Blue_start;
        end
        else if (game_end)
            begin
                Red = Red_end;
                Green = Green_end;
                Blue = Blue_end;
            end
        else begin
        if ((ball_on == 2'b01)&&!(
       (Red_img == 4'hD && Green_img == 4'h5 && Blue_img == 4'hB) ||
       (Red_img == 4'hE && Green_img == 4'h4 && Blue_img == 4'hB) || 
       (Red_img == 4'hE && Green_img == 4'h4 && Blue_img == 4'hC) || (Red_img == 4'hF && Green_img == 4'h4 && Blue_img == 4'hC)|| (Red_img == 4'hA && Green_img == 4'h3 && Blue_img == 4'h8)|| (Red_img == 4'h7 && Green_img == 4'h2 && Blue_img == 4'h6)|| (Red_img == 4'h6 && Green_img == 4'h2 && Blue_img == 4'h5) )) begin 
            Red = Red_img;
            Green = Green_img;
            Blue = Blue_img;
        end  
        else if ((ball_on == 2'b10)&&!((Red_fire == 4'hE && Green_fire == 4'h4 && Blue_fire == 4'hB) || (Red_fire == 4'hE && Green_fire == 4'h4 && Blue_fire == 4'hC) || (Red_fire == 4'hD && Green_fire == 4'h4 && Blue_fire == 4'hA)|| (Red_fire == 4'hF && Green_fire == 4'h4 && Blue_fire == 4'hC) ||  (Red_fire == 4'h8 && Green_fire == 4'h2 && Blue_fire == 4'h5) ||  (Red_fire == 4'h8 && Green_fire == 4'h2 && Blue_fire == 4'h3) ||(Red_fire == 4'hA && Green_fire == 4'h3 && Blue_fire == 4'h8) || (Red_fire == 4'h7 && Green_fire == 4'h2 && Blue_fire == 4'h6) || (Red_fire == 4'h6 && Green_fire == 4'h2 && Blue_fire == 4'h5) || (Red_fire == 4'hA && Green_fire == 4'h2 && Blue_fire == 4'h6))) begin   
            Red = Red_fire;
            Green = Green_fire;
            Blue = Blue_fire;
        end
        else if(timer_on)
                begin
                    Red = Red_timer;
                    Green = Green_timer;
                    Blue = Blue_timer; 
                end
        else if(timer_on2)
                begin
                    Red = Red_timer2;
                    Green = Green_timer2;
                    Blue = Blue_timer2; 
                end
        else if(timer_on3)
                begin
                    Red = Red_timer3;
                    Green = Green_timer3;
                    Blue = Blue_timer3; 
                end
        else if(timer_on4)
                begin
                    Red = Red_timer4;
                    Green = Green_timer4;
                    Blue = Blue_timer4; 
                end // bug : Red_rd
         else if((red_diamond_on)&&!(Red_rd == 4'hE && Green_rd == 4'h3 && Blue_rd == 4'hD)&&!(Red_rd == 4'hC && Green_rd == 4'h3 && Blue_rd == 4'hB)&&!(Red_rd == 4'h5 && Green_rd == 4'h1 && Blue_rd == 4'h4)&&!(Red_rd == 4'h9 && Green_rd == 4'h2 && Blue_rd == 4'h8))
                begin
                    Red = Red_rd;
                    Green = Green_rd;
                    Blue = Blue_rd; 
                end
         else if((red_diamond_on2)&&!(Red_rd2 == 4'hE && Green_rd2 == 4'h3 && Blue_rd2 == 4'hD)&&!(Red_rd2 == 4'hC && Green_rd2 == 4'h3 && Blue_rd2 == 4'hB)&&!(Red_rd2 == 4'h5 && Green_rd2 == 4'h1 && Blue_rd2 == 4'h4)&&!(Red_rd2 == 4'h9 && Green_rd2 == 4'h2 && Blue_rd2 == 4'h8))
                begin
                    Red = Red_rd2;
                    Green = Green_rd2;
                    Blue = Blue_rd2; 
                end
         else if((red_diamond_on3)&&!(Red_rd3 == 4'hE && Green_rd3 == 4'h3 && Blue_rd3 == 4'hD)&&!(Red_rd3 == 4'hC && Green_rd3 == 4'h3 && Blue_rd3 == 4'hB)&&!(Red_rd3 == 4'h5 && Green_rd3 == 4'h1 && Blue_rd3 == 4'h4)&&!(Red_rd3 == 4'h9 && Green_rd3 == 4'h2 && Blue_rd3 == 4'h8))
                begin
                    Red = Red_rd3;
                    Green = Green_rd3;
                    Blue = Blue_rd3; 
                end
         else if(blue_diamond_on &&!(Red_bd == 4'hE && Green_bd == 4'h3 && Blue_bd == 4'hD) &&!(Red_bd == 4'h8 && Green_bd == 4'h2 && Blue_bd == 4'h8))
                begin
                    Red = Red_bd;
                    Green = Green_bd;
                    Blue = Blue_bd; 
                end
         else if(blue_diamond_on2 &&!(Red_bd2 == 4'hE && Green_bd2 == 4'h3 && Blue_bd2 == 4'hD) &&!(Red_bd2 == 4'h8 && Green_bd2 == 4'h2 && Blue_bd2 == 4'h8))
                begin
                    Red = Red_bd2;
                    Green = Green_bd2;
                    Blue = Blue_bd2; 
                end
         else if(blue_diamond_on3 &&!(Red_bd3 == 4'hE && Green_bd3 == 4'h3 && Blue_bd3 == 4'hD) &&!(Red_bd3 == 4'h8 && Green_bd3 == 4'h2 && Blue_bd3 == 4'h8))
                begin
                    Red = Red_bd3;
                    Green = Green_bd3;
                    Blue = Blue_bd3; 
                end
         else if(button_on &&!(Red_button == 4'hE && Green_button == 4'h3 && Blue_button == 4'hD))
                begin
                    Red = Red_button;
                    Green = Green_button;
                    Blue = Blue_button; 
                end
          else if(lever_on &&!(Red_lever == 4'hE && Green_lever == 4'h3 && Blue_lever == 4'hD)&&!(Red_lever == 4'h9 && Green_lever == 4'h3 && Blue_lever == 4'h6)&&!(Red_lever == 4'hA && Green_lever == 4'h2 && Blue_lever == 4'hA))
                begin
                    Red = Red_lever;
                    Green = Green_lever;
                    Blue = Blue_lever; 
                end
          else if((rod1_on) && !(lever_flipped))
                begin
                    Red = Red_rod1;
                    Green = Green_rod1;
                    Blue = Blue_rod1; 
                end
           else if((rod2_on)&& !(button_pressed))
                begin
                    Red = Red_rod2;
                    Green = Green_rod2;
                    Blue = Blue_rod2; 
                end
        else begin 
            Red = Red_back; 
            Green = Green_back;
            Blue = Blue_back;
        end  
        end     
    end 
    
endmodule
