// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Thu Feb 13 09:53:47 2020
// Host        : DESKTOP-FGV9L03 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/hwang/Desktop/HH300_4th_Voltage_Amp_Base_RC/HH300_4th_Voltage_Amp_Base_RC.srcs/sources_1/ip/c_addsub_0/c_addsub_0_sim_netlist.v
// Design      : c_addsub_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a15tcsg324-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "c_addsub_0,c_addsub_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_12,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module c_addsub_0
   (A,
    B,
    CLK,
    CE,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [13:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [13:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [13:0]S;

  wire [13:0]A;
  wire [13:0]B;
  wire CE;
  wire CLK;
  wire [13:0]S;
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
  (* c_a_width = "14" *) 
  (* c_add_mode = "1" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "1" *) 
  (* c_b_value = "00000000000000" *) 
  (* c_b_width = "14" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "14" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_addsub_0_c_addsub_v12_0_12 U0
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

(* C_ADD_MODE = "1" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "1" *) 
(* C_A_WIDTH = "14" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "1" *) (* C_B_VALUE = "00000000000000" *) 
(* C_B_WIDTH = "14" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "14" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_12" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module c_addsub_0_c_addsub_v12_0_12
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
  input [13:0]A;
  input [13:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [13:0]S;

  wire \<const0> ;
  wire [13:0]A;
  wire [13:0]B;
  wire CE;
  wire CLK;
  wire [13:0]S;
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
  (* c_a_width = "14" *) 
  (* c_add_mode = "1" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "1" *) 
  (* c_b_value = "00000000000000" *) 
  (* c_b_width = "14" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "14" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  c_addsub_0_c_addsub_v12_0_12_viv xst_addsub
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
Tb1qFTRnD4uwcCuvy3Gk1bxBEfWT3/PF90Pl2anKUFPBo/1wwPa+qYNnJb+lk5EZndUFisMz4vaq
vfeww6/MV24+8zEVI8brKuhsgs4i9D56E90JSt3G2gxAz1BJ9qUmXITERCoMoJ6M3lXbEuy9Qg8u
2bLZOvbKQiZUkFy5uexc7ORJFedXwNjbG3ukY2m3rC7HBj46dCmbpAO2GhI5D8pweOZWRAGP/+ij
STLwsXGLNaqQatYer/+EYiVtU2yf8k20HIAgN70vN0UWJS4cmAeNDYGWJpLYYcU4BZRDQinsuIiQ
KO+syP4PleJeNZaB9zsbrF7CaYpfkpvekndPkA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
e2kumkhGL5H3JDMrCJ9zDu+T/Jo74DqouqIdkfwigvD4UWmPTDI9cZfdjQUqA2rYkodhmZa6Gqi0
QKTVprDO7XIAOb26wnzJRPHj5/7yw7wdb4YbJSqqX0obpD+IQ7toSCScW5uX47WgQhyV0o6RRhnl
3AYJZCgtcpwLkRE7ryZ4/jjeXTTZfZTkaTD61hfn2LQYGuYJFOG4Nb7gBa2Ez2ggkaI7ewCAl0RG
qudQI4oDaJuH9dNrH64h+70v5EUvtxLhCOWiWY5B9AVb1gsG8zpuiVylPR7M1LEnjAyzOsBZeC3g
JmBDAzJiULewX3NAvV2OABJEr/oLNSqF1KuzSw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 12384)
`pragma protect data_block
+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
LgY8qfXNlkRFzBZgLM4A
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
