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

entity floating_point_top is
  Port ( 
        rst : in std_logic;
        clk : in std_logic;    
        acq_start : in std_logic;
        cl_wr_en_pipe : in std_logic_vector(1 downto 0);
        Ch_temp_t1 : in STD_LOGIC_VECTOR ( 23 downto 0 );
        Ch_662Kev_read : in std_logic_vector( 16 - 1 downto 0);
        Ch_temp_t2 : in STD_LOGIC_VECTOR ( 23 downto 0 );
        K40_Pre_GC : in std_logic_vector(16 -1 downto 0);
        GC_Cal_out : out std_logic_vector( 16 - 1 downto 0);
--        temp_a : in std_logic_vector(32 - 1 downto 0);
--        temp_b : in std_logic_vector(32 - 1 downto 0);
        gc_a : in std_logic_vector(32 - 1 downto 0);
        gc_b : in std_logic_vector(32 - 1 downto 0);
        Compare_rdy : in std_logic);
end floating_point_top;

architecture Behavioral of floating_point_top is

Component PSD_temp_equation is
 Port ( 
        clk : in std_logic;    
        acq_start : in std_logic;
        
        Ch_temp : in STD_LOGIC_VECTOR ( 23 downto 0 );
        temp_a : in std_logic_vector(32 - 1 downto 0);
        temp_b : in std_logic_vector(32 - 1 downto 0);
        temp_c : in std_logic_vector(32 - 1 downto 0); 
        Compare_rdy : in std_logic;
        PSD_T_result_out : out STD_LOGIC_VECTOR ( 31 downto 0 ));
end Component;


--signal Ch_temp_t1_t : STD_LOGIC_VECTOR ( 23 downto 0 ):=X"00046B";
--signal K40_Pre_GC_t :  std_logic_vector(16 -1 downto 0):=X"84d0";



signal gc_change_en : std_logic := '0';

signal t1_done : STD_LOGIC:= '0';

signal t1_count : integer:=0;
signal Ch_temp_result : STD_LOGIC_VECTOR ( 32 - 1 downto 0 );
signal Ch_temp_t1_result : STD_LOGIC_VECTOR ( 32 - 1 downto 0 );
signal Ch_temp_t2_result : STD_LOGIC_VECTOR ( 32 - 1 downto 0 );
signal Ch_temp_t :  STD_LOGIC_VECTOR ( 23 downto 0 );

signal start_pipe : std_logic_vector(1 downto 0);
signal  temp_a,temp_b : std_logic_vector(32 - 1 downto 0);
signal  temp_c : std_logic_vector(32 - 1 downto 0);


Component PSD_temp_subtraction is
  Port  (
        clk : in std_logic;    
        acq_start : in std_logic;
        K40_Pre_GC : in std_logic_vector(16 -1 downto 0);
        Ch_662Kev_read : in std_logic_vector( 16 - 1 downto 0);
        Ch_temp1 : in STD_LOGIC_VECTOR (31 downto 0 );
        Ch_temp2 : in STD_LOGIC_VECTOR (31 downto 0 );
        cl_wr_en_pipe : in std_logic_vector(1 downto 0);
--        gc_a : in std_logic_vector(32 - 1 downto 0);
--        gc_b : in std_logic_vector(32 - 1 downto 0);
--        gc_change_en : in std_logic;
        GC_Cal_out : out std_logic_vector(16 - 1 downto 0);
        Compare_rdy : in std_logic);
end Component;

attribute mark_debug : string;
--    attribute mark_debug of Ch_temp_t1 : signal is "true";
    attribute mark_debug of K40_Pre_GC : signal is "true";

begin

process(clk)
begin
    if(rising_edge(clk))then
        if(acq_start = '0') then
            t1_done <= '0';
            t1_count <= 0;
        else
            if(t1_count = 1000)then  -- 0.01s
               
                if ( cl_wr_en_pipe = "01")then
                    t1_done <= '0';
                    t1_count <= 0;
                else
                     t1_done <= '1';    
                end if;
            else
                t1_count <= t1_count + 1;
            end if;    
        end if;
        
        
    end if;
end process;


temp_a <= X"bff8ce00";  -- -0.0000982287   
temp_b <= X"bffdb15f";  -- - 0.0866081012     
temp_c <= X"40041b54"; --  621.3240285774

process(clk)
begin
    if(rising_edge(clk))then
       if(t1_done = '0') then
            Ch_temp_t <= Ch_temp_t1;
            Ch_temp_t1_result <= Ch_temp_result;
       else
            Ch_temp_t <= Ch_temp_t2;
            Ch_temp_t2_result <= Ch_temp_result;
       end if;        
    end if;
end process;


inst_PSD_temp_equation_t: PSD_temp_equation 
 Port map ( 
        clk => clk,   
        acq_start => acq_start,
       
        Ch_temp => Ch_temp_t,
        temp_a => temp_a,
        temp_b => temp_b,
        temp_c => temp_c,
        Compare_rdy => Compare_rdy,
        PSD_T_result_out => Ch_temp_result);

--gc_change_en <= '1' when Ch_temp_t2 > X"000564" else '0';


inst_PSD_temp_subtraction : PSD_temp_subtraction
  Port  map(
        clk => clk,   
        acq_start => acq_start,
        Ch_temp1 => Ch_temp_t1_result,
        Ch_temp2 => Ch_temp_t2_result,
        cl_wr_en_pipe => cl_wr_en_pipe,
        Ch_662Kev_read => Ch_662Kev_read,
        K40_Pre_GC => K40_Pre_GC,
        GC_Cal_out => GC_Cal_out,

        Compare_rdy => Compare_rdy);
end Behavioral;