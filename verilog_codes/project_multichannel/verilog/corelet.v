module corelet (clk, reset, acc_input, psum_addition, data_in_to_l0, l0_rd, l0_wr, ofifo_rd, inst_in, data_out_to_l1, final_output, o_valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 4;
  parameter len_kij = 9;
  parameter ic = 8;

  input  clk, reset;

  input [row*(bw)-1:0] data_in_to_l0;
  //input [col*psum_bw-1:0] data_in_psum;
  input [1:0] inst_in;
  input l0_rd;
  input ofifo_rd;
  input l0_wr;
  output [col*psum_bw-1:0] data_out_to_l1;
  input [(psum_bw*col)-1:0] psum_addition;
  output [(psum_bw*col)-1:0] final_output;
  input acc_input;
  wire [col*psum_bw-1:0] ofifo_input;
  wire [row*(bw)-1:0] l0_output;

  wire [col*psum_bw-1:0] data_in_ofifo;
  //wire [col-1:0] valid_to_sfu;
  //reg [col*psum_bw-1:0] sfu_mem_reg;
  //wire [col*psum_bw-1:0] sfu_mem;
  //reg [col-1:0] ofifo_vld_reg;
  wire [col-1:0] ofifo_vld;

  output o_valid;

  //assign ofifo_vld = ofifo_vld_reg;
  //assign sfu_mem = sfu_mem_reg;


  mac_array #(.bw(bw), .psum_bw(psum_bw)) array0 
  (.clk(clk), 
   .reset(reset), 
   .out_s(data_in_ofifo), 
   .in_w(l0_output), 
   .in_n(128'h0), 
   .inst_w(inst_in), 
   .valid(ofifo_vld));

l0 #(.row(row), .bw(bw)) l0_0 
(.clk(clk), 
 .in(data_in_to_l0), 
 .out(l0_output), 
 .rd(l0_rd), 
 .wr(l0_wr), 
 .o_full(), 
 .reset(reset), 
 .o_ready());

ofifo #(.col(col), .psum_bw(psum_bw)) ofifo_0 
(.clk(clk), 
 .in(data_in_ofifo), 
 .out(data_out_to_l1), 
 .rd(ofifo_rd), 
 .wr(ofifo_vld), 
 .o_valid(o_valid), 
 .reset(reset));

genvar i;
generate
for (i = 0; i < col; i=i+1) begin: sfp_start
sfp #(.psum_bw(psum_bw)) sfp_0
(.out(final_output[(i+1)*psum_bw-1:psum_bw*i]),
.in(psum_addition[(i+1)*psum_bw-1:psum_bw*i]), 
.acc(acc_input), 
.clk(clk), 
.reset(reset));
end
endgenerate

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


