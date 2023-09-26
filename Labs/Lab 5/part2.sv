module part2 (clk, romOutput);

	input logic clk;
	output logic [23:0] romOutput;

	logic [15:0] i = 0;
	logic [15:0] address = 0;
				  
	always_ff @(posedge clk) begin
		if (i == 65536) begin
			i <= 0;
		end
			
		else begin
			i <= i + 1;
			address <= address + 1'b1;
		end
	end

	rom rom1port (.address(address), .clock(clk), .q(romOutput));
	
				  
endmodule



	
