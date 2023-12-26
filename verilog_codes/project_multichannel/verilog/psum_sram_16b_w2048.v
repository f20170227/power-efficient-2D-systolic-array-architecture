// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module psum_sram_128b_w2048 (CLK, D, Q, CEN, WEN, A, A_rd, o_valid, CEN_rd);

  input  CLK;
  input  WEN;
  input  CEN;
  input  CEN_rd;
  input o_valid;
  input  [127:0] D;
  input  [11:0] A;
  input  [11:0] A_rd;
  output [127:0] Q;
  parameter num = 4096;  // weights and activation

  reg [127:0] memory [num-1:0];
  reg [11:0] add_q;
  assign Q = memory[add_q];

  always @ (posedge CLK) begin

   if (!CEN_rd && WEN) // read 
      add_q <= A_rd;
   if (!CEN && !WEN && o_valid) // write
      memory[A] <= D; 

  end

  //integer idx;
  //initial begin
  //$dumpfile("core_tb.vcd");
  //for(idx=0; idx<num; idx=idx+1) begin
  //$dumpvars(0, memory[idx]);
  //end
  //end

endmodule
