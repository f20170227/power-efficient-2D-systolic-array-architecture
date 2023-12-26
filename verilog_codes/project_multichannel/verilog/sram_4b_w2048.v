// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module sram_64b_w2048 (CLK, D, Q, CEN, WEN, A, reset, CEN_act);

  input  CLK;
  input  WEN;
  input  CEN;
  input  CEN_act;
  input reset;
  input  [63:0] D;
  input  [10:0] A;
  output [31:0] Q;
  parameter num = 2048;  // weights and activation
  parameter ic = 16;
  parameter nij = 36;

  reg [63:0] memory [num-1:0];
  reg [10:0] add_q;
  reg [31:0] Q_reg;
  reg [4:0]cnt; //FIXME_TODO
  reg [31:0]cnt_act; //FIXME_TODO
  assign Q = Q_reg;



  always @ (posedge CLK) begin
if (reset) begin
      cnt <= 0;
      cnt_act <= 0;
   end
   else begin
	  if (!CEN && WEN) begin // read 
		if (cnt == ic*2)
			cnt <= 0;
		else if (cnt[0] == 0) begin
			Q_reg <= memory[A][31:0];
			cnt <= cnt + 1;
		end

		else if (cnt[0] == 1) begin
			Q_reg <= memory[A][63:32];
			cnt <= cnt + 1;
		end
          end

	  if (!CEN_act && WEN) begin // read 
		if (cnt_act == nij*2)
			cnt_act <= 0;
		else if (cnt_act[0] == 0) begin
			Q_reg <= memory[A][31:0];
			cnt_act <= cnt_act + 1;
		end

		else if (cnt_act[0] == 1) begin
			Q_reg <= memory[A][63:32];
			cnt_act <= cnt_act + 1;
		end
          end
   if (!CEN && !WEN) // write
      memory[A] <= D; 

  if (!CEN_act && !WEN) // write
      memory[A] <= D; 

  end
end

endmodule
