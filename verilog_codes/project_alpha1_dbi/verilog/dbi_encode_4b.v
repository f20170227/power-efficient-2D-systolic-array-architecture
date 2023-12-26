module dbi_encode_4b (data_in,dbi_en,clk,reset,data_out);

parameter bw = 4;

input clk;
input reset;
input dbi_en;
input [bw-1:0] data_in;
output [bw:0] data_out;
reg [bw-1:0] data_out_reg;
reg  dbi_enc_reg;


wire [bw-1:0] xrd_temp;
reg [bw-1:0]prev_data;
reg [bw-1:0]sum_ones_reg;
wire [bw-1:0]sum_ones;


assign dbi_enc = dbi_enc_reg;
assign xrd_temp = prev_data ^ data_in;
assign data_out = {dbi_enc_reg,data_out_reg};


//always @(*) begin
//for (integer i=0;i<bw;i++) begin
//	sum_ones = sum_ones + xrd_temp[i];
//end
//end


assign sum_ones = sum_ones_reg + xrd_temp[0] + xrd_temp[1] + xrd_temp[2] + xrd_temp[3];

always@(posedge clk)begin

	if(reset) begin
		prev_data <= 0;
		sum_ones_reg <= 0;
	end
	else begin
		if (dbi_en == 1) begin
		if (sum_ones > (bw/2)) begin
			dbi_enc_reg <= 1;
			data_out_reg <= ~(data_in);
			prev_data <= ~(data_in);
		end
		else begin
			dbi_enc_reg <= 0;
			prev_data <= data_in;
			data_out_reg <= data_in;
		end
		sum_ones_reg <= 0;
		end
		else begin
			data_out_reg <= data_in;
			dbi_enc_reg <= 0;
		end
	end
	
end
endmodule
