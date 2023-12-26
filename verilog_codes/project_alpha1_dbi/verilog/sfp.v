// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp (out, in, acc, clk, reset);

parameter psum_bw = 16;

input clk;
input acc;
input reset;

input signed [psum_bw-1:0] in;
output signed [psum_bw-1:0] out;
reg signed [psum_bw-1:0] acc_add_reg;

// Your code goes here
assign out = (acc_add_reg > 0) ? acc_add_reg:0;



always @(posedge clk) begin
	if (reset == 1'b1) begin
		acc_add_reg <= 0;
	end
	else begin
		if (acc == 1) begin
			acc_add_reg <= acc_add_reg + in;
		end
		else begin
			acc_add_reg <= 0;
		end
	end
	
end


endmodule
