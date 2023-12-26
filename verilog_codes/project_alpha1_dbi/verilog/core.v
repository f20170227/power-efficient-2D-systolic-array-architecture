
module core(clk, reset, inst, ofifo_valid, D_xmem, sfp_out, final_psum_from_sram, dbi_en);

parameter bw = 4;
parameter psum_bw = 16;
parameter len_kij = 9;
parameter len_onij = 16;
parameter col = 8;
parameter row = 8;
parameter len_nij = 36;
parameter num = 2048;
parameter num_psum = 4096;


input clk;
input dbi_en;
input reset;
input [50:0]inst;
output ofifo_valid;
input [bw*row-1:0]D_xmem;
output [col*psum_bw-1:0] sfp_out;
wire [bw*row-1:0]temp_input_dbi;
wire [psum_bw*col-1:0]temp_input_l1;


input acc_input;
wire [(psum_bw*col)-1:0]psum_from_corelet;

output [(psum_bw*col)-1:0]final_psum_from_sram;


corelet #(.bw(bw), .psum_bw(psum_bw), .col(col), .row(row), .psum_bw(psum_bw)) corelet_0 
(.clk(clk), 
.reset(reset), 
.dbi_en(inst[48]), 
.l0_rd(inst[3]), 
.l0_wr(inst[2]), 
.ofifo_rd(inst[6]), 
.inst_in(inst[1:0]), 
.data_out_to_l1(temp_input_l1),
.psum_addition(sfp_out),
.acc_input(inst[34]),
.data_in_to_dbi(temp_input_dbi),
.final_output(psum_from_corelet));

sram_32b_w2048 #(.num(num)) sram_w_act 
(.CLK(clk), 
.D(D_xmem), 
.Q(temp_input_dbi), 
.CEN(inst[19]), 
.WEN(inst[18]), 
.A(inst[17:7]));

psum_sram_128b_w2048 #(.num(num_psum)) psum_sram_w_act
(.CLK(clk), 
.D(temp_input_l1), 
.Q(sfp_out), 
.CEN(inst[33]), 
.CEN_rd(inst[50]), 
.WEN(inst[32]), 
.WEN_rd(inst[49]), 
.A(inst[31:20]));

psum_sram_24b_w2048 #(.num(num)) psum_sram_w_act_f
(.CLK(clk), 
.D(psum_from_corelet), 
.Q(final_psum_from_sram), 
.CEN(inst[47]), 
.WEN(inst[46]), 
.A(inst[45:35]));

endmodule
