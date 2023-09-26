module fifo #(parameter D_WIDTH=24, A_WIDTH=4) (clk, reset, rd, wr, empty, full, w_data, r_data);
	input logic clk, reset, rd, wr;
	output logic empty, full;
	input logic [D_WIDTH-1:0] w_data;
	output logic [D_WIDTH-1:0] r_data;
	
	logic [A_WIDTH-1:0] w_addr, r_addr;
	logic w_en;
	
	assign w_en = wr & (~full | rd);
	
	fifo_ctrl #(A_WIDTH) control (.*);
	reg_file #(D_WIDTH, A_WIDTH) mem (.*);
endmodule // fifo