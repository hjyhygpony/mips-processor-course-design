module m3(bsel, gprout, imm32, m3out);
  input bsel;
  input [31:0] gprout, imm32;
  output reg [31:0] m3out;
  
  always@(*)
    case(bsel)
      1'b0:
        m3out = gprout;
      1'b1:
        m3out = imm32;
      default:
        m3out = 32'b0;
    endcase
endmodule
