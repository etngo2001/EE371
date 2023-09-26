/*	Name: Eugene Ngo
	Date: 3/7/2023
	Class: EE 371
	Lab 6: Parking Lot 3D Simulation
*/

// dataPathUnit outputs different values
// the hex displays based on many different control signals. 
// These control signals are primarily determined by the controlUnit.
// This unit outputs data to the RAM and the HEX displays and
// then reads from the RAM into the Hex displays once the parking lot day is done.
`timescale 1 ps / 1 ps
 module dataPathUnit (startRush, stopRush, endGameHexOut, clk, in, time_in, incr_in, addr_in, reset, rushEnded, slowClk, hexout0, hexout1, hexout2, hexout3, hexout4, hexout5);
	
	// In is the input from the carCount unit. 2 bits, to represent the number of cars
	// left.
	input logic [1:0] in;
	// Time in represents the current hour of the day, the output of the hourCount module.
	// Incr_in and addr_in are values used for the RAM module. Incr_in represents
	// the output of the carIncr unit and the addr_in represents the output of the
	// addrIncr unit. These are then inputted into the RAM module to first 
	// write values in and then read from it once the parking lot is done.
	input logic [3:0] time_in, incr_in, addr_in;
	
	
	// main outputs of the control logic unit. These are used to 
	// update HEX in specific conditions or set values that are to update the hex.
	// StartRush indicates to datapath the start of the rush and it stores that hour.
	// stopRush indicates the stop of the rush and it stores that hour.
	// endGameHexOut indicates that the parking lot day is done and that
	// the output is now to be rushHour info and RAM info.
	// clk and reset are standard.
	// rushEnded is the key to ensuring rushHour outputs only occur when
	// rushHours actually occured.
	// slowClk is the other clock used to load in RAM values to hex, slower
	// to ensure they are visible.
	input logic startRush, stopRush, endGameHexOut, clk, reset, rushEnded, slowClk;
	// Hexout0-5 output to the Hex displays in DE1_SoC
	output logic [6:0] hexout0, hexout1, hexout2, hexout3, hexout4, hexout5;
	
	// Different hex outputs that are stored to based on the control signals.
	// These the hexouts are eventually set if the appropriate control signals are triggered.
	
	logic[6:0] rushHourBegin, rushHourEnd, endingAddr, endingVal;
	
	
	// The clock that is selected at the end for units that require slower clocks.
	logic selectedClock;
	
	// Slow clock is divided_clocks[25] to act at 0.75 Hz which is approximately 0.75 updates per second
	// similar to the requirement of 1 update per second in the lab manual
	
	// Assigning hex display variables on necessary numbers.
	logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9;
	logic [7:0] ramOutput;
	assign hex0 = 7'b1000000; // 0
	assign hex1 = 7'b1111001; // 1
	assign hex2 = 7'b0100100; // 2
	assign hex3 = 7'b0110000; // 3
	assign hex4 = 7'b0011001; // 4
	assign hex5 = 7'b0010010; // 5
	assign hex6 = 7'b0000010; // 6
	assign hex7 = 7'b1111000; // 7
	assign hex8 = 7'b0000000; // 8
	assign hex9 = 7'b0010000; // 9
	
	// Assigning hex display variables on necessary letters.
	logic [6:0] hexf, hexu, hexl, hexc, hexe, hexa, hexr, hexoff, hexdash;
	assign hexf = 7'b0001110; // F
	assign hexu = 7'b1000001; // U
	assign hexl = 7'b1000111; // L
	assign hexoff = 7'b1111111; // off
	assign hexdash = 7'b0111111; // -
	
	// The selected clock. If it is the end game, use a slower clock. This 
	// selected clock is then used for the hex update for hex2 and 1 for the rAM
	// readings.
	assign selectedClock =  endGameHexOut ? slowClk : clk;
	
	
	// Logic for hexout0. If it's the endgame, it's off otherwise 
	// displays the number of spots left. If the spots are full
	// it displays the last l in full.
	always_ff @ (posedge clk) begin
		case(endGameHexOut)
			1'b0:
				case(in)
					2'b00: hexout0 = hexl;
					2'b01: hexout0 = hex1;
					2'b10: hexout0 = hex2;
					2'b11: hexout0 = hex3;
					default: hexout0 = 7'bX;
				endcase
				
			1'b1:
				hexout0 <= hexoff;
		endcase
	end // always_comb
	
	// Logic for hexout1. If it's the endgame, it displays the
	// RAM value of the spot address being iterated over.
	// Otherwise, it displays off, unless the spots are full
	// in which case it displays the letter L
	always_ff @ (posedge selectedClock) begin
		case(endGameHexOut)
			1'b0:
				case(in)
					2'b00: hexout1 <= hexl;
					2'b01: hexout1 <= hexoff;
					2'b10: hexout1 <= hexoff;
					2'b11: hexout1 <= hexoff;
					default: hexout1 <= 7'bX;
				endcase
			1'b1:
				hexout1 <= endingVal;
		endcase
	end // always_comb
	// Logic for hexout2. If it's the endgame, it displays the
	// RAM address of the address being iterated over.
	// Otherwise, it displays off, unless the spots are
	// full in which case it displays u.
	always_ff @ (posedge selectedClock) begin
		case(endGameHexOut)
			1'b0:
				case(in)
					2'b00: hexout2 <= hexu;
					2'b01: hexout2 <= hexoff;
					2'b10: hexout2 <= hexoff;
					2'b11: hexout2 <= hexoff;
					default: hexout2 <= 7'bX;
				endcase
			1'b1:
				hexout2 <= endingAddr;
		endcase
	end
	// Logic for hexout3. If it's the endgame
	// it displays the rushHour beginning number.
	// If there is no end to the rush hour, it displays hash.
	// In non endgame. it displays the letter F in full.
	always_ff @ (posedge selectedClock) begin
		case(endGameHexOut)
			1'b0:
				case(in)
					2'b00: hexout3 <= hexf;
					2'b01: hexout3 <= hexoff;
					2'b10: hexout3 <= hexoff;
					2'b11: hexout3 <= hexoff;
					default: hexout3 <= 7'bX;
				endcase
			1'b1:
				case (rushEnded)
					1'b1:
						hexout3 <= rushHourBegin;
					1'b0:
						hexout3 <= hexdash;
				endcase
		endcase
	end
	
	// Logic for hexout4. In endgame, it shows the hour
	// that rush hour ended and displasy a dash if it never ended.
	// Stays off otherwise.
	always_ff @ (posedge clk) begin
		case(endGameHexOut)
			1'b0:
				case(in)
					2'b00: hexout4 <= hexoff;
					2'b01: hexout4 <= hexoff;
					2'b10: hexout4 <= hexoff;
					2'b11: hexout4 <= hexoff;
					default: hexout4 <= 7'bX;
				endcase
			1'b1:
				case (rushEnded)
					1'b1:
						hexout4 <= rushHourEnd;
					1'b0:
						hexout4 <= hexdash;
				endcase
		endcase
	end
	// Logic for setting the hour for rushHourbegin,
	// If startRush is triggered, store the hour it
	// was triggered in as a hex.
	always_ff @ (posedge startRush) begin
		case(time_in)
			4'b0000: rushHourBegin <= hex0;
			4'b0001: rushHourBegin <= hex1;
			4'b0010: rushHourBegin <= hex2;
			4'b0011: rushHourBegin <= hex3;
			4'b0100: rushHourBegin <= hex4;
			4'b0101: rushHourBegin <= hex5;
			4'b0110: rushHourBegin <= hex6;
			4'b0111: rushHourBegin <= hex7;
			4'b1000: rushHourBegin <= hex8;
			4'b1001: rushHourBegin <= hexoff;
			4'b1010: rushHourBegin <= hexoff;
			4'b1011: rushHourBegin <= hexoff;
			4'b1100: rushHourBegin <= hexoff;
			4'b1101: rushHourBegin <= hexoff;
			4'b1110: rushHourBegin <= hexoff;
			4'b1111: rushHourBegin <= hexoff;
			default: rushHourBegin <= 7'bX;
		endcase
	end
	
	
	// Logic for setting the hour for rushHourend,
	// If stopRush is triggered, store the hour it
	// was triggered in as a hex.
	always_ff @ (posedge stopRush) begin
		case(time_in)
			4'b0000: rushHourEnd <= hex0;
			4'b0001: rushHourEnd <= hex1;
			4'b0010: rushHourEnd <= hex2;
			4'b0011: rushHourEnd <= hex3;
			4'b0100: rushHourEnd <= hex4;
			4'b0101: rushHourEnd <= hex5;
			4'b0110: rushHourEnd <= hex6;
			4'b0111: rushHourEnd <= hex7;
			4'b1000: rushHourEnd <= hex8;
			4'b1001: rushHourEnd <= hex9;
			4'b1010: rushHourEnd <= hexl;
			4'b1011: rushHourEnd <= hexl;
			4'b1100: rushHourEnd <= hexl;
			4'b1101: rushHourEnd <= hexl;
			4'b1110: rushHourEnd <= hexl;
			4'b1111: rushHourEnd <= hexl;
			default: rushHourEnd <= hexl;
		endcase
	end
	
	// Logic for setting Hexout5. This is 
	// only set by the time in, if that exceeds
	// 7, sets it to off.
	always_ff @ (posedge clk) begin
		case(time_in)
			4'b0000: hexout5 <= hex0;
			4'b0001: hexout5 <= hex1;
			4'b0010: hexout5 <= hex2;
			4'b0011: hexout5 <= hex3;
			4'b0100: hexout5 <= hex4;
			4'b0101: hexout5 <= hex5;
			4'b0110: hexout5 <= hex6;
			4'b0111: hexout5 <= hex7;
			4'b1000: hexout5 <= hexoff;
			4'b1001: hexout5 <= hexoff;
			4'b1010: hexout5 <= hexoff;
			4'b1011: hexout5 <= hexoff;
			4'b1100: hexout5 <= hexoff;
			4'b1101: hexout5 <= hexoff;
			4'b1110: hexout5 <= hexoff;
			4'b1111: hexout5 <= hexoff;
			default: hexout5 <= 7'bX;
		endcase
	end
	
	
	// Translates the address the RAM is being
	// iterated into a HEX digit between 0 and 7.
	always_ff @ (posedge clk) begin
		case(addr_in)
			4'b0000: endingAddr <= hex0;
			4'b0001: endingAddr <= hex1;
			4'b0010: endingAddr <= hex2;
			4'b0011: endingAddr <= hex3;
			4'b0100: endingAddr <= hex4;
			4'b0101: endingAddr <= hex5;
			4'b0110: endingAddr <= hex6;
			4'b0111: endingAddr <= hex7;
			4'b1000: endingAddr <= hexoff;
			4'b1001: endingAddr <= hexoff;
			4'b1010: endingAddr <= hexoff;
			4'b1011: endingAddr <= hexoff;
			4'b1100: endingAddr <= hexoff;
			4'b1101: endingAddr <= hexoff;
			4'b1110: endingAddr <= hexoff;
			default: endingAddr <= 7'bX;
		endcase
	end
	
	// Translates the ramOutput value to 
	// a hex digit to display on hex2.
	always_ff @ (posedge clk) begin
		case(ramOutput)
			8'b00000000: endingVal <= hex0;
			8'b00000001: endingVal <= hex1;
			8'b00000010: endingVal <= hex2;
			8'b00000011: endingVal <= hex3;
			8'b00000100: endingVal <= hex4;
			8'b00000101: endingVal <= hex5;
			8'b00000110: endingVal <= hex6;
			8'b00000111: endingVal <= hex7;
			8'b00001000: endingVal <= hex8;
			8'b00001001: endingVal <= hexoff;
			8'b00001010: endingVal <= hexoff;
			8'b00001011: endingVal <= hexoff;
			8'b00001100: endingVal <= hexoff;
			8'b00001101: endingVal <= hexoff;
			8'b00001110: endingVal <= hexoff;
			default: endingVal <= 7'bX;
		endcase
	end
	
	// Saves to ram when not in endgame, reads from ram in endgame.
    RAM8x16  ram(.clock(clk), .data(incr_in), .rdaddress(addr_in),.wraddress(time_in),.wren(!endGameHexOut),.q(ramOutput));
 
 endmodule // seg7
 
 // dataPathUnit_testbench tests all expected, unexpected, and edgecase behaviors
 // iterates through different inputs of time and inputs to 
 // see the impact on the parking lot.
 module dataPathUnit_testbench();
 	logic CLOCK_50;
	logic [1:0] in;
	logic [3:0] time_in, incr_in, addr_in;
	logic startRush, stopRush, endGameHexOut, clk, reset, rushEnded, slowClk;
	logic [6:0] hexout0, hexout1, hexout2, hexout3, hexout4, hexout5;
	
	dataPathUnit dut (startRush, stopRush, endGameHexOut, CLOCK_50, in, time_in, incr_in, addr_in, reset, rushEnded, CLOCK_50, hexout0, hexout1, hexout2, hexout3, hexout4, hexout5);	
	
	// Setting up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // toggle the clock forever
	end // initial
	
	initial begin
		reset <= 1;                @(posedge CLOCK_50); // reset
		reset <= 0; 					@(posedge CLOCK_50); // inc past max limit
		in <= 2'b10; 					@(posedge CLOCK_50);
		time_in <= 4'b0011;			@(posedge CLOCK_50);
		startRush <= 1;				@(posedge CLOCK_50);
		startRush <= 0;				@(posedge CLOCK_50);
		time_in <= 4'b0100;			@(posedge CLOCK_50);
		stopRush <= 1;					@(posedge CLOCK_50);
		stopRush <= 0;					@(posedge CLOCK_50);
		in <= 2'b11;					@(posedge CLOCK_50);
		rushEnded <= 1;					@(posedge CLOCK_50);
		time_in <= 4'b1000;			@(posedge CLOCK_50);
		$stop;
	end // initial
endmodule // seg7_testbench