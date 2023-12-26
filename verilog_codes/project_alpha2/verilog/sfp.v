// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sfp (out, in, acc, clk, reset);

parameter psum_bw = 16;

input clk;
input acc;
input reset;

input signed [psum_bw-1:0] in;
output signed [23:0] out;
reg signed [23:0] acc_add;

// Your code goes here
assign out = acc_add;

reg [3:0]cnt;


always @(posedge clk) begin
	if (reset == 1'b1) begin
		acc_add <= 0;
		cnt <= 4'b0000;
	end
	else begin
		if (acc == 1) begin
		acc_add <= acc_add + in;
		if (cnt == 8) begin
			acc_add <= (acc_add > 0) ? acc_add:0 ;
			cnt <= 0;
		end
		cnt <= cnt + 1;
		end
	end
	
end


endmodule
