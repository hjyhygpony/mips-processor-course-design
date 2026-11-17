module outputDEV(clk, en, addr, din, dout,led48);
  input clk, en;
  input [3:2] addr;
  input [31:0] din;
  output [31:0] dout;
  output [3:0] led48;
  
  reg [31:0] preData, curData;
  
  initial begin
    preData = 0; curData = 0;
  end
  
  always@(posedge clk)  begin
    if(en)
      case(addr)
        2'b00:
          preData <= din;
        2'b01:
          curData <= din;
        default:
          $display("Illegal addr");
      endcase
  end
  
  assign dout = (addr == 2'b00) ? preData : (addr == 2'b01) ? curData : 32'bz;
  assign led48 = dout[3:0];
endmodule