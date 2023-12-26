// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  reg    [2*row-1:0] inst_w_temp;
  wire   [psum_bw*col*(row+1)-1:0] temp;
  wire   [row*col-1:0] valid_temp;
  reg [1:0] inst_temp0;
  reg [1:0] inst_temp1;
  reg [1:0] inst_temp2;
  reg [1:0] inst_temp3;
  reg [1:0] inst_temp4;
  reg [1:0] inst_temp5;
  reg [1:0] inst_temp6;
  reg [1:0] inst_temp7;


  assign out_s = temp[psum_bw*col*(row+1)-1:psum_bw*col*(row)];
  assign temp[psum_bw*col-1:0] = in_n;
  assign valid = valid_temp[col*row-1 : col*(row-1)];

  genvar i;
  generate
  for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
         .clk(clk),
         .reset(reset),
         .in_w(in_w[bw*i-1:bw*(i-1)]),
         .inst_w(inst_w_temp[2*i-1:2*(i-1)]),
         .in_n(temp[psum_bw*col*i-1:psum_bw*col*(i-1)]),
	 .out_s(temp[psum_bw*col*(i+1)-1:psum_bw*col*(i)]),
         .valid(valid_temp[col*i-1:col*(i-1)]));
  end
  endgenerate

  always @ (posedge clk) begin
    if (reset) begin
	inst_temp0 <= 2'b00;
	inst_temp1 <= 2'b00;
	inst_temp2 <= 2'b00;
	inst_temp3 <= 2'b00;
	inst_temp4 <= 2'b00;
	inst_temp5 <= 2'b00;
	inst_temp6 <= 2'b00;
	inst_temp7 <= 2'b00;
    end	    
    else begin
    inst_w_temp[1:0]   <= inst_w[1:0]; 
    inst_temp1   <= inst_w_temp[1:0]; 
    inst_w_temp[3:2]   <= inst_temp1; 
    inst_temp2  <= inst_w_temp[3:2]; 
    inst_w_temp[5:4] <= inst_temp2;
    inst_temp3 <= inst_w_temp[5:4]; 
    inst_w_temp[7:6] <= inst_temp3;
    inst_temp4 <= inst_w_temp[7:6];
    inst_w_temp[9:8] <= inst_temp4;
    inst_temp5 <= inst_w_temp[9:8];
    inst_w_temp[11:10] <= inst_temp5;
    inst_temp6 <= inst_w_temp[11:10];
    inst_w_temp[13:12] <= inst_temp6;
    inst_temp7 <= inst_w_temp[13:12];
    inst_w_temp[15:14] <= inst_temp7;
    end

   // inst_w flows to row0 to row7
 
  end



endmodule
