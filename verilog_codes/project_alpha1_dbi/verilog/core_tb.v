// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
//`timescale 1ns/1ps

module core_tb;

parameter bw = 4;
parameter psum_bw = 16;
parameter len_kij = 9;
parameter len_onij = 16;
parameter col = 8;
parameter row = 8;
parameter len_nij = 36;

reg clk = 0;
reg reset = 1;

wire [50:0] inst_q; 

reg [1:0]  inst_w_q = 0; 
reg [bw*row-1:0] D_xmem_q = 0;
reg CEN_xmem = 1;
reg WEN_xmem = 1;
reg [10:0] A_xmem = 0;
reg CEN_xmem_q = 1;
reg WEN_xmem_q = 1;
reg [10:0] A_xmem_q = 0;
reg CEN_pmem = 1;
reg CEN_pmem_rd = 1;
reg CEN_pmem_2q = 1;
reg WEN_pmem = 1;
reg WEN_pmem_rd = 1;
reg [11:0] A_pmem = 0;
reg [11:0] A_pmem_store = 11'h0FF;
reg CEN_pmem_q = 1;
reg CEN_pmem_rd_q = 1;
reg WEN_pmem_q = 1;
reg WEN_pmem_rd_q = 1;
reg WEN_pmem_2q = 1;
reg [11:0] A_pmem_q = 0;
reg ofifo_rd_q = 0;
reg ififo_wr_q = 0;
reg ififo_rd_q = 0;
reg l0_rd_q = 0;
reg l0_wr_q = 0;
reg l0_wr_2q = 0;
reg l0_wr_3q = 0;
reg execute_q = 0;
reg load_q = 0;
reg load_2q = 0;
reg acc_q = 0;
reg acc = 0;

reg [1:0]  inst_w; 
reg [bw*row-1:0] D_xmem;
reg [psum_bw*col-1:0] answer;
reg check_ans;


reg ofifo_rd;
reg ififo_wr;
reg ififo_rd;
reg l0_rd;
reg l0_wr;
reg execute;
reg load;
reg [8*30:1] stringvar;
reg [8*30:1] w_file_name;
reg [8*30:1] scan_out_file;
wire ofifo_valid;
wire [col*psum_bw-1:0] sfp_out;
wire [(psum_bw*col)-1:0] final_psum_from_sram;
reg [col*psum_bw-1:0] answer_queue[0:200];
reg [31:0] count_num;


reg dbi_en_q;
reg dbi_en;
reg final_psum_wr_rd_q;
reg final_psum_wr_rd;

reg CEN_final_pmem_q;
reg CEN_final_pmem_2q;
reg CEN_final_pmem;
reg WEN_final_pmem_q;
reg WEN_final_pmem_2q;
reg WEN_final_pmem;
reg [10:0]A_final_pmem_q;
reg [10:0]A_final_pmem;


integer x_file, x_scan_file ; // file_handler
integer w_file, w_scan_file ; // file_handler
integer acc_file, acc_scan_file ; // file_handler
integer out_file, out_scan_file ; // file_handler
integer captured_data; 
integer t, i, j, k, kij;
integer error;
integer ans_count = 0;
integer num_of_kij = 0;

assign inst_q[50] = CEN_pmem_rd_q;
assign inst_q[49] = WEN_pmem_rd_q;
assign inst_q[48] = dbi_en_q;
assign inst_q[47] = CEN_final_pmem_q;
assign inst_q[46] = WEN_final_pmem_q;
assign inst_q[45:35] = A_final_pmem_q;
assign inst_q[34] = acc_q;
assign inst_q[33] = CEN_pmem_q;
assign inst_q[32] = WEN_pmem_q;
assign inst_q[31:20] = A_pmem_q;
assign inst_q[19]   = CEN_xmem_q;
assign inst_q[18]   = WEN_xmem_q;
assign inst_q[17:7] = A_xmem_q;
assign inst_q[6]   = ofifo_rd_q;
assign inst_q[5]   = ififo_wr_q;
assign inst_q[4]   = ififo_rd_q;
assign inst_q[3]   = l0_rd_q;
assign inst_q[2]   = l0_wr_3q;
assign inst_q[1]   = execute_q; 
assign inst_q[0]   = load_2q; 


core  #(.bw(bw), .col(col), .row(row)) core_instance (
	.clk(clk), 
	.inst(inst_q),
	.ofifo_valid(ofifo_valid),
        .D_xmem(D_xmem_q), 
        .sfp_out(sfp_out),
        .final_psum_from_sram(final_psum_from_sram),
	.reset(reset)); 


initial begin 

  inst_w   = 0; 
  D_xmem   = 0;
  CEN_xmem = 1;
  WEN_xmem = 1;
  A_xmem   = 0;
  ofifo_rd = 0;
  ififo_wr = 0;
  ififo_rd = 0;
  l0_rd    = 0;
  l0_wr    = 0;
  execute  = 0;
  load     = 0;
  CEN_final_pmem = 0;
  WEN_final_pmem = 0;
  final_psum_wr_rd = 0;
  CEN_final_pmem = 1;
  WEN_final_pmem = 0;
  A_final_pmem = 0;

  $dumpfile("core_tb.vcd");
  $dumpvars(0,core_tb);

  x_file = $fopen("activation.txt", "r");
  // Following three lines are to remove the first three comment lines of the file
  x_scan_file = $fscanf(x_file,"%s", captured_data);
  x_scan_file = $fscanf(x_file,"%s", captured_data);
  x_scan_file = $fscanf(x_file,"%s", captured_data);

  //////// Reset /////////
  #1 clk = 1'b0;   reset = 1;
  #1 clk = 1'b1; 

  for (i=0; i<10 ; i=i+1) begin
    #1 clk = 1'b0;
    #1 clk = 1'b1;  
  end

  #1 clk = 1'b0;   reset = 0;
  #1 clk = 1'b1; 

  #1 clk = 1'b0;   
  #1 clk = 1'b1;   
  /////////////////////////

  /////// Activation data writing to memory ///////
  for (t=0; t<len_nij; t=t+1) begin  
    #1 clk = 1'b0;  x_scan_file = $fscanf(x_file,"%32b", D_xmem); WEN_xmem = 0; CEN_xmem = 0; if (t>0) A_xmem = A_xmem + 1;
    #1 clk = 1'b1;   
  end

  #1 clk = 1'b0;  WEN_xmem = 1;  CEN_xmem = 1; A_xmem = 0;
  #1 clk = 1'b1; 

  $fclose(x_file);
  /////////////////////////////////////////////////


  for (kij=0; kij<9; kij=kij+1) begin  // kij loop

    case(kij)
     0: w_file_name = "weight_kij0.txt";
     1: w_file_name = "weight_kij1.txt";
     2: w_file_name = "weight_kij2.txt";
     3: w_file_name = "weight_kij3.txt";
     4: w_file_name = "weight_kij4.txt";
     5: w_file_name = "weight_kij5.txt";
     6: w_file_name = "weight_kij6.txt";
     7: w_file_name = "weight_kij7.txt";
     8: w_file_name = "weight_kij8.txt";
    endcase
    

    w_file = $fopen(w_file_name, "r");
    // Following three lines are to remove the first three comment lines of the file
    w_scan_file = $fscanf(w_file,"%s", captured_data);
    w_scan_file = $fscanf(w_file,"%s", captured_data);
    w_scan_file = $fscanf(w_file,"%s", captured_data);

    #1 clk = 1'b0;   
    #1 clk = 1'b1; 

    for (i=0; i<10 ; i=i+1) begin
      #1 clk = 1'b0;
      #1 clk = 1'b1;  
    end

    #1 clk = 1'b0;  
    #1 clk = 1'b1; 

    #1 clk = 1'b0;   
    #1 clk = 1'b1;   





    /////// Kernel data writing to memory ///////

    A_xmem = 11'b10000000000; dbi_en=1;

    for (t=0; t<col; t=t+1) begin  
      #1 clk = 1'b0;  w_scan_file = $fscanf(w_file,"%32b", D_xmem); WEN_xmem = 0; CEN_xmem = 0; if (t>0) A_xmem = A_xmem + 1; 
      #1 clk = 1'b1;  
    end

    #1 clk = 1'b0;  WEN_xmem = 1; CEN_xmem = 0; A_xmem = 0;
    #1 clk = 1'b1; 
    /////////////////////////////////////
 	#1 clk = 1'b0;
 	#1 clk = 1'b1;

    /////// Kernel data writing to L0 ///////
    /////////////////////////////////////
    l0_wr = 1;
    l0_rd = 0;
    A_xmem = 11'b10000000000;

    for (t=0; t<col; t=t+1) begin  
      #1 clk = 1'b0; 
      A_xmem = A_xmem + 1; 
      #1 clk = 1'b1;  
    end

    l0_wr = 0;
    #1 clk = 1'b0;
    #1 clk = 1'b1;
    for (i=0; i<10 ; i=i+1) begin
      #1 clk = 1'b0;
      #1 clk = 1'b1;  
    end


     #1 clk = 1'b0;
    /////// Kernel loading to PEs ///////
    /////////////////////////////////////
    #1 clk = 1'b1;
    for (t=0; t<col; t=t+1) begin  
      #1 clk = 1'b0; 
      load = 1;
      l0_rd = 1;
      #1 clk = 1'b1;  
    end 


    ////// provide some intermission to clear up the kernel loading ///
    #1 clk = 1'b0;  load = 0; l0_rd = 0;
    #1 clk = 1'b1;  
  

    for (i=0; i<10 ; i=i+1) begin
      #1 clk = 1'b0;
      #1 clk = 1'b1;  
    end
    /////////////////////////////////////



    /////// Activation data writing to L0 ///////
    /////////////////////////////////////
    l0_wr = 1;
    l0_rd = 0;
    A_xmem = 11'b00000000000;

    A_pmem = A_pmem_store; 


    for (t=0; t<len_nij; t=t+1) begin  
      #1 clk = 1'b0; 
      A_xmem = A_xmem + 1; 
      if(t>1) l0_rd = 1; 
      if(t>2) begin execute = 1; ofifo_rd =1; end
      if(t>21) begin WEN_pmem = 0; CEN_pmem = 0; end
      if(t>21) begin A_pmem = A_pmem + 1; count_num = count_num + 1; end
      #1 clk = 1'b1;  
    end
    for (t=0; t<=21; t=t+1) begin
      #1 clk = 1'b0;
      WEN_pmem = 0; CEN_pmem = 0; A_pmem = A_pmem + 1; count_num = count_num + 1;
      if (t==3) execute=0;
      #1 clk = 1'b1;
    end

    A_pmem_store = A_pmem_store + 12'h100;


    #1 clk = 1'b0;
    l0_wr = 0;
    l0_rd = 1;
    if(count_num==len_nij && kij==8) CEN_pmem = 1;
    count_num = 0;
    #1 clk = 1'b1;

    #1 clk = 1'b0;
    l0_rd = 1;
    #1 clk = 1'b1;

    #1 clk = 1'b0;
    l0_rd = 0;
    #1 clk = 1'b1;
    for (i=0; i<10 ; i=i+1) begin
      #1 clk = 1'b0;
      if(i>8) ofifo_rd = 0; 
      #1 clk = 1'b1;  
    end


    /////// Execution ///////
    /////////////////////////////////////

    //#1 clk = 1'b0;
    //l0_rd = 1;
    //#1 clk = 1'b1;

    //for (t=0; t<len_nij; t=t+1) begin  
    //  #1 clk = 1'b0; 
    //  execute = 1; 
    //  #1 clk = 1'b1;  
    //end
    for (t=0; t<col; t=t+1) begin  
      #1 clk = 1'b0; 
      #1 clk = 1'b1;  
    end

    #1 clk = 1'b0;
    l0_rd = 0;
    #1 clk = 1'b1;

    //////// OFIFO READ ////////
    // Ideally, OFIFO should be read while execution, but we have enough ofifo
    // depth so we can fetch out after execution.
    /////////////////////////////////////
    //#1 clk = 1'b0;
    //ofifo_rd = 1;
    //#1 clk = 1'b1;

    //#1 clk = 1'b0;
    //A_pmem = 11'h100;
    //#1 clk = 1'b1;

    //for (t=0; t<len_nij; t=t+1) begin  
    //  #1 clk = 1'b0;  
    //  WEN_pmem = 0; CEN_pmem = 0; A_pmem = A_pmem + 1; 
    //  #1 clk = 1'b1;  
    //end

    //#1 clk = 1'b0;  WEN_pmem = 1;  CEN_pmem = 1; ofifo_rd = 0;
    //#1 clk = 1'b1; 

    //for (i=0; i<10 ; i=i+1) begin
    //  #1 clk = 1'b0;
    //  #1 clk = 1'b1;  
    //end


  //end  // end of kij loop
  
  ////////// Accumulation /////////

  #1 clk = 1'b0;  
  #1 clk = 1'b1;  

  #1 clk = 1'b0;  
  #1 clk = 1'b1;  

  WEN_pmem = 1; CEN_pmem = 1;
  

  if (error == 0) begin
  	$display("############ No error detected ##############"); 
  	$display("########### Project Completed !! ############"); 
  end

  //$fclose(acc_file);
  //////////////////////////////////
  #1 clk = 1'b0;   reset = 1;
  #1 clk = 1'b1; 

  for (i=0; i<10 ; i=i+1) begin
    #1 clk = 1'b0;
    #1 clk = 1'b1;  
  end

  #1 clk = 1'b0;   reset = 0;
  #1 clk = 1'b1; 

end  

//$display("############ Verification Start during accumulation #############"); 

  acc_file = $fopen("acc.txt", "r");
  for (i=0; i<len_onij; i=i+1) begin 

    #1 clk = 1'b0; 
    #1 clk = 1'b1; 

    //if (i>0) begin
    // out_scan_file = $fscanf(out_file,"%128b", answer); // reading from out file to answer
    //   if (sfp_out == answer)
    //     $display("%2d-th output featuremap Data matched! :D", i); 
    //   else begin
    //     $display("%2d-th output featuremap Data ERROR!!", i); 
    //     $display("sfpout: %128b", sfp_out);
    //     $display("answer: %128b", answer);
    //     error = 1;
    //   end
    //end
   
 
    #1 clk = 1'b0;
    #1 clk = 1'b1;  
    #1 clk = 1'b0;
    #1 clk = 1'b1;  

    

    for (j=0; j<len_kij+1; j=j+1) begin 

      #1 clk = 1'b0;   
        if (j<len_kij) begin CEN_pmem_rd = 0; WEN_pmem_rd = 1; acc_scan_file = $fscanf(acc_file,"%12b", A_pmem); 
                       end
                       else  begin CEN_pmem_rd = 1; WEN_pmem = 1; end

        if (j>0)  acc = 1;  
      #1 clk = 1'b1;   
    end

    #1 clk = 1'b0; acc = 0; CEN_final_pmem = 0; A_final_pmem = A_final_pmem + 1;
    #1 clk = 1'b1;
    #1 clk = 1'b0;
    #1 clk = 1'b1; CEN_final_pmem = 1; 
  end

  WEN_final_pmem = 1; CEN_final_pmem = 1;
  #1 clk = 1'b0;
  #1 clk = 1'b1;
  A_final_pmem = 0;
  for(j=0; j<len_onij; j=j+1) begin
    #1 clk = 1'b0;  WEN_final_pmem = 1; CEN_final_pmem = 0;  A_final_pmem = A_final_pmem + 1;
    #1 clk = 1'b1;
  end

  for(j=0; j<100; j=j+1) begin
     #1 clk = 1'b0;
     #1 clk = 1'b1;
  end

  #700 $finish;

end

initial begin
  out_file = $fopen("out_relu.txt", "r");
  out_scan_file = $fscanf(out_file,"%s", answer); 
  out_scan_file = $fscanf(out_file,"%s", answer); 
  out_scan_file = $fscanf(out_file,"%s", answer); 

  for(j=0; j<len_nij; j=j+1) begin
      out_scan_file = $fscanf(out_file,"%128b", answer);
      answer_queue[j] = answer;
  end
end

always @(posedge clk) begin
  if(WEN_final_pmem_2q && !CEN_final_pmem_2q && ans_count < len_onij) begin
     if (final_psum_from_sram == answer_queue[ans_count])
       $display("%2d-th output featuremap Data matched! :D", ans_count); 
     else begin
       $display("%2d-th output featuremap Data ERROR!!", i); 
       $display("final_sram_out: %128b", final_psum_from_sram);
       $display("answer: %128b", answer_queue[ans_count]);
       error = 1;
     end
     ans_count = ans_count + 1;
  end 
end

always @(*) begin
    if(ans_count==len_onij) begin
        if(error==1) begin
	    $display("There are data errors!");
	end else begin
	    $display("############ No error detected ##############"); 
  	    $display("########### Project Completed !! ############"); 
	end
    end
end



always @ (posedge clk) begin
   inst_w_q   <= inst_w; 
   dbi_en_q   <= dbi_en; 
   D_xmem_q   <= D_xmem;
   CEN_xmem_q <= CEN_xmem;
   WEN_xmem_q <= WEN_xmem;
   A_pmem_q   <= A_pmem;
   CEN_pmem_q <= CEN_pmem;
   CEN_pmem_rd_q <= CEN_pmem_rd;
   CEN_pmem_2q <= CEN_pmem_q;
   WEN_pmem_q <= WEN_pmem;
   WEN_pmem_rd_q <= WEN_pmem_rd;
   WEN_pmem_2q <= WEN_pmem_q;
   A_xmem_q   <= A_xmem;
   ofifo_rd_q <= ofifo_rd;
   acc_q      <= acc;
   ififo_wr_q <= ififo_wr;
   ififo_rd_q <= ififo_rd;
   l0_rd_q    <= l0_rd;
   l0_wr_q    <= l0_wr ;
   l0_wr_2q    <= l0_wr_q ;
   l0_wr_3q    <= l0_wr_2q ;
   execute_q  <= execute;
   load_q     <= load;
   load_2q     <= load_q;
   final_psum_wr_rd_q     <= final_psum_wr_rd;
   CEN_final_pmem_q <= CEN_final_pmem;
   WEN_final_pmem_q <= WEN_final_pmem;
   CEN_final_pmem_2q <= CEN_final_pmem_q;
   WEN_final_pmem_2q <= WEN_final_pmem_q;
   A_final_pmem_q <= A_final_pmem;


end


endmodule




