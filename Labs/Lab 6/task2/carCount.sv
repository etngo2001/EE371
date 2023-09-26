/*	Name: Eugene Ngo
	Date: 3/7/2023
	Class: EE 371
	Lab 6: Parking Lot 3D Simulation
*/

// carCount takes 6 inputs (park1, park2, park3, full, clk, reset. 
// It sets the state of the number of cars currently left based on 
// the number of spots available. There is no incrementing or decrementing 
// of an existing number, this is purely just sequential unit with a moore-like logic
// that outputs the number of spots available based on the number
// of spots taken. This is derived from the carCount from part 1
// therefore, the parameter is kept, but it is not a requirement.
`timescale 1 ps / 1 ps
module carCount #(parameter MAX=3) (park1, park2, park3, full, clk, reset, out);

	input logic park1, park2, park3, full, clk, reset;
	output logic [1:0] out;

	// Sequential logic for setting the number of spaces left based on the
	// parking sensors..
	always_ff @(posedge clk) begin
		// If everything is reset, set output to 3 spots left
		if (reset) begin
			out <= 2'b11;
		end
		// If 0 spots taken, output 3 spots left.
		if (~park1 & ~park2 & ~park3) begin
			out <= 2'b11;
		end
		// If 1 spot taken, output 2 spots left
		else if ((park1 & ~park2 & ~park3) | (~park1 & park2 & ~park3) | (~park1 & ~park2 & park3)) begin
			out <= 2'b10;
		end
		// If 2 spots taken, output 1 spot left
		else if ((park1 & park2 & ~park3) | (~park1 & park2 & park3) | (park1 & ~park2 & park3)) begin // decrement when not at min
			out <= 2'b01;
		end
		// If 3 spots taken, output 0 spot left (datapath should then convert this to "FULL").
		else if (full == 1'b1) begin
			out <= 2'b00;
		end
		else
			out <= out; // hold value otherwise
	end // always_ff

endmodule 

// carCount_testbench tests all expected, unexpected, and edgecase behaviors
// to ensure the module updates the current number of spots available based on the number
// of cars in the parking lot.
module carCount_testbench();
	// Same I/O as carCount()
	logic park1, park2, park3, full, clk, reset;
	logic [1:0] out;
	logic CLOCK_50;
	
	carCount #(3) dut (.park1, .park2, .park3, .full, .clk(CLOCK_50), .reset, .out);
	
	// Setting up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // toggle the clock forever
	end // initial
	
	initial begin
		reset <= 1;                @(posedge CLOCK_50); // reset
		reset <= 0; 					@(posedge CLOCK_50); // inc past max limit
		park1 <= 0;						@(posedge CLOCK_50); // dec past min limit
		park1 <= 1;						@(posedge CLOCK_50); // dec past min limit
		park2 <= 0;						@(posedge CLOCK_50); // dec past min limit
		park2 <= 1;						@(posedge CLOCK_50); // dec past min limit
		park3 <= 0;						@(posedge CLOCK_50); // dec past min limit
		park3 <= 1;						@(posedge CLOCK_50); // dec past min limit
		park3 <= 0;						@(posedge CLOCK_50); // dec past min limit
		park2 <= 0;						@(posedge CLOCK_50); // dec past min limit
		park3 <= 1;						@(posedge CLOCK_50); // dec past min limit
		park1 <= 0;						@(posedge CLOCK_50); // dec past min limit
		park3 <= 0;						@(posedge CLOCK_50); // dec past min limit
		$stop;
	end
endmodule // counter_testbench