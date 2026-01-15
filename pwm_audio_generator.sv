`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 11:40:55 PM
// Design Name: 
// Module Name: pwm_audio_generator
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

// Converts an 8-bit signed audio sample into a PWM duty cycle
module pwm_audio_generator
(
    input  logic CLK,
    input  logic [7:0] audio_sample_in, 
    output logic pwm_out_left,         
    output logic pwm_out_right         
);

   
    logic [7:0] pwm_counter; 
    
    // Shift the signed audio sample to an unsigned 8-bit bias value (0 to 255).
    // This is required to center the audio signal around a 50% duty cycle.
    // -128 (min) + 128 = 0 (0% duty)
    // 0 (center) + 128 = 128 (50% duty)
    // 127 (max) + 128 = 255 (100% duty)
    logic [7:0] pwm_duty_threshold;
    assign pwm_duty_threshold = (audio_sample_in + 8'd128); 
    
    // Counter
    always_ff @(posedge CLK) begin
        pwm_counter <= pwm_counter + 1; 
    end

    // PWM Logic (Output Generation)
    // The PWM output is HIGH when the counter is less than the duty threshold.
    // The filter on the Urbana board will smooth this high-frequency pulse train.
    // We output the same PWM signal for both Left and Right channels for mono audio.
    assign pwm_out_left  = (pwm_counter < pwm_duty_threshold);
    assign pwm_out_right = (pwm_counter < pwm_duty_threshold);
    
endmodule
