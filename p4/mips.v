module mips(clk, rst);
  input   clk;
  input   rst;
  // wires
  wire [31:0] dev1_rd_sim; // 仿真输入值

  
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

  wire [31:0] prrd, dev0_rd, dev2_rd, dev_wd, dev_addr;
  wire bridge_wen, IRQ, dev0_we, dev2_we;
  wire [5:0] HWInt;
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
 
  pc pc(clk, pcwr, nextpc, pcout);
  
  npc npc(pcout, busa, npcop, zero, irout[25:0], nextpc, pc_4, rst, epc, EXLClr, IntPc);
  
  im_1k im_1k(pcout[12:0], irin);
  
  ir ir(irwr, irin, irout, clk);
  
  m1 m1(gprsel, irout[20:16], irout[15:11], m1out);
  
  m2 m2(wdsel, aluoutout, m4out, pc_4, m2out, cp0out);
  
  m3 m3(bsel, brout, extout, m3out);
  
  m4 m4(drout, prrd, m4out, aluoutout);
  
  gpr gpr(clk, rst, gprwr, m1out, m2out, irout[25:21], irout[20:16], busa, busb);
  
  ar ar(clk, busa, arout);
  
  br br(clk, busb, brout);
  
  dm_1k dm_1k(aluoutout[13:0], brout, dmwr, clk, dmout, islb, issb);
  
  dr dr(clk, dmout, drout);
  
  ext ext(irout[15:0], extop, extout);
  
  alu alu(arout, m3out, aluop, zero, overflow, aluo);
  
  
  
  
  
  aluout aluout(clk, aluo, aluoutout);
  
  controller controller(clk, irout[31:26], irout[5:0], aluop, gprsel, gprwr, extop, dmwr,
                        wdsel, npcop, bsel, overflow, rst, pcwr, irwr, zero, islb, issb,
                        irout[25:21], IntReq, cp0_wen, bridge_wen, EXLSet, EXLClr, IntPc);  
  
  outputDEV outputDEV(clk, dev2_we, dev_addr[3:2], dev_wd, dev2_rd);
  inputDEV inputDEV(clk, dev1_we, dev_addr[3:2], dev_wd, dev1_rd);
  
  timer timer(clk, rst, dev_addr[3:2], dev0_we, dev_wd, dev0_rd, IRQ);
                                          // rd
  cp0 cp0(pcout, brout, HWInt, irout[15:11], cp0_wen, EXLSet, EXLClr, clk, rst, IntReq, epc, cp0out);
  
  bridge bridge (aluoutout, brout, prrd, dev0_rd, dev1_rd, dev2_rd, dev_wd, dev_addr, bridge_wen, dev0_we, dev1_we,dev2_we, HWInt, IRQ);
				
				
endmodule
