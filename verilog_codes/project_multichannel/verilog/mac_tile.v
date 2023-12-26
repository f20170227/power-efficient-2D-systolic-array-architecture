// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_tile (clk, out_s, in_w, out_e, in_n, inst_w, inst_e, reset, valid_n, valid_s);

parameter bw = 4;
parameter psum_bw = 16;

output [psum_bw-1:0] out_s;
input  [bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
output [bw-1:0] out_e; 
input  [1:0] inst_w;
reg  [1:0] inst_del;
output [1:0] inst_e;
input  [psum_bw-1:0] in_n;
input  clk;
input  reset;

input valid_n;
output valid_s;


reg    [bw-1:0] a_q;
reg    signed [bw-1:0] b_q;
reg    signed [bw-1:0] b_q_1;
reg    signed [psum_bw-1:0] c_q;
reg   signed [psum_bw-1:0] out_q;
reg   signed [psum_bw-1:0] psum_temp;
reg    [1:0] inst_q;
reg    load_ready_q;
reg cnt;
reg act_cnt;

assign out_s  = ((inst_w[1] && act_cnt == 0) ? out_q:0);
assign out_e  = a_q;
assign inst_e = inst_q;


/*mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance (
        .a(in_w), 
        .b(b_q),
        .c(in_n),
	.out(psum_temp)
);


mac #(.bw(bw), .psum_bw(psum_bw)) mac_instance_2 (
        .a(in_w), 
        .b(b_q_1),
        .c(psum_temp),
	.out(out_q)
);*/

assign valid_s = (act_cnt == 0 && ((inst_w == 2'b10 && inst_w == 2'b00) || inst_del == 2'b10)) ? 1 : 0;

always @ (posedge clk) begin

   if (reset) begin
        load_ready_q <= 1;
        inst_q       <= 0;
	a_q <= 0;
	b_q <= 0;
	b_q_1 <= 0;
	c_q <= 0;
	cnt <= 0;
	act_cnt <= 0;
	psum_temp <= 0;
	out_q <= 0;
	inst_del <= 0;
   end
   else begin
        inst_q[1]  <= inst_w[1];
	inst_del <= inst_w;
	if (inst_w[1] == 1 && act_cnt == 0) begin
		psum_temp <= $signed({1'b0,in_w}) * b_q + $signed({1'b0,in_n}) ;
		act_cnt <= 1;
	end

	if (inst_w[1] == 1 && act_cnt == 1) begin
		out_q <= psum_temp + $signed({1'b0,in_w}) * b_q_1;
		act_cnt <= 0;
	end
	if(inst_w[0] | inst_w[1])
		a_q <= in_w;
        if (inst_w[0] && load_ready_q && cnt ==0) begin
           b_q  <= in_w;
	   cnt <= 1;
        end
	if (inst_w[0] && load_ready_q && cnt ==1) begin
           b_q_1  <= in_w;
           load_ready_q <= 0;
	   cnt <= 0;
        end
        if (load_ready_q == 1'b0)
           inst_q[0] <= inst_w[0];
   end
end


endmodule
