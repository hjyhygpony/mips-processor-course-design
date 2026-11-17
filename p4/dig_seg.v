module dig_seg (
    input clk,          // 时钟（建�0MHz-100MHz�
    input rst,          // 复位（高电平有效�
    input [31:0] sw_in, // 32位拨动开关输�
    output reg [7:0] pinOut, // 段选信号（顺序：dp, g, f, e, d, c, b, a�
    output reg [3:0] sel     // 位选信号（低电平有效）
);

 

    // 分频计数器（动态扫描频率约1kHz�
    reg [15:0] cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) cnt <= 0;
        else cnt <= cnt + 1;
    end
    wire scan_clk = cnt[15]; // �63Hz @50MHz

    // 数码管位选计数器�-3循环�
    reg [1:0] digit_sel;
    always @(posedge scan_clk or posedge rst) begin
        if (rst) digit_sel <= 0;
        else digit_sel <= digit_sel + 1;
    end

    // 位选信号（低电平有效）
    always @(*) begin
        case (digit_sel)
            2'b00: sel = 4'b1110; // ��
            2'b01: sel = 4'b1101; // ��
            2'b10: sel = 4'b1011; // ��
            2'b11: sel = 4'b0111; // ��
        endcase
    end

    // �2位输入中提取当前位的4位BCD�
    reg [3:0] bcd;
    always @(*) begin
        case (digit_sel)
            2'b00: bcd = sw_in[3:0];   // 显示最��
            2'b01: bcd = sw_in[7:4];
            2'b10: bcd = sw_in[11:8];
            2'b11: bcd = sw_in[15:12]; // 显示最�位（可根据需要调整）
        endcase
    end

    // 7段译码逻辑（支持共�共阳配置�
    always @(*) begin
  
            case (bcd)
                /*4'h0: pinOut = 8'b00111111; // 0
                4'h1: pinOut = 8'b00000110; // 1
                4'h2: pinOut = 8'b01011011; // 2
                4'h3: pinOut = 8'b01001111; // 3
                4'h4: pinOut = 8'b01100110; // 4
                4'h5: pinOut = 8'b01101101; // 5
                4'h6: pinOut = 8'b01111101; // 6
                4'h7: pinOut = 8'b00000111; // 7
                4'h8: pinOut = 8'b01111111; // 8
                4'h9: pinOut = 8'b01101111; // 9
                4'hA: pinOut = 8'b01110111; // A
                4'hB: pinOut = 8'b01111100; // b
                4'hC: pinOut = 8'b00111001; // C
                4'hD: pinOut = 8'b01011110; // d
                4'hE: pinOut = 8'b01111001; // E
                4'hF: pinOut = 8'b01110001; // F
					
*/					
					 4'h0:pinOut= 8'b11111100; // ��ʾ����0
                4'h1:pinOut= 8'b01100000; // ��ʾ����1
                4'h2:pinOut= 8'b11011010; // ��ʾ����2
                4'h3:pinOut= 8'b11110010; // ��ʾ����3
                4'h4:pinOut= 8'b01100110; // ��ʾ����4
                4'h5:pinOut= 8'b10110110; // ��ʾ����5
                4'h6:pinOut= 8'b10111110; // ��ʾ����6
                4'h7:pinOut= 8'b11100100; // ��ʾ����7
                4'h8:pinOut= 8'b11111110; // ��ʾ����8
                4'h9:pinOut= 8'b11110110; // ��ʾ����9
					 4'hA:pinOut= 8'b11101110; // ��ʾ����A
                4'hB:pinOut= 8'b00111110; // ��ʾ����B
                4'hC:pinOut= 8'b10011100; // ��ʾ����C
                4'hD:pinOut= 8'b01111010; // ��ʾ����D
                4'hE:pinOut= 8'b10011110; // ��ʾ����E
                4'hF:pinOut= 8'b10001110; // ��ʾ����F
					 
					 
        
                default: pinOut = 8'b00000000; // 全灭
            endcase
        end

endmodule
