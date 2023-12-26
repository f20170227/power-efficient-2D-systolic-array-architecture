module dbi_encode_128b (data_in,dbi_en,clk,reset,data_out);

parameter bw = 128;

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



assign sum_ones = sum_ones_reg + xrd_temp[0] + xrd_temp[1] + xrd_temp[2] + xrd_temp[3] + xrd_temp[4] + xrd_temp[5] + xrd_temp[6] + xrd_temp[7] + xrd_temp[8] + xrd_temp[9] + xrd_temp[10] + xrd_temp[11] + xrd_temp[12] + xrd_temp[13] + xrd_temp[14] + xrd_temp[15] + xrd_temp[16] + xrd_temp[17] + xrd_temp[18] + xrd_temp[19] + xrd_temp[20] + xrd_temp[21] + xrd_temp[22] + xrd_temp[23] + xrd_temp[24] + xrd_temp[25] + xrd_temp[26] + xrd_temp[27] + xrd_temp[28] + xrd_temp[29] + xrd_temp[30] + xrd_temp[31] + xrd_temp[32] + xrd_temp[33] + xrd_temp[34] + xrd_temp[35] + xrd_temp[36] + xrd_temp[37] + xrd_temp[38] + xrd_temp[39] + xrd_temp[40] + xrd_temp[41] + xrd_temp[42] + xrd_temp[43] + xrd_temp[44] + xrd_temp[45] + xrd_temp[46] + xrd_temp[47] + xrd_temp[48] + xrd_temp[49] + xrd_temp[50] + xrd_temp[51] + xrd_temp[52] + xrd_temp[53] + xrd_temp[54] + xrd_temp[55] + xrd_temp[56] + xrd_temp[57] + xrd_temp[58] + xrd_temp[59] + xrd_temp[60] + xrd_temp[61] + xrd_temp[62] + xrd_temp[63] + xrd_temp[64] + xrd_temp[65] + xrd_temp[66] + xrd_temp[67] + xrd_temp[68] + xrd_temp[69] + xrd_temp[70] + xrd_temp[71] + xrd_temp[72] + xrd_temp[73] + xrd_temp[74] + xrd_temp[75] + xrd_temp[76] + xrd_temp[77] + xrd_temp[78] + xrd_temp[79] + xrd_temp[80] + xrd_temp[81] + xrd_temp[82] + xrd_temp[83] + xrd_temp[84] + xrd_temp[85] + xrd_temp[86] + xrd_temp[87] + xrd_temp[88] + xrd_temp[89] + xrd_temp[90] + xrd_temp[91] + xrd_temp[92] + xrd_temp[93] + xrd_temp[94] + xrd_temp[95] + xrd_temp[96] + xrd_temp[97] + xrd_temp[98] + xrd_temp[99] + xrd_temp[100] + xrd_temp[101] + xrd_temp[102] + xrd_temp[103] + xrd_temp[104] + xrd_temp[105] + xrd_temp[106] + xrd_temp[107] + xrd_temp[108] + xrd_temp[109] + xrd_temp[110] + xrd_temp[111] + xrd_temp[112] + xrd_temp[113] + xrd_temp[114] + xrd_temp[115] + xrd_temp[116] + xrd_temp[117] + xrd_temp[118] + xrd_temp[119] + xrd_temp[120] + xrd_temp[121] + xrd_temp[122] + xrd_temp[123] + xrd_temp[124] + xrd_temp[125] + xrd_temp[126] + xrd_temp[127] + xrd_temp[127];


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
