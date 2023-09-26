module fifo_ctrl #(parameter A_WIDTH=4) (clk, reset, rd, wr, empty, full, w_addr, r_addr);
	input logic clk, reset, rd, wr;
	output logic empty, full;
	output logic [A_WIDTH-1:0] w_addr, r_addr;
	
	logic [A_WIDTH-1:0] rd_ptr, rd_ptr_next;
	logic [A_WIDTH-1:0] wr_ptr, wr_ptr_next;
	logic empty_next, full_next;
	
	assign w_addr = wr_ptr;
	assign r_addr = rd_ptr;
	
	always_ff @(posedge clk) begin
		if(reset) begin
			wr_ptr <= 0;
			rd_ptr <= 0;
			full <= 0;
			empty <= 1;
		end // if
		else begin
			wr_ptr <= wr_ptr_next;
			rd_ptr <= rd_ptr_next;
			full <= full_next;
			empty <= empty_next;
		end // else
	end // always_ff
	
	always_comb begin
		rd_ptr_next = rd_ptr;
		wr_ptr_next = wr_ptr;
		empty_next = empty;
		full_next = full;
		
		case ({rd, wr})
			2'b11:
					begin
						rd_ptr_next = rd_ptr + 1'b1;
						wr_ptr_next = wr_ptr + 1'b1;
					end
			2'b10:
					if(~empty) begin
						rd_ptr_next = rd_ptr + 1'b1;
						if(rd_ptr_next == wr_ptr)
							empty_next = 1;
						full_next = 0;
					end
			2'b01:
					if(~full) begin
						wr_ptr_next = wr_ptr + 1'b1;
						if(wr_ptr_next == rd_ptr)
							full_next = 1;
						empty_next = 0;
					end			2'b00: ;
		endcase
	end // always_comb
	
endmodule
