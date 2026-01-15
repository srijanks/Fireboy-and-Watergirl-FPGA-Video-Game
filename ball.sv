//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf     03-01-2006                           --
//                                  03-12-2007                           --
//    Translated by Joe Meng        07-07-2013                           --
//    Modified by Zuofu Cheng       08-19-2023                           --
//    Modified by Satvik Yellanki   12-17-2023                           --
//    Fall 2024 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    input logic [2:0] wLeft, wRight, wTop, wBottom,
    input logic lever_flipped, button_pressed,
    output logic [9:0]  BallX, 
    output logic [9:0]  BallY, 
    output logic [9:0]  BallS,
    output logic [9:0]  BallL, BallR, BallT, BallB,
    output logic [1:0] animation_frame,
    output logic  right_moving,
    output logic  left_moving
);
    

	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    logic [9:0] Ball_X_Motion;
    logic [9:0] Ball_X_Motion_next;
    logic [9:0] Ball_Y_Motion;
    logic [9:0] Ball_Y_Motion_next;
    logic [9:0] Ball_Y_Motion_next1; // NEW
    logic [9:0] Ball_Y_Motion_next2;
    logic [9:0] Ball_Y_Motion_next3;
    logic [9:0] Ball_Y_Motion_next4;
    logic [9:0] Ball_X_Motion_next1;
    logic [9:0] Ball_X_Motion_next2;
    logic [9:0] Ball_X_Motion_next3;
    logic [9:0] Ball_X_Motion_next4;
 
                                     // NEW ends
    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;
    logic [3:0] animation_counter;
    assign right_moving = (Ball_X_Motion_next > 0 );
    assign left_moving = (Ball_X_Motion_next < 0 );
    

        //modify to control ball motion with the keycode
 

always_comb begin
   
   if (keycode == 8'h1a && (wTop == 3'd1) &&
    !(
        ((!lever_flipped) &&
         (BallX >= 50 - 32) &&
         (BallX <= 50 + 32) &&
         (BallY >= 263 - 5)&&(BallY <= 263 + 5))
      || ((!button_pressed) &&
         (BallX >= 596 - 32) &&
         (BallX <= 596 + 32) &&
         (BallY >= 215 - 5)&&(BallY <= 215 + 5))
         ))
            begin
            Ball_Y_Motion_next = -10'd5; //W key (up)
            Ball_X_Motion_next = 10'd0;
            end
//        else if (keycode == 8'h51 && (fBottom != 3'd0)) 
//            begin
//            Ball_Y_Motion_next = 10'd5; //S key (down)
//            Ball_X_Motion_next = 10'd0;
//            end
        else if (keycode == 8'h04 && (wLeft==3'd1))
            begin
            Ball_X_Motion_next = -10'd3; //A key (left)
            Ball_Y_Motion_next = (wBottom!=3'd0) ? 10'd2 : 10'd0;
            end
        else if (keycode == 8'h07 && (wRight==3'd1))
            begin
            Ball_X_Motion_next = 10'd3; //D key (right)
            //Ball_Y_Motion_next = 10'd0;
            Ball_Y_Motion_next = (wBottom!=3'd0) ? 10'd2 : 10'd0;
            end
        else
            begin
                 Ball_Y_Motion_next = (wBottom != 3'd0) ? 10'd2 : 10'd0; // set default motion to be same as prev clock cycle 
                 Ball_X_Motion_next = 10'd0;
            end

            
 
        Ball_X_next = (BallX + Ball_X_Motion_next);
        Ball_Y_next = (BallY + Ball_Y_Motion_next);

//        if ( wBottom )  // Ball is at the bottom edge, BOUNCE!
// w: 1A, S: 16, A: 04, D: 07
//        begin
//  
        
    end

    assign BallS = 13;  // default ball size
//    assign Ball_X_next = (BallX + Ball_X_Motion_next);
//    assign Ball_Y_next = (BallY + Ball_Y_Motion_next);

   
    always_ff @(posedge frame_clk) //make sure the frame clock is instantiated correctly
    begin: Move_Ball
        if (Reset)
        begin 
            
            animation_frame <= 2'b0;
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
            
//			BallY <= Ball_Y_Center;
//			BallX <= Ball_X_Center;

            BallY <= 10'h184;
			BallX <= 10'h020;
			
			BallL <= Ball_X_Center - BallS;
			BallR <= Ball_X_Center + BallS;
			BallT <= Ball_Y_Center - BallS;
			BallB <= Ball_Y_Center + BallS;
        end
         else begin
        animation_counter <= animation_counter + 4'd1;

        if (animation_counter == 4'd4) begin
            animation_counter <= 4'd0;

            if (right_moving || left_moving) begin
                if (animation_frame == 2'b10)
                    animation_frame <= 2'b01;
                else
                    animation_frame <= 2'b10;
            end
            else begin
                animation_frame <= 2'b00;
            end
        end
        
			Ball_Y_Motion <= Ball_Y_Motion_next; 
			Ball_X_Motion <= Ball_X_Motion_next; 

            BallY <= Ball_Y_next;  // Update ball position
            BallX <= Ball_X_next;
            
            BallL <= Ball_X_next - BallS;
			BallR <= Ball_X_next + BallS;
			BallT <= Ball_Y_next - BallS;
			BallB <= Ball_Y_next + BallS;
			
		end  
    end   
endmodule