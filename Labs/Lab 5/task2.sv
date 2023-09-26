module task2 (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
						AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input logic [9:0] SW;
	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	logic read_ready, write_ready, read, write;
	logic [23:0] readdata_left, readdata_right;
	logic [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	
	logic [23:0] romOutput;
	
	part2 (.clk(CLOCK_50), .romOutput);
	
	 always_comb begin
    if (~SW[9]) begin 
      writedata_left = readdata_left;
      writedata_right = readdata_right;
    end
    else begin
      writedata_left = romOutput;
      writedata_right = romOutput;
    end
  end
	
	assign read = read_ready;
	assign write = write_ready;
	
	
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);


endmodule
