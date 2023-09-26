module part3 #(parameter N)(clk, in, out, reset);
	input logic clk, reset;
	input logic [23:0] in;
	output logic [23:0] out;

	logic [N-1:0] [23:0] buffer;
	logic [23:0] accumulator;
	
	logic [23:0] firstValue, firstSum;
	
	assign firstValue = {{N{in[23]}}, in[23:N]};
	
	always_ff @(posedge clk) begin
		if (reset) begin
			for (int i = 0; i < N; i ++) begin
				buffer[i][23:0] = 0;
			end
		end
		else begin
			firstSum = ((buffer[N-1][23:0]) * -1) + firstValue;
			
			for (int i = N-1; i > 0; i--) begin
				buffer[i][23:0] = buffer[i-1][23:0];
			end
			buffer[0][23:0] = firstValue;
		end	
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			accumulator = 0;
		end
		else begin
			accumulator = firstSum + accumulator;
		end
	end
	
	assign out = firstSum + accumulator;		
	
endmodule 