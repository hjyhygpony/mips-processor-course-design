module pc(clk, rst,pcin, pcout);
  input [31:0] pcin;
  input clk,rst;
  output reg [31:0] pcout;
  
  always@(posedge clk,posedge rst)
  begin
    if(rst) pcout=32'h0000_3000;
    else
    pcout <= pcin;
   end
endmodule  