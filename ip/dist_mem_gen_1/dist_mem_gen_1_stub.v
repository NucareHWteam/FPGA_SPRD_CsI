// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon May 20 14:40:00 2019
// Host        : kihun-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               g:/kihun_3/FPGA/Artix7/HH300_SPI_UART_XADC_RAM/HH300_SPI_UART_XADC_RAM.srcs/sources_1/ip/dist_mem_gen_1/dist_mem_gen_1_stub.v
// Design      : dist_mem_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a15tcsg324-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2018.3" *)
module dist_mem_gen_1(a, d, clk, we, spo)
/* synthesis syn_black_box black_box_pad_pin="a[12:0],d[15:0],clk,we,spo[15:0]" */;
  input [12:0]a;
  input [15:0]d;
  input clk;
  input we;
  output [15:0]spo;
endmodule
