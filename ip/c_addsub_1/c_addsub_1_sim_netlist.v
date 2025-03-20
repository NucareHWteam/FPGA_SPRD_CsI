// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu Feb 13 10:32:44 2020
// Host        : DESKTOP-FGV9L03 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/hwang/Desktop/HH300_4th_Voltage_Amp_Base_RC/HH300_4th_Voltage_Amp_Base_RC.srcs/sources_1/ip/c_addsub_1/c_addsub_1_sim_netlist.v
// Design      : c_addsub_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a15tcsg324-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c_addsub_1,c_addsub_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module c_addsub_1
   (A,
    B,
    CLK,
    CE,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [17:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [17:0]S;

  wire [17:0]A;
  wire [17:0]B;
  wire CE;
  wire CLK;
  wire [17:0]S;
  wire NLW_U0_C_OUT_UNCONNECTED;

  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* c_a_type = "1" *) 
  (* c_a_width = "18" *) 
  (* c_add_mode = "0" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "1" *) 
  (* c_b_value = "000000000000000000" *) 
  (* c_b_width = "18" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "18" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_addsub_1_c_addsub_v12_0_12 U0
       (.A(A),
        .ADD(1'b1),
        .B(B),
        .BYPASS(1'b0),
        .CE(CE),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_U0_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "0" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "1" *) 
(* C_A_WIDTH = "18" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "1" *) (* C_B_VALUE = "000000000000000000" *) 
(* C_B_WIDTH = "18" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "18" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_12" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module c_addsub_1_c_addsub_v12_0_12
   (A,
    B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    C_OUT,
    S);
  input [17:0]A;
  input [17:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [17:0]S;

  wire \<const0> ;
  wire [17:0]A;
  wire [17:0]B;
  wire CE;
  wire CLK;
  wire [17:0]S;
  wire NLW_xst_addsub_C_OUT_UNCONNECTED;

  assign C_OUT = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* c_a_type = "1" *) 
  (* c_a_width = "18" *) 
  (* c_add_mode = "0" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "1" *) 
  (* c_b_value = "000000000000000000" *) 
  (* c_b_width = "18" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "18" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_addsub_1_c_addsub_v12_0_12_viv xst_addsub
       (.A(A),
        .ADD(1'b0),
        .B(B),
        .BYPASS(1'b0),
        .CE(CE),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_xst_addsub_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
INaBf8vh5mCmDzf2yp77pxZAxQdyEQiT/vG2dEgvrFjseUnGc6ldwH4JvdnpZSpdf/ihioPyMNjl
u6ooyzv5TA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
S5XIZZtuFR/MZffuhwdnvE3H9oRWM4uXoaGZTa/Dyk62O+Wa0v41pjmZELCiR7uodZPFQfykZ6K9
2ZDMu8dB3afQRMs5lnd/53M1b9ke+MNEeZ/wzjUcsJghubnEAwzdWeW/0tlqST1WD9B/KCxYqwH5
Gj6IZTTFHAXcaVhnCT8=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CM6IcdzP0PbD6yMSqylmi4JE2qpmxiNeI+prjGwJiD8e3Xsynu3PbGKJAOpOxtR1hT/3mpBcx1Rz
Fkz0QBh4wtE8fiziv1i+xi8T6cqC8ClamjrpZ//sn6dh7NvwSYik14MlwVuei4DZoZJZF63aoPUn
RXkQ13wtK+MkYKBcPVSZMFZmaCU6jMMBYclXzvRG1JqqZoa7mWFTeFZePUTXG7Wo12QaZ8GUi0AV
UIshoN25yn5e2Xr3FyuEtm5AvsZb+iLsgLeHBtKBnsVaHQphicgqwgwv6MQQF6ZNBgU/aACfibDS
3+n/mMMm8k1cj2bW6VCi7a+c8LmCf81NlJuLww==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ehl0CusS7+JNGq6HfhyaBMy68nccIdIGqixoEztEZfkCpXuUYsdqw6G9MIJdWdu0Ck2acV7K6IVg
rzb8/bNaDDVWp48kupToegTkOdwDkCejEqppido4BkJ+iEkjPniz+aJHlOlOwmauETy2hCMuuC57
oWDprzGWlsqbCjqzKrXmPYm6fNdcOa2DiOYstQaMFNbPU2ccrbLJAiYMHNDqtPNqWxKBsD67kiGf
2eOneDOmdmy7YkNsL+cx8MJc3BVUsYBrpAEsGyFMkmX8a8nYz8R/wlFQFGQAd/t5XrfxFNI58mj1
AHXbcAMhGKVq9YdKeU/vSXY/NwMqp12xJ1nUaw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
h/qRAwiPuqY/Zg/QWqbaYm8xWTi9SshYuPzyL0UME9ZDDF+C2CyGAugh9HzMdD0kZmT94TKmBgLR
dKP28nlE8VCCU5rvbjKxfn/wNtNKHCvZ1hns8CF7+pGuelhxGvXNmYKFw5co8+4grYFaDXeoZZR6
S5sjvhqtSVD3+qq4vYWRjT2Y/yes7L9dRsLq2D3iZ4xjgVHuIbOQLT/EUKW+9iYudT9Uy6YTwB+5
mSb0QK3YfZdGwZyXB4S3mdF9vNQHdW/rnACq3yngF+lprNkh3ooQKdGqtxtz8KSQxNZOAFE+koOw
h00o7AKpvDAp3uNguLvnNJH3rugOhh95b8Jatw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
TsA04vIYHDZne2CBj5bWCBFH4MtNoFDCn/3DNEi0BwutuUf+X+lD9kAO3kl352WHjQbF79Ssm+PT
fCYpODgWdxSVbzaHFpITxCQ4HcIJhUeW5PC5tw09Tand68D6eg84qRguH+llbb5jdGJkJeTCf+Mx
pupkkLiDvNyTYWe+nqw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rx9hgQkvaJJTJJcTjGFW1DrrWiT+xanrcMvFn0Z3KRXlZvf+SE7IQgGCiP7ZDA6T5z1Zv5nzS4h5
cVi+CvwC9UMZRWmLDAjzASJ2nx1g9BjbYe2vHAUmyurIiR6LSigTeM/9TlMv+fFwJbqwuH6FJ3/z
Vl4tIMk4NrqkMn/riOG87SjhesepM6kcQOBgDGzLTG14z3qeZG8OPzxgApfyubmX4qdD1oTgGm2u
Q4mQfFxEye6Jqkn4Rzjhifs/ieNYomHlK7R2/72QJj5j0WyYBIhvO+09izz299Z54ZP2ZXaRMfDT
lU4lQNqQU14PX9Yk9p7sy2PnK4vTwwF0CFIgSQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SDukD/soPmVBkvxZNt7F+AGYdV87HsM9Gliukc/1RnCkByRNGsUBgs0A7SEq2aQStWYoF4QOgBLf
LJX6wD90HKLCIH8FRtw7WzaZUnYA0WvJ7eM70+P2gQHont64b6qafZx2uRvRDRsLn4V0DRFeILMn
miTFnagOm8+mNSJzq5bQhWrO9YK2Ucpb0vCdk4BTGjzPKH+V4q2zA+B93fKReVhb5jo+UUYnvXn4
RLIHCO6OifqR3lp/K8Ux1X02A8K1ifDU3qgBSdcw70n7SG0bF6n5BAlgbOXUiHQoD+D8X5m7GhB0
cV5LJFrtfTTAS+f4n7Dmcn23Vr5S8sX8512Izg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QmSE6cCCNJfx7INglZznEh2ntpaxBspDPmGmnzAnr10vjVE0P9O/9hNbuosb33GcQrlG+PHo+qCP
MYXLK18shE2lpv6ykl9zufgrffYgY+nZOyOkQ9xUg8aj+vZmpMN7YXJoI9Qhd2dFyD0Oxs/TO1Z3
GsiHbDpXIpTEvC39DrKGljhAbGWDKiHn9/9suaM2ppgrQovm53uZ/2uvx3vASlvyNBNvGWo7MxU5
CnLlzeGl9bRomXXF/j0qoSE7ZFyO4hnvdwvHpa6Aw3FKoHgjRWVa9jUE4gIx226WstoigxqVWWp7
n+Oa4SbzC6xCTr0rfFFsJhAqU8qZ81BEwwK2XA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 14928)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
