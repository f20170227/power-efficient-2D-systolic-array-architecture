module dbi_decode_32b (data_in,dbi_en,clk,reset,data_out);

parameter bw = 32;

input clk;
input reset;
input dbi_en;
input [bw:0] data_in;
output [bw-1:0] data_out;
reg [bw-1:0] data_out_reg;

wire temp;
assign data_out = data_out_reg;
assign temp = data_in[bw];

always @(posedge clk) begin
	if(reset) begin
		data_out_reg <= 0;
	end
	else begin
		if (dbi_en == 1) begin
			if (temp == 0) begin
				data_out_reg <= data_in[bw-1:0];
			end
			else begin
				data_out_reg <= ~(data_in[bw-1:0]);
			end
		end
		else begin
			data_out_reg <= data_in[bw-1:0];
		end

	end
end

endmodule
