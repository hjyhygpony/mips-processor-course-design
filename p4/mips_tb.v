module mips_tb;
  
  reg clk, rst;
  reg [31:0] dev1_rd_sim;
  
  mips m(.clk(clk), .rst(rst));
  
  initial
  begin
    dev1_rd_sim = 32'h1234_5678; // 预设初始值
    rst = 0;
    clk = 0;
    #50 rst = 1;
    #70 rst = 0;
    #2000 dev1_rd_sim = 32'd66;   // 模拟运行时输入变化
    #3960 dev1_rd_sim = 32'd50;
  end
  
  always
  begin
    #100 clk = ~clk;
  end
  
endmodule