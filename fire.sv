`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 03:57:49 PM
// Design Name: 
// Module Name: fire
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module  fire 
( 
    input  logic        Reset, 
    input  logic        frame_clk,
    input  logic [7:0]  keycode,
    input logic fLeft, fRight, fTop, fBottom,
    input logic lever_flipped, 
    input logic button_pressed,

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

    logic [9:0] Ball_X_next;
    logic [9:0] Ball_Y_next;
    logic [3:0] animation_counter;
    
//    logic [1:0] animation_frame_next;
    
    assign right_moving = (Ball_X_Motion_next > 0 );
    assign left_moving = (Ball_X_Motion_next < 0 );
    
    

    
    always_comb begin
        //modify to control ball motion with the keycode
        if (keycode == 8'h52 && (fTop == 3'd1) &&
    !(
        ((!lever_flipped) &&
         (BallX >= 50 - 32) &&
         (BallX <= 50 + 32) &&
         (BallY >= 263 - 5) && (BallY <= 263 + 5))
      || ((!button_pressed) &&
         (BallX >= 596 - 32) &&
         (BallX <= 596 + 32) &&
         (BallY >= 215 - 5) &&(BallY <= 215 + 5))
         )
   )
        
            begin
            Ball_Y_Motion_next = -10'd5; //W key (up)
            Ball_X_Motion_next = 10'd0;
            end
//        else if (keycode == 8'h51 && (fBottom != 3'd0)) 
//            begin
//            Ball_Y_Motion_next = 10'd5; //S key (down)
//            Ball_X_Motion_next = 10'd0;
//            end
        else if (keycode == 8'h50 && (fLeft==3'd1))
            begin
            Ball_X_Motion_next = -10'd3; //A key (left)
            Ball_Y_Motion_next = (fBottom!=3'd0) ? 10'd2 : 10'd0;
            end
        else if (keycode == 8'h4f && (fRight==3'd1))
            begin
            Ball_X_Motion_next = 10'd3; //D key (right)
            //Ball_Y_Motion_next = 10'd0;
            Ball_Y_Motion_next = (fBottom!=3'd0) ? 10'd2 : 10'd0;
            end
        else
            begin
                 Ball_Y_Motion_next = (fBottom != 3'd0) ? 10'd2 : 10'd0; // set default motion to be same as prev clock cycle 
                 Ball_X_Motion_next = 10'd0;
            end
            

        Ball_X_next = (BallX + Ball_X_Motion_next);
        Ball_Y_next = (BallY + Ball_Y_Motion_next);

//        if ( fBottom == 1'b0 )  // Ball is at the bottom edge, BOUNCE!
//        begin
//            //Ball_Y_next = Ball_Y_Max - BallS;
//            Ball_Y_Motion_next =0;  // set to -1 via 2's complement.
            
//        end
//        else if (  fTop == 1'b0)  // Ball is at the top edge, BOUNCE!
//        begin
//            //Ball_Y_next = Ball_Y_Min + BallS;
//            Ball_Y_Motion_next = 0;  // set to -1 via 2's complement.
//        end  
//       //fill in the rest of the motion equations here to bounce left and right
//        if (   fRight == 1'b0)  // Ball is at the right edge, BOUNCE!
//        begin
//            //Ball_X_next = Ball_X_Max - BallS;
//            Ball_X_Motion_next = 0;  // set to -1 via 2's complement.
//        end
//        else if (  fLeft == 1'b0)  // Ball is at the left edge, BOUNCE!
//        begin
//            //Ball_X_next = Ball_X_Min + BallS;
//             Ball_X_Motion_next = 0;  // set to -1 via 2's complement.
//        end
        
    end
    
//    always_comb
//    begin
//          if ((Ball_X_next >= 338 - 10) &&(Ball_X_next <= 338 + 10) &&(Ball_Y_next >= 424 - 10) && (Ball_Y_next <= 424 + 10))
//             red_diamond_on = 1'b0;
//           else
//            red_diamond_on = 1'b1;        
//    end

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

            BallY <= 10'h1c5;
			BallX <= 10'h01d;
			
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

