// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module psum_sram_128b_w2048 (CLK, D, Q, CEN, WEN, A);

  input  CLK;
  input  WEN;
  input  CEN;
  input  [127:0] D;
  input  [10:0] A;
  output [127:0] Q;
  parameter num = 2048;  // weights and activation

  reg [127:0] memory [num-1:0];
  reg [10:0] add_q;
  assign Q = memory[add_q];

  always @ (posedge CLK) begin

   if (!CEN && WEN) // read 
      add_q <= A;
   if (!CEN && !WEN) // write
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
