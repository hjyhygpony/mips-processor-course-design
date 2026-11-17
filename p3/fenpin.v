module fenpinqi1(clkin, rst, clk1, clk10, clk100, clk1000, clk3000);
    input clkin, rst;
    output clk1, clk10, clk100, clk1000, clk3000;
    reg clk1, clk10, clk100, clk1000, clk3000;
    reg [31:0] cnt1, cnt10, cnt100, cnt1000, cnt3000 = 0;

    parameter N1 = 50000000;      // 1Hz (假设主时钟50MHz)
    parameter N10 = 5000000;      // 10Hz
    parameter N100 = 500000;      // 100Hz
    parameter N1000 = 50000;      // 1000Hz
    parameter N3000 = 16667;      // 3000Hz (50000000/(3000*2) ≈ 8333.33 -> 取整8333)

    always @(posedge clkin or negedge rst)
    if(!rst) begin
        cnt1 <= 1'b0;
        cnt10 <= 1'b0;
        cnt100 <= 1'b0;
        cnt1000 <= 1'b0;
        cnt3000 <= 1'b0;
        clk1 <= 1'b0;
        clk10 <= 1'b0;
        clk100 <= 1'b0;
        clk1000 <= 1'b0;
        clk3000 <= 1'b0;
    end
    else begin
        // 1 Hz
        if (cnt1 < N1/2 - 1) cnt1 <= cnt1 + 1'b1;
        else begin
            cnt1 <= 1'b0;
            clk1 <= ~clk1;
        end
        
        // 10 Hz
        if (cnt10 < N10/2 - 1) cnt10 <= cnt10 + 1'b1;
        else begin
            cnt10 <= 1'b0;
            clk10 <= ~clk10;
        end
        
        // 100 Hz
        if (cnt100 < N100/2 - 1) cnt100 <= cnt100 + 1'b1;
        else begin
            cnt100 <= 1'b0;
            clk100 <= ~clk100;
        end
        
        // 1000 Hz
        if (cnt1000 < N1000/2 - 1) cnt1000 <= cnt1000 + 1'b1;
        else begin
            cnt1000 <= 1'b0;
            clk1000 <= ~clk1000;
        end
        
        // 3000 Hz
        if (cnt3000 < N3000/2 - 1) cnt3000 <= cnt3000 + 1'b1;
        else begin
            cnt3000 <= 1'b0;
            clk3000 <= ~clk3000;
        end
    end
endmodule