----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/04/11 13:45:09
-- Design Name: 
-- Module Name: eeprom_top - Behavioral
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
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eeprom_top is
 Port ( --rst  : in std_logic;
        clk              : in std_logic;
        Hv_wr_en               : in  std_logic;
        cl_wr_en            : in std_logic;
        su_wr_en            : in std_logic;
        rd_en               : in std_logic;
        
          ----25.01.03------------------
        init_wr_en : in std_logic;
        init_wr_addr : in std_logic_vector(24 - 1 downto 0);
        init_wr_data : in std_logic_vector(24 - 1 downto 0);
        ------------------------------------
        
        GC_write                  : in std_logic_vector(16 - 1 downto 0);
        Temp_write                : in std_logic_vector(16 - 1 downto 0);
        Ch_32Kev_write            : in std_logic_vector(16 - 1 downto 0);
        Ch_662Kev_write           : in std_logic_vector(16 - 1 downto 0);
        Ch_1460Kev_write          : in std_logic_vector(16 - 1 downto 0);
        D_lab_write               : in std_logic_vector(16 - 1 downto 0);
        HV_DAC_write              : in std_logic_vector(16 - 1 downto 0);
        Threshold_write           : in std_logic_vector(8 - 1 downto 0);
        SignalTime_write          : in std_logic_vector(8 - 1 downto 0);
        Data_subtraction_write    : in std_logic_vector(8 - 1 downto 0);
        Serial_1_write            : in std_logic_vector(8 - 1 downto 0);
        Serial_2_write            : in std_logic_vector(8 - 1 downto 0);
        Serial_3_write            : in std_logic_vector(8 - 1 downto 0);
        Serial_4_write            : in std_logic_vector(8 - 1 downto 0);
        Serial_5_write            : in std_logic_vector(8 - 1 downto 0);
        Serial_6_write            : in std_logic_vector(8 - 1 downto 0);
        GM_count_threshold_write  :  in std_logic_vector(8 - 1 downto 0);
        temp_a_write            : in std_logic_vector(32 - 1 downto 0);
        temp_b_write            : in std_logic_vector(32 - 1 downto 0);
        GC_a_write            : in std_logic_vector(32 - 1 downto 0);
        GC_b_write            : in std_logic_vector(32 - 1 downto 0);
        
        GC_read                  : out std_logic_vector(16 - 1 downto 0);
        Temp_read                : out std_logic_vector(16 - 1 downto 0);
        Ch_32Kev_read            : out std_logic_vector(16 - 1 downto 0);
        Ch_662Kev_read           : out std_logic_vector(16 - 1 downto 0);
        Ch_1460Kev_read          : out std_logic_vector(16 - 1 downto 0);
        D_lab_read               : out std_logic_vector(16 - 1 downto 0);
        HV_DAC_read              : out std_logic_vector(16 - 1 downto 0);
        Threshold_read           : out std_logic_vector(8 - 1 downto 0);
        SignalTime_read          : out std_logic_vector(8 - 1 downto 0);
        Data_subtraction_read    : out std_logic_vector(8 - 1 downto 0);
        Serial_1_read            : out std_logic_vector(8 - 1 downto 0);
        Serial_2_read            : out std_logic_vector(8 - 1 downto 0);
        Serial_3_read            : out std_logic_vector(8 - 1 downto 0);
        Serial_4_read            : out std_logic_vector(8 - 1 downto 0);
        Serial_5_read            : out std_logic_vector(8 - 1 downto 0);
        Serial_6_read            : out std_logic_vector(8 - 1 downto 0);
        GM_count_threshold_read  :  out std_logic_vector(8 - 1 downto 0);
        temp_a_read              : out std_logic_vector(32 - 1 downto 0);
        temp_b_read              : out std_logic_vector(32 - 1 downto 0);
        GC_a_read                : out std_logic_vector(32 - 1 downto 0);
        GC_b_read                : out std_logic_vector(32 - 1 downto 0);
        
        
        read_end                 : out std_logic;
        
        cs_n                : out std_logic;
        sclk                : out std_logic;
        miso                : in std_logic;
        mosi                : out std_logic
         );
end eeprom_top;


architecture Behavioral of eeprom_top is

    
    
signal tx_data : std_logic_vector(7 downto 0);
signal rx_data : std_logic_vector(7 downto 0);
signal busy : std_logic;    
signal ena : std_logic;  
signal cont : std_logic; 
signal rst  : std_logic:='1';
signal ss_n : std_logic_vector(0 downto 0);
signal mosi_buf : std_logic;
signal miso_buf : std_logic;
--signal sclk_buf : std_logic;
signal cs_n_buf : std_logic;




attribute mark_debug : string;
    attribute mark_debug of cs_n : signal is "true";
    attribute mark_debug of sclk : signal is "true";
    attribute mark_debug of hv_wr_en : signal is "true";
    attribute mark_debug of su_wr_en : signal is "true";
    attribute mark_debug of rd_en : signal is "true";
    attribute mark_debug of miso : signal is "true";
    attribute mark_debug of mosi : signal is "true";
--attribute mark_debug : string;
--    attribute mark_debug of mosi_buf : signal is "true";
--    attribute mark_debug of miso_buf : signal is "true";
--    attribute mark_debug of sclk_buf : signal is "true";
--    attribute mark_debug of cs_n_buf : signal is "true";
signal sclk_buf : std_logic;
signal ss_n_buf : std_logic;
Component eeprom_spi_master IS
  GENERIC(
    slaves  : INTEGER := 1;  --number of spi slaves
    d_width : INTEGER := 8); --data bus width
  PORT(
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : IN     STD_LOGIC;                             --initiate transaction
    cpol    : IN     STD_LOGIC;                             --spi clock polarity
    cpha    : IN     STD_LOGIC;                             --spi clock phase
    cont    : IN     STD_LOGIC;                             --continuous mode command
    clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
    addr    : IN     INTEGER;                               --address of slave
    tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
    
    miso    : IN     STD_LOGIC;                             --master in, slave out
    sclk    : Buffer STD_LOGIC;                             --spi clock
    ss_n    : inout STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
    mosi    : OUT    STD_LOGIC;                             --master out, slave in
    busy    : OUT    STD_LOGIC;                             --busy / data ready signal
    rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
END component;

Component eeprom_protocol is
 Port (
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : out     STD_LOGIC;                             --initiate transaction   
    hv_wr_en   : in std_logic;
    cl_wr_en   : in std_logic;
    su_wr_en   : in std_logic;
    rd_en   : in std_logic;
   ----25.01.03------------------
    init_wr_en : in std_logic;
    init_wr_addr : in std_logic_vector(24 - 1 downto 0);
    init_wr_data : in std_logic_vector(24 - 1 downto 0);
        ------------------------------------
    
    
    
    
    cont    : out     STD_LOGIC;                             --continuous mode command
    tx_data : out     STD_LOGIC_VECTOR(8-1 DOWNTO 0);  --data to transmit
    busy    : IN    STD_LOGIC;                             --busy / data ready signal
    
    GC                  : in std_logic_vector(16 - 1 downto 0);
    Temp                : in std_logic_vector(16 - 1 downto 0);
    Ch_32Kev            : in std_logic_vector(16 - 1 downto 0);
    Ch_662Kev           : in std_logic_vector(16 - 1 downto 0);
    Ch_1460Kev          : in std_logic_vector(16 - 1 downto 0);
    D_lab               : in std_logic_vector(16 - 1 downto 0);
    HV_DAC              : in std_logic_vector(16 - 1 downto 0);
    Threshold           : in std_logic_vector(8 - 1 downto 0);
    SignalTime          : in std_logic_vector(8 - 1 downto 0);
    Data_subtraction    : in std_logic_vector(8 - 1 downto 0);
    Serial_1            : in std_logic_vector(8 - 1 downto 0);
    Serial_2            : in std_logic_vector(8 - 1 downto 0);
    Serial_3            : in std_logic_vector(8 - 1 downto 0);
    Serial_4            : in std_logic_vector(8 - 1 downto 0);
    Serial_5            : in std_logic_vector(8 - 1 downto 0);
    Serial_6            : in std_logic_vector(8 - 1 downto 0);
    GM_count_threshold  : in std_logic_vector(8 - 1 downto 0);
    temp_a            : in std_logic_vector(32 - 1 downto 0);
    temp_b            : in std_logic_vector(32 - 1 downto 0);
    GC_a            : in std_logic_vector(32 - 1 downto 0);
    GC_b            : in std_logic_vector(32 - 1 downto 0);
    
    
    GC_read                  : out std_logic_vector(16 - 1 downto 0);
    Temp_read                : out std_logic_vector(16 - 1 downto 0);
    Ch_32Kev_read            : out std_logic_vector(16 - 1 downto 0);
    Ch_662Kev_read           : out std_logic_vector(16 - 1 downto 0);
    Ch_1460Kev_read          : out std_logic_vector(16 - 1 downto 0);
    D_lab_read               : out std_logic_vector(16 - 1 downto 0);
    HV_DAC_read              : out std_logic_vector(16 - 1 downto 0);
    Threshold_read           : out std_logic_vector(8 - 1 downto 0);
    SignalTime_read          : out std_logic_vector(8 - 1 downto 0);
    Data_subtraction_read    : out std_logic_vector(8 - 1 downto 0);
    Serial_1_read            : out std_logic_vector(8 - 1 downto 0);
    Serial_2_read            : out std_logic_vector(8 - 1 downto 0);
    Serial_3_read            : out std_logic_vector(8 - 1 downto 0);
    Serial_4_read            : out std_logic_vector(8 - 1 downto 0);
    Serial_5_read            : out std_logic_vector(8 - 1 downto 0);
    Serial_6_read            : out std_logic_vector(8 - 1 downto 0);
    GM_count_threshold_read  :  out std_logic_vector(8 - 1 downto 0);
    temp_a_read            : out std_logic_vector(32 - 1 downto 0);
    temp_b_read            : out std_logic_vector(32 - 1 downto 0);
    GC_a_read            : out std_logic_vector(32 - 1 downto 0);
    GC_b_read            : out std_logic_vector(32 - 1 downto 0);
    
    
    read_end                 : out std_logic;
    
    rx_data : IN    STD_LOGIC_VECTOR(8-1 DOWNTO 0)); --data received
end Component;

COMPONENT clk_wiz_0 
PORT(
       clk_out1  : OUT std_logic;
       clk_out2  : OUT std_logic;

       reset  : In std_logic;
       locked : OUT std_logic;
        clk_in1 : In std_logic
        );
 END COMPONENT;

begin
cs_n <= ss_n(0);
sclk <= sclk_buf;

inst_eeprom_spi_master : eeprom_spi_master
port map(
    clock   => clk,
    reset_n => rst,
    enable  => ena,
    cpol    => '0',
    cpha    => '0',
    cont    => cont,
    clk_div => 20,
    addr    => 1,
    tx_data => tx_data,
    miso    => miso,
    sclk    => sclk_buf,
    ss_n    => ss_n,
    mosi    => mosi,
    busy    => busy,
    rx_data => rx_data);
    
inst_eeprom_protocol  : eeprom_protocol 
 Port map(
    clock   => clk,
    reset_n => rst,
    enable  => ena,  
    hv_wr_en   => hv_wr_en,
    su_wr_en   => su_wr_en,
    cl_wr_en   => cl_wr_en,
    rd_en   => rd_en,
    
    init_wr_en   => init_wr_en,
    init_wr_addr => init_wr_addr,
    init_wr_data => init_wr_data,
    
    
    cont    => cont,
    tx_data => tx_data,
    busy    => busy,
    
    GC                  =>  GC_write                ,
    Temp                =>  Temp_write              ,
    Ch_32Kev            =>  Ch_32Kev_write          ,
    Ch_662Kev           =>  Ch_662Kev_write         ,
    Ch_1460Kev          =>  Ch_1460Kev_write        ,
    D_lab               =>  D_lab_write             ,
    HV_DAC              =>  HV_DAC_write            ,
    Threshold           =>  Threshold_write         ,
    SignalTime          =>  SignalTime_write        ,
    Data_subtraction    =>  Data_subtraction_write  ,
    Serial_1            =>  Serial_1_write          ,
    Serial_2            =>  Serial_2_write          ,
    Serial_3            =>  Serial_3_write          ,
    Serial_4            =>  Serial_4_write          ,
    Serial_5            =>  Serial_5_write          ,
    Serial_6            =>  Serial_6_write          ,
    GM_count_threshold  =>  GM_count_threshold_write          ,
    temp_a              =>  temp_a_write,
    temp_b              =>  temp_b_write,
    Gc_a                =>  Gc_a_write,
    Gc_b                =>  Gc_b_write,
    
    
    GC_read                => GC_read,  
    Temp_read              => Temp_read,
    Ch_32Kev_read          => Ch_32Kev_read,
    Ch_662Kev_read         => Ch_662Kev_read,
    Ch_1460Kev_read        => Ch_1460Kev_read,
    D_lab_read             => D_lab_read,
    HV_DAC_read            => HV_DAC_read,
    Threshold_read         => Threshold_read,
    SignalTime_read        => SignalTime_read,
    Data_subtraction_read  => Data_subtraction_read,
    Serial_1_read          => Serial_1_read,
    Serial_2_read          => Serial_2_read,
    Serial_3_read          => Serial_3_read,
    Serial_4_read          => Serial_4_read,
    Serial_5_read          => Serial_5_read,
    Serial_6_read          => Serial_6_read,
    GM_count_threshold_read=>GM_count_threshold_read,
    temp_a_read            =>  temp_a_read,
    temp_b_read            =>  temp_b_read,
    Gc_a_read              =>  Gc_a_read,
    Gc_b_read              =>  Gc_b_read,
    
    
    
    read_end               => read_end,
    
    rx_data  =>rx_data);

--i_clk_wiz_0 : clk_wiz_0 
--PORT map(
--       clk_out1  => clk,
--       clk_out2  => clk_debug,
----         clk_XADC=> clk_XADC,
--       reset  => '0',
--       locked => open,
--        clk_in1 => clk_in
--        );

end Behavioral;
