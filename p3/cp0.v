module cp0(PC, DIn, HWInt, Sel, Wen, EXLSet, EXLClr, clk, rst, IntReq, epc, DOut);
  input [31:0] PC;
  input [31:0] DIn;
  input [5:0] HWInt;
  input [4:0] Sel;
  input Wen, EXLSet, EXLClr, clk, rst;
  output IntReq;
  output [31:0] epc;
  output [31:0] DOut;
  
  parameter [4:0] SR = 5'd12;
  parameter [4:0] CAUSE = 5'd13;
  parameter [4:0] EPC = 5'd14;
  parameter [4:0] PRID = 5'd15;
  
  reg [31:0] rf_cp0 [31:0];
  
  wire [15:10] im;    
  wire exl;
  wire ie;
  assign im = rf_cp0[SR][15:10];    
  assign exl = rf_cp0[SR][1];
  assign ie = rf_cp0[SR][0];
  
  assign epc = rf_cp0[EPC];
  assign DOut = rf_cp0[Sel];
  assign IntReq = | (rf_cp0[CAUSE][15:10] & im) & ie & (~exl);
  
  integer i;

  always @(posedge clk,posedge rst) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1)
        rf_cp0[i] <= 32'b0;  // 改为非阻塞赋值
      rf_cp0[SR][15:10] <= 6'b000001;
      rf_cp0[SR][0] <= 1'b1;
      rf_cp0[CAUSE][15:10] <= 6'b000001;
      rf_cp0[PRID] <= 32'h2307_1008;
    end
    else begin
      if (Wen && (Sel != CAUSE))
        rf_cp0[Sel] <= DIn;
      else if (EXLSet) begin
        rf_cp0[SR][1] <= 1'b1;  // 非阻塞赋值
        rf_cp0[EPC] <= PC;       // 非阻塞赋值
      end
      else if (EXLClr)
        rf_cp0[SR][1:0] <= 2'b01;  // 改为非阻塞赋值
      else
        rf_cp0[CAUSE] <= {16'b0, HWInt, 10'b0};  // 非阻塞赋值
    end
  end
endmodule