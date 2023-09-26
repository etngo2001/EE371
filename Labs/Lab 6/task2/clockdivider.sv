/*	Name: Eugene Ngo
	Date: 3/7/2023
	Class: EE 371
	Lab 6: Parking Lot 3D Simulation
	
*/

// Clock divider for hardware testing. Takes 1-bit input clock and reset and outputs
// 32-bit divided_clocks to get slower clocking for testing on the hardware.
// Module was borrowed from EE 271.
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
`timescale 1 ps / 1 ps
module clock_divider (clock, reset, divided_clocks);
	input logic reset, clock;
	output logic [31:0] divided_clocks = 0;
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end // always_ff
	
endmodule // clock_divider
