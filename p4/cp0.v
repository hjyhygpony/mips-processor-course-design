module cp0(PC, DIn, HWInt, Sel, Wen, EXLSet, EXLClr, clk, rst, IntReq, epc, DOut);
  input [31:0] PC;       // use to save pc (usually pc+4)
  input [31:0] DIn;      // for mtc0,data from gpr[rt]
  input [5:0] HWInt;     // 6 hardwares send stop message
  input [4:0] Sel;       // (rd),use for mfc0/mtc0
  // Wen : rf_cp0's wr,use for mtc0. 
  // EXLSel : exl turn to 1
  // EXLClr : clear flag
  input Wen, EXLSet, EXLClr, clk, rst;
  
  output IntReq;//this is true zhongduan request
  // epc send pc to npc
  output [31:0] epc;
  output [31:0] DOut;   // for mfc0,data writing into gpr[rt]

  
 
  
  parameter [4:0] SR = 5'd12;
  parameter [4:0] CAUSE = 5'd13;
  parameter [4:0] EPC = 5'd14;
  parameter [4:0] PRID = 5'd15;
  
  // regfiles
  reg [31:0] rf_cp0 [31:0];
  
  //SR{16'b0, im, 8'b0, exl, ie}
  wire [15:10] im;// 6 hardwares able to stop
    
  wire exl;// flag prevent enter again
  wire ie; // whole enable(1) or disable(0)
  
  assign im = rf_cp0[SR][15:10];    
  assign exl = rf_cp0[SR][1];
  assign ie = rf_cp0[SR][0];
  
  
  // CAUSE = {16'b0, hwint, 10'b0}
  

  assign epc = rf_cp0[EPC]; // loading pcout of epc
  assign DOut = rf_cp0[Sel];  // dataout for mfc0
  
  assign IntReq = | (rf_cp0[CAUSE][15:10] & im) & ie & (~exl);
  
  integer i;
  initial begin
    for(i=0; i<32; i=i+1) rf_cp0[i]=0;
    rf_cp0[SR][15:10] = 6'b000001;  // im
    rf_cp0[SR][0] = 1'b1;           // ie
    rf_cp0[CAUSE][15:10] = 6'b000001;
    rf_cp0[PRID] = 32'h2307_1008;
  end
  
  always@(posedge clk) begin
    if(rst) begin
      for(i=0; i<32; i=i+1) rf_cp0[i]=0;
      rf_cp0[SR][15:10] = 6'b000001;  // im
      rf_cp0[SR][0] = 1'b1;           // ie=1
      rf_cp0[CAUSE][15:10] = 6'b000001;
      rf_cp0[PRID] = 32'h2307_1008;
    end
  end
  
  always@(posedge clk)  begin
    // CAUSE is read only
    if(Wen & (Sel != CAUSE))//can write and no exception,all fit
      rf_cp0[Sel] <= DIn;
		
    else if(EXLSet) begin // exl turn to 1
      rf_cp0[SR][1] <= 1'b1;//exl=1
      rf_cp0[EPC] <= PC;  // pc+4 put into epc waiting for pushing to npc
		
    end
    else if(EXLClr) begin // clear flag
      rf_cp0[SR][1:0] = 2'b01; //exl=0 ie=1   
    end 
    else
      rf_cp0[CAUSE] <= {16'b0, HWInt, 10'b0}; //latch
  end
  
  // CAUSE
  always@(posedge clk)
    rf_cp0[CAUSE] <= {16'b0, HWInt, 10'b0};

//{im, exl, ie} <= {DIn[15:10], DIn[1], DIn[0]}

endmodule
