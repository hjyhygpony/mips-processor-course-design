module ifu(clk,reset,npc_sel,zero,insout);
	input clk,reset,npc_sel,zero;
	output [31:0]insout;
	
	reg [31:0]pc;
	reg [7:0] im[1023:0];
	
	assign insout={im[pc[9:0]],im[pc[9:0]+1]，im[pc[9:0]+2],im[pc[9:0]+3]};