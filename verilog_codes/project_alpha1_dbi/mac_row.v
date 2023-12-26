// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_row (clk, out_s, in_w, in_n, valid, inst_w, reset);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  output [col-1:0] valid;
  input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;

  wire  [(col+1)*bw-1:0] temp;
  wire  [(col+1)*2-1:0] temp_inst;

  assign temp[bw-1:0]   = in_w;
  assign temp_inst[1:0] = inst_w;


  genvar i;
  for (i=1; i < col+1 ; i=i+1) begin : col_num
      mac_tile #(.bw(bw), .psum_bw(psum_bw)) mac_tile_instance (
         .clk(clk),
         .reset(reset),
	 .in_w(temp[bw*i-1:bw*(i-1)]),
	 .out_e(temp[bw*(i+1)-1:bw*i]),
	 .inst_w(temp_inst[2*i-1:2*(i-1)]),
	 .inst_e(temp_inst[2*(i+1)-1:2*i]),
	 .in_n(in_n[psum_bw*i-1:(i-1)*psum_bw]),
	 .out_s(out_s[psum_bw*i-1:(i-1)*psum_bw]));

	
  end


  assign valid[0] = temp_inst[3]? 1'b1:1'b0;
  assign valid[1] = temp_inst[5]? 1'b1:1'b0;
  assign valid[2] = temp_inst[7]? 1'b1:1'b0;
  assign valid[3] = temp_inst[9]? 1'b1:1'b0;
  assign valid[4] = temp_inst[11]? 1'b1:1'b0;
  assign valid[5] = temp_inst[13]? 1'b1:1'b0;
  assign valid[6] = temp_inst[15]? 1'b1:1'b0;
  assign valid[7] = temp_inst[17]? 1'b1:1'b0;

 

endmodule
