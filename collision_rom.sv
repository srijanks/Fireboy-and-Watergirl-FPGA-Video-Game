`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2025 01:36:08 PM
// Design Name: 
// Module Name: collision_rom
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


module collision_rom (
	input logic clock,
	input logic [18:0] address,
	output logic [2:0] q

);

logic [2:0] memory [0:307199] /* synthesis ram_init_file = "./ece385/collision.COE" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end


endmodule
