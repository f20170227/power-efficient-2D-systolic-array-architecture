module corelet (clk, reset, acc_input, psum_addition, data_in_to_dbi, l0_rd, l0_wr, ofifo_rd, inst_in, final_output, dbi_en, dbi_1_output);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter final_psum_bw = 16;
  parameter col = 8;
  parameter row = 8;
  parameter len_kij = 9;
  parameter dbi_bw = 4;
  parameter dbi_bw_ofifo = 16;

  input  clk, reset;

  input [row*(bw)-1:0] data_in_to_dbi;
  input [1:0] inst_in;
  input l0_rd;
  input ofifo_rd;
  input l0_wr;
  wire [col*(psum_bw+1)-1:0]data_out_to_dbi_dec;
  input [(psum_bw*col)-1:0] psum_addition;
  output [(final_psum_bw*col)-1:0] final_output;
  input acc_input;
  wire [col*psum_bw-1:0] ofifo_input;
  wire [row*(bw)-1:0] dbi_output;
  wire [row*(bw+1)-1:0] l0_output;

  wire [col*psum_bw-1:0] data_in_ofifo;
  //wire [col-1:0] valid_to_sfu;
  //reg [col*psum_bw-1:0] sfu_mem_reg;
  //wire [col*psum_bw-1:0] sfu_mem;
  //reg [col-1:0] ofifo_vld_reg;
  wire [col-1:0] ofifo_vld;

  //assign ofifo_vld = ofifo_vld_reg;
  //assign sfu_mem = sfu_mem_reg;
  //
  input dbi_en;
  wire [row*(bw+1)-1:0] data_from_dbi_to_l0;
  wire dbi_on;
  wire [(psum_bw+1)*col-1:0]data_from_dbi_to_ofifo;
  output [psum_bw*col-1:0] dbi_1_output;

genvar i;
for (i=0;i<row;i=i+1) begin
dbi_encode_4b #(.bw(dbi_bw)) dbi_enc0 
(.data_in(data_in_to_dbi[dbi_bw*(i+1)-1:dbi_bw*i]),
.dbi_en(dbi_en),
.clk(clk),
.reset(reset),
.data_out(data_from_dbi_to_l0[(dbi_bw+1)*(i+1)-1:(dbi_bw+1)*i]));
end

for (i=0;i<col;i=i+1) begin
dbi_encode_16b #(.bw(dbi_bw_ofifo)) dbi_enc1 
(.data_in(data_in_ofifo[dbi_bw_ofifo*(i+1)-1:dbi_bw_ofifo*i]),
.dbi_en(dbi_en),
.clk(clk),
.reset(reset),
.data_out(data_from_dbi_to_ofifo[(dbi_bw_ofifo+1)*(i+1)-1:(dbi_bw_ofifo+1)*i]));
end


  mac_array #(.bw(bw), .psum_bw(psum_bw)) array0 
  (.clk(clk), 
   .reset(reset), 
   .out_s(data_in_ofifo), 
   .in_w(dbi_output), 
   .in_n(128'h0), 
   .inst_w(inst_in), 
   .valid(ofifo_vld));

l0 #(.row(row), .bw(bw+1)) l0_0 
(.clk(clk), 
 .in(data_from_dbi_to_l0), 
 .out(l0_output), 
 .rd(l0_rd), 
 .wr(l0_wr), 
 .o_full(), 
 .reset(reset), 
 .o_ready());

for (i=0;i<row;i=i+1) begin
dbi_decode_4b dbi_dec0
(.data_in(l0_output[(dbi_bw+1)*(i+1)-1:(dbi_bw+1)*i]),
.dbi_en(dbi_en),
.clk(clk),
.reset(reset),
.data_out(dbi_output[dbi_bw*(i+1)-1:dbi_bw*i]));
end

for (i=0;i<col;i=i+1) begin
dbi_decode_16b dbi_dec1
(.data_in(data_out_to_dbi_dec[(dbi_bw_ofifo+1)*(i+1)-1:(dbi_bw_ofifo+1)*i]),
.dbi_en(dbi_en),
.clk(clk),
.reset(reset),
.data_out(dbi_1_output[dbi_bw_ofifo*(i+1)-1:dbi_bw_ofifo*i]));
end


ofifo #(.col(col), .psum_bw(psum_bw+1)) ofifo_0 
(.clk(clk), 
 .in(data_from_dbi_to_ofifo), 
 .out(data_out_to_dbi_dec), 
 .rd(ofifo_rd), 
 .wr(ofifo_vld), 
 .o_valid(), 
 .reset(reset));

for (i = 0; i < col; i=i+1) begin
sfp #(.psum_bw(psum_bw)) sfp_0
(.out(final_output[(i+1)*final_psum_bw-1:final_psum_bw*i]),
.in(psum_addition[(i+1)*psum_bw-1:psum_bw*i]), 
.acc(acc_input), 
.clk(clk), 
.reset(reset));
end


//genvar i;
//for (i = 0; i < col; i=i+1) begin
//	always@(posedge clk)
//	begin
//		if(reset) begin
//			sfu_mem_reg[(psum_bw*(i+1))-1:psum_bw*i] <= 0;
//			ofifo_vld_reg[i] <= 0;
//		end
//		else begin
//			if (valid_to_sfu[i] == 1'b1) begin
//				sfu_mem_reg[(psum_bw*(i+1))-1:psum_bw*i] <= sfu_mem_reg[(psum_bw*(i+1))-1:psum_bw*i] + data_in_sfu[(psum_bw*(i+1))-1:psum_bw*i];
//				ofifo_vld_reg[i] <= 1;
//			end	
//		end
//end
//end



endmodule


