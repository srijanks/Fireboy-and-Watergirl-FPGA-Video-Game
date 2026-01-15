`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 01:37:54 AM
// Design Name: 
// Module Name: audio_no_top
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


module audio_no_top(
    input  logic clk_in, 
    input  logic reset_btn,
    
    output logic [1:0] pwm_out 
    );
    
     logic locked;
  logic CLK_IN_100MHZ;
  logic BTN_RESET;
  
    logic [17:0] bram_addr; 
    logic [7:0] bram_data_out; 
    

    logic [7:0] audio_sample_8bit;
    logic sample_tick_16kHz;
    
    assign BTN_RESET = ~reset_btn;
    assign CLK_IN_100MHZ = clk_in;
    
//       clk_wiz_0 clk_wiz (
//        .clk_out1(CLK_IN_100MHZ),
//        .reset(reset_btn),
//        .locked(locked),
//        .clk_in1(clk_in)
//    );
    
   
    no_audio_bram_player Player_Inst (
        .CLK(CLK_IN_100MHZ),
        .RESET_N(BTN_RESET),
        .bram_addr(bram_addr),
        .bram_data_out(bram_data_out),
        .audio_sample_out(audio_sample_8bit),
        .sample_tick(sample_tick_16kHz)
    );
    
  
    pwm_audio_generator PWM_Gen_Inst2 (
        .CLK(CLK_IN_100MHZ),
        .audio_sample_in(audio_sample_8bit),
        .pwm_out_left(pwm_out[0]),  
        .pwm_out_right(pwm_out[1]) 
    );

  
    no_rom no_rom (
        .clka(CLK_IN_100MHZ),     
        .addra(bram_addr),      
        .douta(bram_data_out) 
    );
endmodule
