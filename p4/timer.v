module timer(
    input CLK_I,          // 时钟信号
    input RST_I,          // 复位信号（高有效）
    input [3:2] ADD_I,    // 寄存器选择地址
    input WE_I,           // 写使能信号
    input [31:0] DAT_I,   // 写入数据总线
    output [31:0] DAT_O,  // 读取数据总线
    output IRQ            // 中断请求信号
);

    // 寄存器定义
    reg [31:0] CTRL;      // 控制寄存器
    reg [31:0] PRESET;    // 预设值寄存器
    reg [31:0] COUNT;     // 当前计数值寄存器

    // 控制信号分解
    wire im = CTRL[3];     // 中断使能位 (1:使能, 0:禁用)
    wire [1:0] mode = CTRL[2:1];  // 工作模式选择
    wire enable = CTRL[0]; // 计数使能 (1:计数, 0:停止)

    // 中断生成逻辑（单次模式下计数到0且中断使能时触发）
    assign IRQ = ((COUNT == 32'b0) & im & (mode == 2'b00)) ? 1 : 0;

    // 数据输出逻辑（根据ADD_I选择输出对应寄存器值）
    assign DAT_O = (ADD_I == 2'b00) ? CTRL :
                  (ADD_I == 2'b01) ? PRESET : 
                  COUNT;

    // 初始化（仅仿真使用）
    initial begin
        CTRL = 0;
        PRESET = 0;
        COUNT = 0;
    end

    // 主控制逻辑（时钟上升沿触发）
    always @(posedge CLK_I) begin
        if (RST_I) begin
            // 同步复位
            CTRL <= 0;
            PRESET <= 0;
            COUNT <= 0;
        end
        else if (WE_I) begin
            // 寄存器写入逻辑
            case (ADD_I)
                2'b00: CTRL <= DAT_I;       // 写入控制寄存器
                2'b01: begin                // 写入预设值寄存器
                    PRESET <= DAT_I;
                    COUNT <= DAT_I;          // 同时更新当前计数值
                end
                2'b10: COUNT <= DAT_I;      // 直接写入当前计数值
                default: $display("[TIMER] Illegal register address");
            endcase
        end
        else if (enable) begin
            // 计数逻辑
            if (COUNT > 0) begin
                COUNT <= COUNT - 1;        // 正常递减计数
            end
            else if (COUNT == 0) begin
                // 计数到0时的处理
                case (mode)
                    2'b00: begin          // 模式0：单次计数
                        $display("[TIMER] Count reached 0 in one-shot mode");
                        // 保持COUNT=0，等待重新配置
                    end
                    2'b01: begin          // 模式1：自动重载
                        COUNT <= PRESET;  // 自动重载预设值
                        $display("[TIMER] Auto-reload with preset value: %h", PRESET);
                    end
                   
                endcase
            end
        end
    end

    // 模式说明注释
    /*
     * 工作模式定义:
     * mode[1:0] = 2'b00: 单次模式 (计数到0停止)
     * mode[1:0] = 2'b01: 自动重载模式 (计数到0自动重载PRESET值)

     *
     * 控制寄存器(CTRL)位定义:
     * bit[31:4]: 保留
     * bit[3]: 中断使能 (1:使能, 0:禁用)
     * bit[2:1]: 工作模式选择
     * bit[0]: 计数使能 (1:计数, 0:停止)
     */

endmodule