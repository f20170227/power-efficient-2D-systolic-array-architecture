
module core(clk, reset, inst, ofifo_valid, D_xmem, sfp_out, final_psum_from_sram);

parameter bw = 4;
parameter psum_bw = 16;
parameter final_psum_bw = 24;
parameter len_kij = 9;
parameter len_onij = 16;
parameter col = 8;
parameter row = 8;
parameter len_nij = 36;
parameter num = 2048;


input clk;
input reset;
input [47:0]inst;
output ofifo_valid;
input [bw*row-1:0]D_xmem;
output [col*psum_bw-1:0] sfp_out;
wire [bw*row-1:0]temp_input_dbi;
wire [psum_bw*col-1:0]temp_input_l1;


input acc_input;
wire [(final_psum_bw*col)-1:0]psum_from_corelet;

output [(final_psum_bw*col)-1:0]final_psum_from_sram;


corelet #(.bw(bw), .psum_bw(psum_bw), .col(col), .row(row), .final_psum_bw(final_psum_bw)) corelet_0 
(.clk(clk), 
.reset(reset), 
.data_in_to_dbi(temp_input_dbi), 
.l0_rd(inst[3]), 
.l0_wr(inst[2]), 
.ofifo_rd(inst[6]), 
.inst_in(inst[1:0]), 
.psum_addition(sfp_out),
.acc_input(inst[33]),
.final_output(psum_from_corelet),
.dbi_1_output(temp_input_l1),
.dbi_en(inst[47]));

sram_32b_w2048 #(.num(num)) sram_w_act 
(.CLK(clk), 
.D(D_xmem), 
.Q(temp_input_dbi), 
.CEN(inst[19]), 
.WEN(inst[18]), 
.A(inst[17:7]));

psum_sram_128b_w2048 #(.num(num)) psum_sram_w_act
(.CLK(clk), 
.D(temp_input_l1), 
.Q(sfp_out), 
.CEN(inst[32]), 
.WEN(inst[31]), 
.A(inst[30:20]));

psum_sram_24b_w2048 #(.num(num)) psum_sram_w_act_f
(.CLK(clk), 
.D(psum_from_corelet), 
.Q(final_psum_from_sram), 
.CEN(inst[46]), 
.WEN(inst[45]), 
.A(inst[44:34]));

endmodule
