// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Tue Sep 10 16:24:46 2024
// Host        : LAPTOP-14KJUI8Q running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Vproject_Vivado/1.sprd/CSI_FPGA/V1.0.0.0_DV5_Cs137tempcor_Gctable/HH300_Renewal.srcs/sources_1/ip/Ram_Test/Ram_Test_stub.v
// Design      : Ram_Test
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a15tcsg324-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module Ram_Test(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[10:0],dina[15:0],douta[15:0]" */;
  input clka;
  input [0:0]wea;
  input [10:0]addra;
  input [15:0]dina;
  output [15:0]douta;
endmodule
