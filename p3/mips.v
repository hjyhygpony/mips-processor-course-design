module mips(clk, rst, dev1_rd,seg_data1,sel1,seg_data2,sel2,irout);
  input   clk;
  input   rst;
  input [31:0] dev1_rd;
  output [7:0] seg_data1;    // 左侧4位数码管段选
  output [3:0] sel1;         // 左侧位选（低电平有效）
  output [7:0] seg_data2;    // 右侧4位数码管段选
  output [3:0] sel2;         // 右侧位选（低电平有效）
  output irout;
  // wires
  wire [31:0] pcout;
  
  wire [1:0] npcop;
  wire zero;
  wire [31:0] nextpc;
  wire [31:0] pc_4, epc;
  wire eret;
  
  wire [1:0] gprsel;
  wire [4:0] m1out;
  
  wire [2:0] wdsel;
  wire [31:0] aluo, dmout, m2out;
  
  wire bsel;
  wire [31:0] bo, imm32, m3out;
  
  wire[31:0] m4out;
  
  wire gprwr;
  wire [31:0] busa, busb;
  
  wire dmwr;
  
  wire [1:0] extop;
  wire [31:0] extout;
  
  wire [2:0] aluop;
  wire overflow;
  
  wire [5:0] opcode, funct;
  
  wire pcwr, irwr;
  wire [31:0] irin, irout;
  wire [31:0] arout, brout, aluoutout, drout;
  wire islb,issb, IntReq, cp0_wen, EXLSet, EXLClr, IntPc;

  wire [31:0] cp0out;

  wire [31:0] prrd, dev0_rd, dev_wd, dev_addr;
  wire bridge_wen, IRQ, dev0_we, dev2_we;
  wire [5:0] HWInt;
  
  wire clkip,clk1,clk10,clk100,clk1000,clk3000,clk_100;
  /*
  module pc(clk, pcwr, pcin, pcout); 
module npc(pcin, rd1, npcop, zero, imm, nextpc, pc_4, rst, epc, ERET, IntReq); //////////
  module im_1k( addr, dout ) ;
  module ir(irwr, irin, irout, clk);
  module m1(gprsel, rt, rd, m1out);
  module module m2(wdsel, aluo, dmout, pc_4, m2out, cp0out);
  module m3(bsel, bo, imm32, m3out);
  module gpr(clk, reset, regwrite,m1out, m2out, rs, rt, busa, busb);
  module ar(clk, arin, arout);
  module br(clk, brin, brout);
  module dm_1k( addr, din, we, clk, dout , islb, issb) ;
  module dr(clk, drin, drout);
  module ext(imm16, extop, out);
  module alu(A, B, aluctr, zero, overflow, out);
  module aluout(clk, aluoutin, aluoutout);
  module controller(clk, opcode, funct, aluop, gprsel, gprwr, extop, dmwr,
                   wdsel, npcop, bsel, overflow, rst, pcwr, irwr, zero,islb,issb,
                   MF,ismfc0, IntReq, cp0_wen, bridge_wen, EXLSet, EXLClr, IntPc);
  module outputDEV(clk, en, addr, din, dout);
  module timer(CLK_I, RST_I, ADD_I, WE_I, DAT_I, DAT_O, IRQ);
  module m4(drout, prrd, m4out, ismfc0);
  module cp0(PC, DIn, HWInt, Sel, Wen, EXLSet, EXLClr, clk, rst, IntReq, epc, DOut);
  module bridge(praddr, prwd, prrd, dev0_rd, dev1_rd, dev2_rd, 
            dev_wd, dev_addr, wen, dev0_we, dev2_we, hwint, irq);
				
  
 */
 clkip ipheclk
   (// Clock in ports
    .CLK_IN1(clk),      // IN
    // Clock out ports
    .CLK_OUT1(clkip));  
 
 
 fenpinqi(clkip,~rst,clk1,clk10,clk100,clk1000);
 
 
  pc pc(clk10, pcwr, nextpc, pcout);
  
  npc npc(pcout, busa, npcop, zero, irout[25:0], nextpc, pc_4, ~rst, epc, EXLClr, IntPc);
  
  im_1k im_1k(clkip,pcout[12:0], irin);
  
  ir ir(irwr, irin, irout, clk10);
  
  m1 m1(gprsel, irout[20:16], irout[15:11], m1out);
  
  m2 m2(wdsel, aluoutout, m4out, pc_4, m2out, cp0out);
  
  m3 m3(bsel, brout, extout, m3out);
  
  m4 m4(drout, prrd, m4out, aluoutout);
  
  gpr gpr(clk10, ~rst, gprwr, m1out, m2out, irout[25:21], irout[20:16], busa, busb);
  
  ar ar(clk10, busa, arout);
  
  br br(clk10, busb, brout);
  
 // dm_1k dm_1k(aluoutout[13:0], brout, dmwr, clk, dmout, islb, issb);
  
  dr dr(clk10, dmout, drout);
  
  ext ext(irout[15:0], extop, extout);
  
  alu alu(arout, m3out, aluop, zero, overflow, aluo);
  
  
  
  
  
  aluout aluout(clk10, aluo, aluoutout);
  
  controller controller(clk10, irout[31:26], irout[5:0], aluop, gprsel, gprwr, extop, dmwr,
                        wdsel, npcop, bsel, overflow, ~rst, pcwr, irwr, zero, islb, issb,
                        irout[25:21], IntReq, cp0_wen, bridge_wen, EXLSet, EXLClr, IntPc);  
  
  outputDEV outputDEV(clk10, dev2_we, dev_addr[3:2], dev_wd, dev2_rd,led);
  
  timer timer(clk10, ~rst, dev_addr[3:2], dev0_we, dev_wd, dev0_rd, IRQ);
                                          // rd
  cp0 cp0(pcout, brout, HWInt, irout[15:11], cp0_wen, EXLSet, EXLClr, clk10, ~rst, IntReq, epc, cp0out);
  
  bridge bridge (aluoutout, brout, prrd, dev0_rd, dev1_rd, dev2_rd, dev_wd, dev_addr, bridge_wen, dev0_we, dev2_we, HWInt, IRQ);
  
  /*Print Print1(.clk(clk1000), .clk100(clk100),.reset(~rst), .in(dev2_rd), .out(pcout), .D1_seg(seg_data2), .D0_seg(seg_data1),  .D1_com(sel2), .D0_com(sel1));	
	*/
 dig_seg  left_display (
        .clk(clk1000),
        .rst(rst),
        .sw_in(irout),           // 直接使用din输入
        .pinOut(seg_data1),    // 左侧段选
        .sel(sel1)             // 左侧位选
    );
	 
	 dig_seg  right_display (
        .clk(clk1000),
        .rst(rst),
        .sw_in(irout), // 来自outputDEV
        .pinOut(seg_data2),       // 右侧段选
        .sel(sel2)                // 右侧位选
    );
	 
			
endmodule
