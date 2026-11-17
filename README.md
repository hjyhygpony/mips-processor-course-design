# MIPS Processor Course Design

计算机组成原理课程设计，使用 Verilog 逐步实现一个 MIPS 处理器系统。

项目按 `p1`～`p4` 分为四个阶段：

| 阶段 | 内容 |
|---|---|
| `p1` | 单周期 MIPS 处理器 |
| `p2` | 多周期 MIPS 处理器 |
| `p3` | 支持设备与中断的 MIPS 微系统 |
| `p4` | FPGA 版本 MIPS 微系统 |

## 已实现模块

- ALU 与 ALUOut
- 通用寄存器堆 GPR
- 指令存储器 IM
- 数据存储器 DM
- 指令寄存器 IR
- 数据寄存器 DR
- 程序计数器 PC / NPC
- 立即数扩展 EXT
- 主控制器 Controller
- 分支控制 BR
- CP0 与中断控制
- 定时器 Timer
- 输入/输出设备
- 数码管与分频模块
- MIPS Testbench

## 技术栈

- Verilog HDL
- Quartus II
- ModelSim
- Xilinx ISE
- MIPS32 指令子集

## 项目结构

```text
mips-processor-course-design/
├─ p1/    # 单周期处理器
├─ p2/    # 多周期处理器
├─ p3/    # 设备与中断
├─ p4/    # FPGA 实现
└─ README.md
```

每个阶段保留：

- Verilog 源文件
- Testbench
- Quartus 工程文件
- MIPS 汇编测试程序
- ModelSim 工程和波形脚本

## 运行方式

### Quartus

1. 使用 Quartus 打开对应阶段的 `.qpf` 工程。
2. 重新编译工程。
3. 根据所用开发板修改 `.qsf` 中的引脚约束。
4. 将测试程序转换为指令存储器初始化文件后下载到 FPGA。

### ModelSim

1. 打开对应 `.mpf` 工程，或者手动添加 `.v` 文件。
2. 运行对应的 Testbench。
3. 使用 `wave.do` 加载波形。

### MIPS 测试程序

各阶段保留 `.asm` 汇编文件和转换后的 `.txt` 指令数据。示例包括：

- 算术与逻辑指令
- Load/Store
- 分支与跳转
- 中断和定时器测试
- 设备输入输出测试

## 说明

- 仓库不包含 Quartus、ModelSim、ISE 安装包、License、破解补丁和 FPGA 工程构建缓存。
- `p4` 已从原始大目录中抽取实际工程源文件，避免把 ISE 安装文件和课程资料一起提交。
- 不同开发板的引脚约束不同，直接编译前需要根据板卡型号调整 `.qsf` / `.ucf`。
- 本项目是课程设计实现，不是完整 MIPS32 处理器；支持范围和指令集以各阶段源码和测试程序为准。
