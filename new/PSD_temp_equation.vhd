----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/06/01 14:24:10
-- Design Name: 
-- Module Name: floating_point_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PSD_temp_equation is
 Port ( 
        clk : in std_logic;    
        acq_start : in std_logic;
        
        Ch_temp : in STD_LOGIC_VECTOR ( 23 downto 0 ):= "000000000000"&X"435";
        temp_a : in std_logic_vector(32 - 1 downto 0):=X"bff9cbf1"; -- -0.0003889921   csi;
        temp_b : in std_logic_vector(32 - 1 downto 0):=X"3ffee960"; --  0.4558159696    csi;
        temp_c : in std_logic_vector(32 - 1 downto 0):=X"3ffee960"; --  0.4558159696    csi;
        Compare_rdy : in std_logic;
        PSD_T_result_out : out STD_LOGIC_VECTOR ( 31 downto 0 ));
end PSD_temp_equation;

architecture Behavioral of PSD_temp_equation is


signal Ch_fixed : STD_LOGIC_VECTOR ( 23 downto 0 );
--signal Ch_temp : STD_LOGIC_VECTOR ( 23 downto 0 ):= "000000000000"&X"435";
signal Ch_float: STD_LOGIC_VECTOR ( 31 downto 0 );
signal Ch_Compare : STD_LOGIC_VECTOR ( 31 downto 0 );
signal m_rdy_temp : std_logic;
signal m_rdy_result : std_logic;
signal m_temp_result : std_logic;
signal m_temp_result_pre : std_logic;
signal PSD_T_result_out_pre : STD_LOGIC_VECTOR ( 31 downto 0 );

COMPONENT floating_point_0 -- fixed to float
  PORT (
    aclk : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;



signal PSD_A: STD_LOGIC_VECTOR ( 31 downto 0 );
signal PSD_B: STD_LOGIC_VECTOR ( 31 downto 0 );
signal PSD_C: STD_LOGIC_VECTOR ( 31 downto 0 );

signal PSD_Temp : STD_LOGIC_VECTOR ( 31 downto 0 );
signal PSD_Temp_1pre : STD_LOGIC_VECTOR ( 31 downto 0 );




COMPONENT floating_point_1st_Order -- ax + b
   PORT (
    aclk : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_c_tvalid : IN STD_LOGIC;
    s_axis_c_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

--signal PSD_t1 : STD_LOGIC_VECTOR ( 31 downto 0 );

COMPONENT floating_point_1    --(ax+b) * x
  PORT (
    aclk : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;


COMPONENT floating_point_add    --a + b
  PORT (
    aclk : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(32 - 1 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(32 - 1 DOWNTO 0)
  );
END COMPONENT;

begin



PSD_A<=temp_a;
PSD_B<=temp_b; --  0.4558159696    csi
PSD_C<=temp_c; --  741.2798498457    csi

inst_floating_point_t1_temp : floating_point_0  -- x
  PORT MAP (
    aclk  => clk,
    aclken => acq_start,
    s_axis_a_tvalid =>  Compare_rdy,
    s_axis_a_tdata => Ch_temp,
    m_axis_result_tvalid => m_rdy_temp,
    m_axis_result_tdata => PSD_Temp
  );



i_floating_point_t1_Order :floating_point_1st_Order -- ax + b
  PORT MAP (
    aclk => clk,
    aclken  => acq_start,
    s_axis_a_tvalid =>  Compare_rdy,
    s_axis_a_tdata => PSD_A,
    s_axis_b_tvalid =>  Compare_rdy,
    s_axis_b_tdata => PSD_temp,
    s_axis_c_tvalid =>  Compare_rdy,
    s_axis_c_tdata => PSD_B,
    m_axis_result_tvalid  => m_rdy_result,
    m_axis_result_tdata =>Ch_Compare
  );

inst_mult_t1 :floating_point_1    --(ax+b) * x
  PORT map(
    aclk => clk,
    aclken  => acq_start,
    s_axis_a_tvalid => Compare_rdy,
    s_axis_a_tdata => Ch_Compare,
    s_axis_b_tvalid => Compare_rdy,
    s_axis_b_tdata => PSD_temp,
    m_axis_result_tvalid => m_temp_result_pre, 
    m_axis_result_tdata => PSD_T_result_out_pre
  );
  
  inst_add2 :floating_point_add    -- Ax2 + Bx + 491
  PORT map(
    aclk => clk,
    aclken  => acq_start,
    s_axis_a_tvalid => Compare_rdy,
    s_axis_a_tdata => PSD_T_result_out_pre,
    s_axis_b_tvalid => Compare_rdy,
    s_axis_b_tdata => PSD_C,
    m_axis_result_tvalid => m_temp_result,
    m_axis_result_tdata => PSD_T_result_out
  );


end Behavioral;
