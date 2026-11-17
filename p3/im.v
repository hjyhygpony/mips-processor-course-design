module im_1k( clk,addr, dout ) ;
	 input clk;
    input   [12:0]   addr ;  // address bus
    output  [31:0]  dout ;  // 32-bit memory output
    
rrom rom(.clka(clk),.addra(addr),.douta(dout[31:0]));

  
endmodule