module dm_1k( addr, din, we, clk, dout, lb, sb) ;
    input   [9:0]   addr ;  // address bus
    input   [31:0]  din ;   // 32-bit input data
    input           we ;    // memory write enable
    input           clk ;   // clock
    output  [31:0]  dout ;  // 32-bit memory output
    reg     [7:0]   dm[1023:0] ;
    input lb, sb;
    
 	 wire [31:0] temp1;
	 wire [7:0] templb;
 	 wire [7:0] tempsb;

	 assign temp1 = {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]};
	 assign templb = dm[addr];
   
    assign dout = (lb == 1'b1) ? {{24{templb[7]}}, templb} : temp1;
	 
	 
 	 assign tempsb = din[7:0];

  
    // dm initial = 0
    integer i;
    initial 
    begin
      for(i = 0; i < 1024; i = i+1)
          dm[i] <= 0;
    end
  
    always @(posedge clk)
      if(we)  begin
		  $display("dmWriting");
        if(!sb)
          {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]} <= {din[31:24], din[23:16], din[15:8], din[7:0]};
        else
          dm[addr] <= tempsb;
    end
    
      else  begin
        $display("dmReading");
    end
        
endmodule