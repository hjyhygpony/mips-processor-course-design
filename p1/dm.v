module dm_1k( addr, din, we, clk, dout) ;
    input   [9:0]   addr ;  // address bus
    input   [31:0]  din ;   // 32-bit input data
    input           we ;    // memory write enable
    input           clk ;   // clock
    output  [31:0]  dout ;  // 32-bit memory output
    reg     [7:0]   dm[1023:0] ;
	 
    wire [15:0] word;
	 wire [31:0] temp1;
    
    assign word = {dm[addr+1], dm[addr]};	 
	 assign temp1 = {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]};
	 
    assign dout = temp1 ;
  
    integer i;
    initial 
    begin
      for(i = 0; i < 1024; i = i+1)
          dm[i] <= 0;
    end
  
  
    always @(posedge clk)
      if(we)  begin
        {dm[addr+3], dm[addr+2], dm[addr+1], dm[addr]} <= {din[31:24], din[23:16], din[15:8], din[7:0]};
		  $display("Writing");

    end
    
      else  begin
        $display("Reading");
    end
        
endmodule