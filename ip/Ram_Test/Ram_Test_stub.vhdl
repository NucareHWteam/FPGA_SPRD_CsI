-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
-- Date        : Tue Sep 10 16:24:46 2024
-- Host        : LAPTOP-14KJUI8Q running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Vproject_Vivado/1.sprd/CSI_FPGA/V1.0.0.0_DV5_Cs137tempcor_Gctable/HH300_Renewal.srcs/sources_1/ip/Ram_Test/Ram_Test_stub.vhdl
-- Design      : Ram_Test
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a15tcsg324-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Ram_Test is
  Port ( 
    clka : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 10 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 15 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end Ram_Test;

architecture stub of Ram_Test is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,wea[0:0],addra[10:0],dina[15:0],douta[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_2,Vivado 2018.3";
begin
end;
