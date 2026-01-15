`timescale 1ns / 1ps

// Module to control BRAM access and output 8-bit samples at 16kHz
module audio_bram_player
#(
    parameter CLK_FREQ_HZ = 100_000_000,  
    parameter SAMPLE_RATE_HZ = 16_000,   // Sampling Rate (16 kHz)
    parameter CLK_DIV_LIMIT = (CLK_FREQ_HZ / SAMPLE_RATE_HZ) - 1, 
    
    parameter ADDRESS_WIDTH = 15,          
    
    
    parameter FILE_SIZE = 22416           // 22416 matches the COE file length
)
(
    input  logic CLK,
    input  logic RESET_N,
    
    output logic [ADDRESS_WIDTH-1:0] bram_addr, 
    input  logic [7:0] bram_data_out,           
    
   
    output logic [7:0] audio_sample_out, 
    output logic sample_tick            
);

    
    logic [$clog2(CLK_DIV_LIMIT):0] clk_div_counter;
    logic [ADDRESS_WIDTH-1:0] addr_counter;

    logic [7:0] delayed_sample;
    logic delayed_tick;

   
    always_ff @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            clk_div_counter <= '0;
            delayed_tick <= 1'b0; 
        end else if (clk_div_counter == CLK_DIV_LIMIT) begin
            clk_div_counter <= '0;
            delayed_tick <= 1'b1; 
        end else begin
            clk_div_counter <= clk_div_counter + 1;
            delayed_tick <= 1'b0;
        end
    end
    
    assign sample_tick = delayed_tick; 

   
    always_ff @(posedge CLK or negedge RESET_N) begin
        if (!RESET_N) begin
            addr_counter <= '0;
        end else if (clk_div_counter == CLK_DIV_LIMIT) begin
            if (addr_counter == FILE_SIZE - 1) begin
                addr_counter <= '0; 
            end else begin
                addr_counter <= addr_counter + 1; 
            end
        end
    end

    assign bram_addr = addr_counter; 
    
    always_ff @(posedge CLK) begin
        delayed_sample <= bram_data_out;
    end
    
    assign audio_sample_out = delayed_sample; 
    
endmodule