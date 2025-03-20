// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu Feb 13 10:32:44 2020
// Host        : DESKTOP-FGV9L03 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/hwang/Desktop/HH300_4th_Voltage_Amp_Base_RC/HH300_4th_Voltage_Amp_Base_RC.srcs/sources_1/ip/c_addsub_1/c_addsub_1_stub.v
// Design      : c_addsub_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a15tcsg324-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_addsub_v12_0_12,Vivado 2018.3" *)
module c_addsub_1(A, B, CLK, CE, S)
/* synthesis syn_black_box black_box_pad_pin="A[17:0],B[17:0],CLK,CE,S[17:0]" */;
  input [17:0]A;
  input [17:0]B;
  input CLK;
  input CE;
  output [17:0]S;
endmodule
