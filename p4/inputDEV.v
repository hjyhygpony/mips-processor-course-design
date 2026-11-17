module inputDEV(
  input clk,
  input en,
  input [3:2] addr,
  input [31:0] din,
  output [31:0] dout
);
  
  reg [31:0] inputReg;  // 32位输入寄存器
  
  initial begin
    inputReg = 0;
  end
  
  always@(posedge clk) begin
    if(en) begin
      case(addr)
        2'b00: inputReg <= din;  // 写入输入数据
        default: $display("Illegal addr for inputDEV");
      endcase
    end
  end
  
  assign dout = (addr == 2'b00) ? inputReg : 32'bz;
  
endmodule