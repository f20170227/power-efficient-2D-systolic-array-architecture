// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module ofifo (clk, in, out, rd, wr, o_valid, reset);

  parameter col  = 8;
  parameter psum_bw = 16;

  input  clk;
  input  [col-1:0] wr;
  input  rd;
  input  reset;
  input  [col*psum_bw-1:0] in;
  output [col*psum_bw-1:0] out;
  output o_valid;

  wire [col-1:0] empty;
  wire [col-1:0] full;
  
  genvar i;

  assign o_valid  = (!empty[0]&&!empty[1]&&!empty[2]&&!empty[3]&&!empty[4]&&!empty[5]&&!empty[6]&&!empty[7]) && rd;

  generate
  for (i=0; i<col ; i=i+1) begin : col_num
      fifo_depth16 #(.bw(psum_bw)) fifo_instance (
	 .rd_clk(clk),
	 .wr_clk(clk),
	 .rd(o_valid),
	 .wr(wr[i]),
         .o_empty(empty[i]),
         .o_full(full[i]),
	 .in(in[psum_bw*(i+1)-1:psum_bw*i]),
	 .out(out[psum_bw*(i+1)-1:psum_bw*i]),
         .reset(reset));
  end
  endgenerate


 
endmodule
