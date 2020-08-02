# 2020年新工科联盟-Xilinx暑期学校项目
## 项目名称：给ESP32增加FPU
## 项目简介
* **设计目的：** SEA-S7开发平台上的MCU即ESP32计算能力有限，只能完成一些简单的算术运算。为了提升ESP32的数据处理能力，需要用SEA-S7开发平台的FPGA部分为ESP32设计一个浮点处理单元（FPU），使ESP32具备硬件浮点数据处理的能力(四则运算)。
* **相关知识：** IEEE754标准、QSPI协议、ESP32侧QSPI端口的使用方法、FPGA端QSPI从机的RTL设计、ESP32固件使用和软件编程、Micropython串口工具的调试方法。
## 已实现功能
* ESP32与FPGA通过QSPI通信，将输入的两个十六进制32bit单精度浮点数经MicroPython串口工具调试端输入至ESP32，通过RAM交互数据至FPGA端，由编写好的FPU模块完成浮点数四则运算并将正确结果（一个十六进制32bit单精度浮点数）输出回ESP32并显示至串口调试界面。
## 小组成员
* 程跃龙
* 田熙
## 工具版本
* Vivado 2018.3
* flash_download_tools_v3.6.7
* uPyCraft_V1.0
## 板卡与芯片型号
* Spartan Edge Accelerator Board (SEA board)
* xc7s15ftgb196-1
## 外设
* 无
## 项目演示

## 仓库目录介绍
* images

* Sourcecode  
FPU.v  
FPU_tb.v  
qspi_addr.v  
qspi_slave.v  
QSPI_slave_tp.v  
* ExecutableFiles
存放bit文件
