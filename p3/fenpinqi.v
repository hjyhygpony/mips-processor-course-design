module fenpinqi(
    input clkin,     // 5MHz主时钟输�
    input rst,       // 复位信号(低电平有�
    output reg clk1, // 1Hz输出
    output reg clk10, // 10Hz输出
    output reg clk100, // 100Hz输出
    output reg clk1000, // 1kHz输出
    output reg clk3000  // 3kHz输出
);
    // 分频参数计算(基于5MHz主时�
    parameter N1 = 2500000;      // 1Hz = 5MHz/(2*1Hz)
    parameter N10 = 250000;      // 10Hz = 5MHz/(2*10Hz)
    parameter N100 = 25000;      // 100Hz = 5MHz/(2*100Hz)
    parameter N1000 = 2500;      // 1kHz = 5MHz/(2*1000Hz)
    parameter N3000 = 833;       // 3kHz = 5MHz/(2*3000Hz) �833.33 -> 取整833

    reg [31:0] cnt1, cnt10, cnt100, cnt1000, cnt3000;

    always @(posedge clkin or posedge rst) begin
        if(rst) begin
            // 异步复位
            cnt1 <= 0;
            cnt10 <= 0;
            cnt100 <= 0;
            cnt1000 <= 0;
            cnt3000 <= 0;
            clk1 <= 0;
            clk10 <= 0;
            clk100 <= 0;
            clk1000 <= 0;
            clk3000 <= 0;
        end
        else begin
            // 1Hz分频
            if (cnt1 < N1-1) cnt1 <= cnt1 + 1;
            else begin
                cnt1 <= 0;
                clk1 <= ~clk1;
            end
            
            // 10Hz分频
            if (cnt10 < N10-1) cnt10 <= cnt10 + 1;
            else begin
                cnt10 <= 0;
                clk10 <= ~clk10;
            end
            
            // 100Hz分频
            if (cnt100 < N100-1) cnt100 <= cnt100 + 1;
            else begin
                cnt100 <= 0;
                clk100 <= ~clk100;
            end
            
            // 1kHz分频
            if (cnt1000 < N1000-1) cnt1000 <= cnt1000 + 1;
            else begin
                cnt1000 <= 0;
                clk1000 <= ~clk1000;
            end
            
            // 3kHz分频
            if (cnt3000 < N3000-1) cnt3000 <= cnt3000 + 1;
            else begin
                cnt3000 <= 0;
                clk3000 <= ~clk3000;
            end
        end
    end
endmodule