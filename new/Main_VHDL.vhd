----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/03/05 16:58:42
-- Design Name: 
-- Module Name: Main_VHDL - Behavioral
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
--Library XilinxCoreLib;
--library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
	use UNISIM.vcomponents.all;
library xil_defaultlib;
    use xil_defaultlib.all;



entity Main_VHDL is
port(
clk : in std_logic;

w_TX_SERIAL : out std_logic;
r_RX_SERIAL : in std_logic;
r_RX_SERIAL_Bat : in std_logic;
--w_TX_SERIAL_Bat : out std_logic:='1';

 clk_ADC_p : out std_logic;
 
 ADC_CLK_OUT_P : out std_logic;
 ADC_CLK_OUT_N : out std_logic;
-- clk_ADC_n : out std_logic;
ADC_ORT : in std_logic; 
ADC_value : in std_logic_vector(11 downto 0); 
 
sclk :  out std_logic;
cs_n :   out std_logic_vector(0 downto 0);
mosi :  out std_logic;


sclk_2 :  out std_logic;
cs_n_2 :   out std_logic_vector(0 downto 0);
mosi_2 :  out std_logic;
--miso_2 :  in std_logic;
led_green  : out std_logic;
led_blue   : out std_logic;
led_red    : in std_logic;

adc_sda    : inout std_logic;
adc_scl    : inout std_logic;

m_dout  : out std_logic_vector(7 downto 0);


fpga_wakeup : out std_logic;

cpu_detect :  in std_logic;
cpu_phold  : out std_logic:='0';

test1  : out std_logic:='1';
test2  : in std_logic;
fpga_awake  : out std_logic;
Pin_Trig_signal : in std_logic; 

eeprom_cs_n : out std_logic;
eeprom_sclk : out std_logic;
eeprom_miso : in std_logic;
eeprom_mosi : out std_logic;
HV_Enable : out std_logic;
Adc_sleep : out std_logic;


VAUXP : in std_logic_vector(3 downto 0);
VAUXN : in std_logic_vector(3 downto 0)


--ADC_CS : out std_logic;
--ADC_Data : out std_logic;


);

end Main_VHDL;


architecture Behavioral of Main_VHDL is
signal led_green_buf : std_logic:= '0'; 
signal Ch_temp_t1 :  STD_LOGIC_VECTOR ( 23 downto 0 );
signal Ch_temp_t2 :  STD_LOGIC_VECTOR ( 23 downto 0 );
signal GC_Cal_out : std_logic_vector( 16 - 1 downto 0);
signal wakup_buf : std_logic:='0';
signal wakup_cnt : integer range 0 to 50000000:=0;
component floating_point_top is
  Port ( 
        clk : in std_logic;    
        acq_start : in std_logic;
        cl_wr_en_pipe : in std_logic_vector(1 downto 0);
        Ch_temp_t1 : in STD_LOGIC_VECTOR ( 23 downto 0 );
        Ch_662Kev_read : in std_logic_vector(16 - 1 downto 0);
        Ch_temp_t2 : in STD_LOGIC_VECTOR ( 23 downto 0 );
        K40_Pre_GC : in std_logic_vector(16 -1 downto 0);
        GC_Cal_out : out std_logic_vector( 16 - 1 downto 0);
--        temp_a : in std_logic_vector(32 - 1 downto 0);
--        temp_b : in std_logic_vector(32 - 1 downto 0);
        gc_a : in std_logic_vector(32 - 1 downto 0);
        gc_b : in std_logic_vector(32 - 1 downto 0);
        Compare_rdy : in std_logic);
end component;

signal Cal_read_done : std_logic:= '0';
signal rd_en_start : std_logic:='0';
signal rd_en_cnt : integer range 0 to 10000000:=0;
signal GC_Cal_data_read :  std_logic_vector(16 - 1 downto 0);
signal Temp_Cal_data_read : std_logic_vector(16 - 1 downto 0);
signal eeprom_test_write_en : std_logic;
signal sleep_en : std_logic:='0';

signal GC_write                  :  std_logic_vector(16 - 1 downto 0);
signal Temp_write                :  std_logic_vector(16 - 1 downto 0);
signal Ch_32Kev_write            :  std_logic_vector(16 - 1 downto 0);
signal Ch_662Kev_write           :  std_logic_vector(16 - 1 downto 0);
signal Ch_1460Kev_write          :  std_logic_vector(16 - 1 downto 0);
signal D_lab_write               :  std_logic_vector(16 - 1 downto 0);
signal HV_DAC_write              :  std_logic_vector(16 - 1 downto 0);
signal Threshold_write           :  std_logic_vector(8 - 1 downto 0);
signal SignalTime_write          :  std_logic_vector(8 - 1 downto 0);
signal Data_subtraction_write    :  std_logic_vector(8 - 1 downto 0);
signal Serial_1_write            :  std_logic_vector(8 - 1 downto 0);
signal Serial_2_write            :  std_logic_vector(8 - 1 downto 0);
signal Serial_3_write            :  std_logic_vector(8 - 1 downto 0);
signal Serial_4_write            :  std_logic_vector(8 - 1 downto 0);
signal Serial_5_write            :  std_logic_vector(8 - 1 downto 0);
signal Serial_6_write            :  std_logic_vector(8 - 1 downto 0);
signal temp_a_write            :  std_logic_vector(32 - 1 downto 0);
signal temp_b_write            :  std_logic_vector(32 - 1 downto 0);
signal gc_a_write            :  std_logic_vector(32 - 1 downto 0);
signal gc_b_write            :  std_logic_vector(32 - 1 downto 0);
signal temp_a_write_check            :  std_logic_vector(32 - 1 downto 0);
signal temp_b_write_check            :  std_logic_vector(32 - 1 downto 0);
signal gc_a_write_check            :  std_logic_vector(32 - 1 downto 0);
signal gc_b_write_check            :  std_logic_vector(32 - 1 downto 0);
signal temp_a            :  std_logic_vector(32 - 1 downto 0):=X"bff93a6e"; -- -0.0001777958   Cs137 tempcor
signal temp_b            :  std_logic_vector(32 - 1 downto 0):=X"bffd8578"; -- -0.0651704909    Cs137 Tempcor
signal gc_a             :  std_logic_vector(32 - 1 downto 0):=X"40011c98";  --   9.7871145269 
signal gc_b             :  std_logic_vector(32 - 1 downto 0):=X"40011c98";  --   9.7871145269 

signal HV_DAC_Buf                  :  std_logic_vector(16 - 1 downto 0):= X"8A80";
signal GC_Buf                  :  std_logic_vector(16 - 1 downto 0):= X"8340";
signal GC_sw_Buf                  :  std_logic_vector(16 - 1 downto 0):= X"8340";
signal Temp_Buf                :  std_logic_vector(16 - 1 downto 0);

signal GC_read                  :  std_logic_vector(16 - 1 downto 0);
signal Temp_read                :  std_logic_vector(16 - 1 downto 0);
signal Ch_32Kev_read            :  std_logic_vector(16 - 1 downto 0);
signal Ch_662Kev_read           :  std_logic_vector(16 - 1 downto 0);
signal Ch_1460Kev_read          :  std_logic_vector(16 - 1 downto 0);
signal D_lab_read               :  std_logic_vector(16 - 1 downto 0);
signal HV_DAC_read              :  std_logic_vector(16 - 1 downto 0);
signal Threshold_read           :  std_logic_vector(8 - 1 downto 0);
signal SignalTime_read          :  std_logic_vector(8 - 1 downto 0);
signal Data_subtraction_read    :  std_logic_vector(8 - 1 downto 0);
signal Serial_1_read            :  std_logic_vector(8 - 1 downto 0);
signal Serial_2_read            :  std_logic_vector(8 - 1 downto 0);
signal Serial_3_read            :  std_logic_vector(8 - 1 downto 0);
signal Serial_4_read            :  std_logic_vector(8 - 1 downto 0);
signal Serial_5_read            :  std_logic_vector(8 - 1 downto 0);
signal Serial_6_read            :  std_logic_vector(8 - 1 downto 0);
signal temp_a_read            :  std_logic_vector(32 - 1 downto 0);
signal temp_b_read            :  std_logic_vector(32 - 1 downto 0);
signal gc_a_read            :  std_logic_vector(32 - 1 downto 0);
signal gc_b_read            :  std_logic_vector(32 - 1 downto 0);

signal read_end                 : std_logic;
signal read_end_pipe            : std_logic_vector(1 downto 0);
signal read_end_pipe_1d            : std_logic_vector(1 downto 0);
signal Main_Signal_TIME_1_buf : std_logic_vector(7 downto 0);
signal cl_wr_en_pipe : std_logic_vector(1 downto 0);
Component eeprom_top is
  Port (
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
        
        GC_write                  : in std_logic_vector(16 - 1 downto 0):= X"6978";
        Temp_write                : in std_logic_vector(16 - 1 downto 0):= X"0401";
        Ch_32Kev_write            : in std_logic_vector(16 - 1 downto 0):= X"000F";
        Ch_662Kev_write           : in std_logic_vector(16 - 1 downto 0):= X"018a";
        Ch_1460Kev_write          : in std_logic_vector(16 - 1 downto 0):= X"036b";
        D_lab_write               : in std_logic_vector(16 - 1 downto 0):= X"000D";
        HV_DAC_write              : in std_logic_vector(16 - 1 downto 0):= X"7d46";
        Threshold_write           : in std_logic_vector(8 - 1 downto 0):= X"06";
        SignalTime_write          : in std_logic_vector(8 - 1 downto 0):= X"0b";
        Data_subtraction_write    : in std_logic_vector(8 - 1 downto 0):= X"00";
        Serial_1_write            : in std_logic_vector(8 - 1 downto 0):= X"47";
        Serial_2_write            : in std_logic_vector(8 - 1 downto 0):= X"33";
        Serial_3_write            : in std_logic_vector(8 - 1 downto 0):= X"41";
        Serial_4_write            : in std_logic_vector(8 - 1 downto 0):= X"41";
        Serial_5_write            : in std_logic_vector(8 - 1 downto 0):= X"34";
        Serial_6_write            : in std_logic_vector(8 - 1 downto 0):= X"38";
        GM_count_threshold_write  : in std_logic_vector(8 - 1 downto 0):= X"02";
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
        GM_count_threshold_read  : out std_logic_vector(8 - 1 downto 0):= X"02";
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
end Component;

signal r_RX_SERIAL_buf : std_logic;
COMPONENT UART_RX
   generic (
      g_CLKS_PER_BIT : integer := 43   -- Needs to be set correctly
      );
	PORT(
		i_Clk : IN std_logic;
		i_RX_Serial : IN std_logic;          
		o_RX_DV : OUT std_logic;
		o_RX_Byte : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;	
signal miso : std_logic;	
signal miso_2 : std_logic;
COMPONENT SPI_MASTER is
        Generic (
            CLK_FREQ    : natural := 10e6; -- set system clock frequency in Hz
            SCLK_FREQ   : natural := 1e6;  -- set SPI clock frequency in Hz (condition: SCLK_FREQ <= CLK_FREQ/10)
            SLAVE_COUNT : natural := 1     -- count of SPI slaves
        );
        Port (
            CLK      : in  std_logic; -- system clock
            RST      : in  std_logic; -- high active synchronous reset
            -- SPI MASTER INTERFACE
            SCLK     : out std_logic; -- SPI clock
            CS_N     : out std_logic_vector(SLAVE_COUNT-1 downto 0); -- SPI chip select, active in low
            MOSI     : out std_logic; -- SPI serial data from master to slave
            MISO     : in  std_logic; -- SPI serial data from slave to master
            -- INPUT USER INTERFACE
            ADDR     : in  std_logic_vector(0 downto 0); -- SPI slave address
            DIN      : in  std_logic_vector(7 downto 0); -- input data for SPI slave
            DIN_LAST : in  std_logic; -- when DIN_LAST = 1, after transmit these input data is asserted CS_N
            DIN_VLD  : in  std_logic; -- when DIN_VLD = 1, input data are valid
            READY    : out std_logic; -- when READY = 1, valid input data are accept
            -- OUTPUT USER INTERFACE
            DOUT     : out std_logic_vector(7 downto 0); -- output data from SPI slave
            DOUT_VLD : out std_logic  -- when DOUT_VLD = 1, output data are valid
        );
	END COMPONENT;	
	
	
	


COMPONENT Moving_Avr is
generic (
  G_NBIT                     : integer := 14;
  G_AVG_LEN_LOG              : integer := 6 );
port (  
  i_clk                      : in  std_logic;
  i_rstb                     : in  std_logic;
  i_sync_reset               : in  std_logic;
  -- input
  i_data_ena                 : in  std_logic;
  i_data                     : in  std_logic_vector(G_NBIT-1 downto 0);
  -- output
  o_data_valid               : out std_logic;
  o_data                     : out std_logic_vector(G_NBIT-1 downto 0));
end COMPONENT;

signal w_TX_SERIAL_buf : std_logic;
	COMPONENT UART_TX
	generic (
      g_CLKS_PER_BIT : integer := 43   -- Needs to be set correctly
      );
	PORT(
		i_Clk : IN std_logic;
		i_TX_DV : IN std_logic;
		i_TX_Byte : IN std_logic_vector(7 downto 0);          
		o_TX_Active : OUT std_logic;
		o_TX_Serial : OUT std_logic;
		o_TX_Done : OUT std_logic
		);
	END COMPONENT;

COMPONENT clk_wiz_0 
PORT(
       clk_out1  : OUT std_logic;
       clk_out2  : OUT std_logic;
       clk_out3  : OUT std_logic;
--       clk_XADC : OUT std_logic;
       reset  : In std_logic;
       locked : OUT std_logic;
        clk_in1 : In std_logic
        );
 END COMPONENT;

COMPONENT  Xilinx_serial_I2C
port (
	CLK: IN std_logic;
	rst : in std_logic;	
	Phase_sync_skew : in std_logic_vector(1 downto 0);
	
	CS: out std_logic:='1';	
	
	SDATA: out std_logic;	
	
	Phase_sync_skew_test : out std_logic_vector(1 downto 0):="00"
	
	);
 END COMPONENT;
 
COMPONENT ADC_invert 
port(
	clk : in std_logic;
	ADC_ORT : IN std_logic;  
	ADC_value : in std_logic_vector(11 downto 0);
	inva : out std_logic_vector(11 downto 0));
end COMPONENT; 

COMPONENT ug480 
   port
   (
    DCLK               : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
    RESET              : in  STD_LOGIC;                         -- Reset signal for the System Monitor control logic
    VAUXP, VAUXN       : in  STD_LOGIC_VECTOR (3 downto 0);    -- Input data bus for the dynamic reconfiguration port
    VP, VN             : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port

    MEASURED_TEMP      : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_VCCAUX    : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_VCCINT    : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_VCCBRAM   : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_AUX0      : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_AUX1      : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_AUX2      : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port
    MEASURED_AUX3      : out  STD_LOGIC_VECTOR (15 downto 0);   -- Output data bus for dynamic reconfiguration port

    ALM                : out  STD_LOGIC_VECTOR (7 downto 0);   -- Output data bus for dynamic reconfiguration port
    CHANNEL            : out  STD_LOGIC_VECTOR (4 downto 0);   -- Output data bus for dynamic reconfiguration port
    OT                 : out  STD_LOGIC;   -- Output data bus for dynamic reconfiguration port
    EOC         : out  STD_LOGIC;   -- Output data bus for dynamic reconfiguration port
    EOS         : out  STD_LOGIC   -- Output data bus for dynamic reconfiguration port
);
 END COMPONENT;
signal ADC_temp_data : std_logic_vector(16 - 1 downto 0);
signal ADC_3p3_data : std_logic_vector(16 - 1 downto 0);
signal ADC_2p8_data : std_logic_vector(16 - 1 downto 0);
signal ADC_1p8_data : std_logic_vector(16 - 1 downto 0);
signal ADC_1p0_data : std_logic_vector(16 - 1 downto 0);    

signal ADC_temp_data_buf : std_logic_vector(16 - 1 downto 0);
signal ADC_3p3_data_buf : std_logic_vector(16 - 1 downto 0);
signal ADC_2p8_data_buf : std_logic_vector(16 - 1 downto 0);
signal ADC_1p8_data_buf : std_logic_vector(16 - 1 downto 0);
signal ADC_1p0_data_buf : std_logic_vector(16 - 1 downto 0);  
                                         
signal Crystal_Temp : std_logic_vector(16 - 1 downto 0);
signal led_green_cnt : integer range 0 to 10000000:=0;
signal power_check1 : std_logic:= '0';
signal power_check2 : std_logic:= '0';
signal power_check3 : std_logic:= '0';
signal power_check4 : std_logic:= '0';
signal rst_n : std_logic:='1';
Component adc_protocol_top is
  Port ( 
        rst_n : in std_logic;
        clk : in std_logic;
        sda : inout std_logic;
        scl : inout std_logic;
        adc_temp_out : out std_logic_vector(16 - 1 downto 0);
        adc_3p3_out  : out std_logic_vector(16 - 1 downto 0);
        adc_2p8_out  : out std_logic_vector(16 - 1 downto 0);
        adc_1p8_out  : out std_logic_vector(16 - 1 downto 0);
        adc_1p0_out  : out std_logic_vector(16 - 1 downto 0)
  );
end Component;

COMPONENT Radiation_detect14bit_8192 
port(
	clk: in std_logic;
	rst: in std_logic;
	acq_start: IN std_logic;	
	--CH_ACQ: In std_logic;
	--ADC_ORT : in std_logic;
	--flag_data_stop : inout std_logic;
	Trapezoidal_out : in std_logic_vector(13 downto 0); 
	flag_start : out std_logic;
	Threshold : In STD_LOGIC_VECTOR( 12 downto 0);
	Signal_TIME: In STD_LOGIC_Vector( 6 downto 0);
	Data_subtraction : In STD_LOGIC_VECTOR( 12 downto 0) ;
	--Ch_Data_subtraction_all : in std_logic_vector(11 downto 0);
	data_in: in std_logic_vector(13 downto 0);
	dout_CH: out std_logic_vector(12 downto 0);
	flag_CH : out std_logic
	);	
end COMPONENT;

COMPONENT radiation_SCA14bit 
port(
	clk: in std_logic;
	rst: in std_logic;
	acq_start: IN std_logic;	
	--CH_ACQ: In std_logic;
	--ADC_ORT : in std_logic;
	--flag_data_stop : inout std_logic;
	Trapezoidal_out : in std_logic_vector(13 downto 0); 
	flag_start : out std_logic;
	Threshold : In STD_LOGIC_VECTOR( 12 downto 0);
	Signal_TIME: In STD_LOGIC_Vector( 6 downto 0);
	Data_subtraction : In STD_LOGIC_VECTOR( 12 downto 0) ;
	--Ch_Data_subtraction_all : in std_logic_vector(11 downto 0);
	data_in: in std_logic_vector(13 downto 0);
	dout_CH: out std_logic_vector(12 downto 0);
	flag_CH : out std_logic
	);	
end COMPONENT;

COMPONENT radiation_RisingEdgeC 
port(
	clk: in std_logic;
	rst: in std_logic;
	acq_start: IN std_logic;	

	Trapezoidal_out : in std_logic_vector(13 downto 0); 
	
	Threshold : In STD_LOGIC_VECTOR( 12 downto 0);
	Signal_TIME: In STD_LOGIC_Vector( 6 downto 0);
	Data_subtraction : In STD_LOGIC_VECTOR( 12 downto 0) ;	
	flag_CH : out std_logic
	);	
end COMPONENT;

COMPONENT SCA_Module 
port(
	clk: in std_logic;	
	rst: in std_logic;
	acq_start: IN std_logic;	
    Ch_all : out std_logic_vector(31 downto 0);   
    flag_acq_in : in std_logic;
	flag_CH : in std_logic
	);	
end COMPONENT;

COMPONENT RAM_Spectrum 
	port( clk: in std_logic;		
			clk_RAM : in std_logic;
			rst: in std_logic;
			Swich_mode : in std_logic_vector(3 downto 0);
			GM_count : in std_logic;
			laser_count : in std_logic;
			neutron_count : in std_logic;
			flag_check : out std_logic;
			flag_init:out std_logic;
			acq_done : out std_logic:='1';
			flag_out: out std_logic;
			acq_take : in std_logic; -- Read Start
			acq_count : in std_logic; -- Read RAM Addr
			acq_start : in std_logic; -- Func Start
			flag_aq_1 : in std_logic; -- Write Start
            Bat_ADC_In : in std_logic_vector(7 downto 0);
			Pileup_sp_T : in std_logic;
		    R_Counter_RAM : in std_logic;    
		    GM_En : in std_logic;
		    Neutron_En : in std_logic;
		    Det_label  : in std_logic_vector(15 downto 0);
            MEASURED_TEMP_in : in std_logic_vector(15 downto 0);
            MEASURED_VCCAUX_in : in std_logic_vector(15 downto 0);
            MEASURED_VCCINT_in : in std_logic_vector(15 downto 0);
            adc_temp_in : in std_logic_vector(15 downto 0);
            adc_3p3_in : in std_logic_vector(15 downto 0);
            adc_2p8_in : in std_logic_vector(15 downto 0);
            adc_1p8_in : in std_logic_vector(15 downto 0);  
            adc_1p0_in : in std_logic_vector(15 downto 0); 
            
            GC : in std_logic_vector(15 downto 0); 
            HV_DAC : in std_logic_vector(15 downto 0); 
			HV_buf_Sm : in std_logic_vector(11 downto 0);
			Bat_Status_in : in  std_logic_vector(3 downto 0);
			flag_ram: out std_logic;
			
			data_in_1 : in std_logic_vector(12 downto 0);

			Spec_out : out std_logic_vector(15 downto 0):= "0100010000110000"--D0
		);	
end COMPONENT;

Component Smoothing_Shifter 
port(
	clk: in std_logic;
	rst: in std_logic;
	acq_start: IN std_logic;	
	data_in: in std_logic_vector(13 downto 0);	
	Trapezoidal_out : out std_logic_vector(13 downto 0)
	
	);	
end Component;


Component Clk_1ns is
port(clk: in std_logic;
	clk_1ns: out std_logic);
end Component;

Component clk_100ms is
port(clk: in std_logic;	
   clk_100ms: out std_logic:='0');
end Component;

signal temp : std_logic_vector(11 downto 0);

signal  Data_Byte: std_logic_vector(7 downto 0);
signal        Rdy_Tx  : std_logic               := '0';
constant c_CLKS_PER_BIT : integer := 43;
constant  c_CLKS_PER_BIT_Bat : integer := 1042;

signal             Bat_ADC_In :  std_logic_vector(7 downto 0);
signal Bat_Status_in :  std_logic_vector(3 downto 0);

signal r_TX_DV     : std_logic                    := '0';
signal r_TX_BYTE   : std_logic_vector(7 downto 0) := (others => '0');

signal w_TX_DONE   : std_logic;
signal w_RX_DV     : std_logic;
signal w_RX_BYTE   : std_logic_vector(7 downto 0);

signal cnt_dv : integer range 0 to 10000000:=0;
signal cnt_DV_T : integer range 0 to 10000000:=0; 
 signal cnt_DV_T_1 : integer range 0 to 10000000:=0;
  signal cnt_DV_GC_T_1 : integer range 0 to 10000000:=0;
  signal cnt_DV_HV_T_1 : integer range 0 to 10000000:=0;
signal clk_uart  : std_logic;
signal clk_Main  : std_logic;
signal Temp_data : std_logic_vector(12 - 1 downto 0);


signal Phase_sync_skew_test: std_logic_vector(1 downto 0);


signal  clk_ADC : std_logic;
signal SW_Write_init : std_logic:='0';

type t_Memory is array (0 to 11) of std_logic_vector(7 downto 0);
signal w_RX_BYTE_out : t_Memory;



signal  Data_Byte_Bat: std_logic_vector(7 downto 0);
signal        Rdy_Tx_Bat : std_logic               := '0';

signal r_TX_DV_Bat     : std_logic                    := '0';
signal r_TX_BYTE_Bat   : std_logic_vector(7 downto 0) := (others => '0');

signal w_TX_DONE_Bat   : std_logic;
signal w_RX_DV_Bat     : std_logic;
signal w_RX_BYTE_Bat   : std_logic_vector(7 downto 0);
signal w_RX_BYTE_out_Bat_H   : std_logic_vector(7 downto 0);
signal w_RX_BYTE_out_Bat_M   : std_logic_vector(7 downto 0);
signal w_RX_BYTE_out_Bat_L   : std_logic_vector(7 downto 0);

    signal Power_kill_flag : std_logic:='0';
    signal Power_kill_flag_buf : std_logic_vector(1 downto 0):="00";
    signal Power_kill_en : std_logic:='0';
    signal Power_kill_on : std_logic:='0'; 
    
    
    signal GC_flag : std_logic:='0';      
    signal  GC_flag_buf: std_logic_vector(1 downto 0):="00";   
    signal GC_en : std_logic:='0';   
    
     signal HV_flag : std_logic:='0';      
    signal  HV_flag_buf: std_logic_vector(1 downto 0):="00";   
     signal HV_Contr_Write_HV_flag : std_logic:='0';      
    signal HV_Contr_Write_HV_flag_buf: std_logic_vector(1 downto 0):="00";       
    
    
    signal HV_en : std_logic:='0';      
    signal HV_Buf : std_logic_vector(11 downto 0):="000000000000";
    signal HV_buf_Sm  : std_logic_vector(11 downto 0):="000000000000";
signal Hold_cnt   : std_logic_vector(1 downto 0):="00";

signal SC_Start : std_logic:='0';     
signal Ch_all : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal flag_acq_out  : std_logic:='0';   
signal Pileup_ce_T : std_logic;
signal R_Counter_RAM : std_logic;
-----------------------------------------------------------------------------
   signal m_addr     : std_logic_vector(0 downto 0);
    signal m_din      : std_logic_vector(7 downto 0);
    signal m_din_last : std_logic;
    signal m_din_vld  : std_logic;
    signal m_ready    : std_logic;

    signal m_dout_vld : std_logic;

    signal s_din      : std_logic_vector(7 downto 0);
    signal s_din_vld  : std_logic;
    signal s_ready    : std_logic;
    signal s_dout     : std_logic_vector(7 downto 0);
    signal s_dout_vld : std_logic;
    
   signal m_addr_2     : std_logic_vector(0 downto 0);
     signal m_din_2      : std_logic_vector(7 downto 0);
     signal m_din_last_2 : std_logic;
     signal m_din_vld_2  : std_logic;
     signal m_ready_2    : std_logic;
 
     signal m_dout_vld_2 : std_logic;
 
     signal s_din_2      : std_logic_vector(7 downto 0);
     signal s_din_vld_2  : std_logic;
     signal s_ready_2    : std_logic;
     signal s_dout_2     : std_logic_vector(7 downto 0);
     signal s_dout_vld_2 : std_logic;    
    
    signal m_dout_2  : std_logic_vector(7 downto 0);
    constant SLAVE_COUNT : integer := 1;
     signal Trape_in : std_logic_vector(13 downto 0);
  -- signal GC_High : std_logic_vector(7 downto 0):=X"4A";

  ------------------------------------------------------------ ------------------------------------------------------------  ------------------------------------------------------------
 signal GM_En : std_logic:='1';
   signal Domino_En :  std_logic:='0';
   
      
     --signal GC : std_logic_vector(15 downto 0):=X"6978";  --27000
    signal GC : std_logic_vector(15 downto 0):=X"8340";  --33600 V/V 


   signal HV_DAC : std_logic_vector(15 downto 0):=X"8A80"; -- HV     35456

   
   
      signal HV_ADC : std_logic_vector(11 downto 0):=X"9B0"; -- HV �ʱ� ��

      signal Cs137_32KeV : std_logic_vector(15 downto 0):=X"000F"; -- Cs137_32KeV      15
      signal Cs137_662KeV : std_logic_vector(15 downto 0):=X"018A"; -- Cs137_662KeV    394    
      signal K40_1460KeV : std_logic_vector(15 downto 0):=X"036B"; -- K40      875
      
       signal Det_label : std_logic_vector(15 downto 0):=X"002E"; -- Detector          
            
      signal HV_Gap : std_logic_vector(11 downto 0):=X"000";

      signal Serial_1 :  std_logic_vector(7 downto 0):=X"48";  --H
      signal Serial_2 :  std_logic_vector(7 downto 0):=X"48";  --H
      signal Serial_3 :  std_logic_vector(7 downto 0):=X"33";  --3
      signal Serial_4 :  std_logic_vector(7 downto 0):=X"41";  --A
      signal Serial_5 :  std_logic_vector(7 downto 0):=X"41";  --A
      signal Serial_6 :  std_logic_vector(7 downto 0):=X"32";  --2
      signal Serial_7 :  std_logic_vector(7 downto 0):=X"34";  --4 
  
  
      signal BNC_Serial_1 :  std_logic_vector(7 downto 0):=X"47";  --G
      signal BNC_Serial_2 :  std_logic_vector(7 downto 0):=X"33";  --3
      signal BNC_Serial_3 :  std_logic_vector(7 downto 0):=X"41";  --A
      signal BNC_Serial_4 :  std_logic_vector(7 downto 0):=X"41";  --A
      signal BNC_Serial_5 :  std_logic_vector(7 downto 0):=X"34";  --4
      signal BNC_Serial_6 :  std_logic_vector(7 downto 0):=X"38";  --8
       
 ------------------------------------------------------------  ------------------------------------------------------------  ------------------------------------------------------------

    signal     Write_GC_flag  : std_logic:='0';
    signal     Write_GC_flag_buf  : std_logic:='0';     
        signal     Write_HV_flag  : std_logic:='0';  
        signal      HV_Fix : std_logic:='0'; 
        signal XADC_Rst : std_logic:='1';
    signal RaspberryPi_Power_Kill_Buf : std_logic:='0';     
  
            signal HV_Contr_Rdy : std_logic:='0';
---------------------------------------------------------------------------
    signal  clk_XADC : std_logic;

        
    signal MEASURED_TEMP      : std_logic_vector(15 downto 0);
    signal MEASURED_VCCAUX      : std_logic_vector(15 downto 0);
    signal MEASURED_VCCINT      : std_logic_vector(15 downto 0);    
    signal MEASURED_VCCBRAM      : std_logic_vector(15 downto 0);
    signal MEASURED_AUX0      : std_logic_vector(15 downto 0);
    signal MEASURED_AUX1      : std_logic_vector(15 downto 0);
    signal MEASURED_AUX2      : std_logic_vector(15 downto 0);            
    signal MEASURED_AUX3      : std_logic_vector(15 downto 0);    
    
    signal ALM : std_logic_vector(7 downto 0);
    signal CHANNEL  : std_logic_vector(4 downto 0);
    
     signal   OT   : std_logic;
   signal EOC      : std_logic;
      signal    EOS : std_logic;
  
     signal MEASURED_TEMP_buf      : std_logic_vector(15 downto 0);   

   signal     MEASURED_VCCAUX_buf      :  std_logic_vector(15 downto 0);
   signal     MEASURED_VCCINT_buf      :  std_logic_vector(15 downto 0);    
   signal      MEASURED_VCCBRAM_buf      :  std_logic_vector(15 downto 0);
    signal MEASURED_AUX0_buf      : std_logic_vector(15 downto 0);
  signal      MEASURED_AUX1_buf      :  std_logic_vector(15 downto 0);
  signal      MEASURED_AUX2_buf      :  std_logic_vector(15 downto 0);            
  signal       MEASURED_AUX3_buf      :  std_logic_vector(15 downto 0);    
        
  signal      ALM_buf :  std_logic_vector(7 downto 0);
   signal     CHANNEL_buf  :  std_logic_vector(4 downto 0);
        
  signal         OT_buf   :  std_logic;
   signal     EOC_buf      :  std_logic;
   signal          EOS_buf :  std_logic;   
      
   signal clk_1ns_T : std_logic;
   signal o_data_valid_buf : std_logic;
  signal Time_counter : integer range 0 to 1000000000:=0;    
  signal TX_count: integer range 0 to 1000000:=0;
  signal TX_Hold_count: integer range 0 to 1000000:=0;
    signal  w_RX_Test : std_logic;
  signal cnt_HV_Contr : integer range 0 to 1000000:=0;    
---------------------------------------------------------------------------
signal SC_Stamp : std_logic_vector(15 downto 0):="0000000000000000";
signal SC_time : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal SC_CH : std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal SC_Counter  : std_logic_vector(4 downto 0):="00000";
signal SC_take: std_logic:='0';
signal SC_Time_counter: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
---------------------------------------------------------------------------
signal i_GS_on  : std_logic_vector(1 downto 0):="00";
signal GS_on : std_logic:='0';
signal GS_Counter : std_logic_vector(5 downto 0):="000000";
---------------------------------------------------------------------------
signal SR_on_pipe  : std_logic_vector(1 downto 0):="00";
signal SR_on : std_logic:='0';
signal SR_Counter : integer range 0 to 63:=0;
-------------------------------------------------------
signal ADC_inv :  std_logic_vector(11 downto 0);
signal ADC_inv_BUF :  std_logic_vector(13 downto 0);
signal rst : std_logic:='0';
signal acq_start : std_logic:='0';
signal Trapezoidal_out : std_logic_vector(13 downto 0);
signal Trapezoidal_out_SC : std_logic_vector(13 downto 0);
signal dout_CH: std_logic_vector(12 downto 0);
signal  flag_CH : std_logic;
signal flag_CH_SCA : std_logic;


signal  RaspberryPi_Power_Timer  : integer range 0 to  100000:=0;  	  
signal	RaspberryPi_Power_Timer_on : std_logic:='0';

signal 	 led_on_Timer_on  : std_logic:='1';
signal	 led_on_Timer  : integer range 0 to 1600000000:=0;
                                             


signal cnt_on  : std_logic:='1';
signal	 cnt  : integer range 0 to 10000:=0; 

signal clk_100ms_T  : std_logic:='0';

signal Header_counter: std_logic_vector(2 downto 0):="000";
signal Tail_counter: std_logic_vector(2 downto 0):="000";

---------------------------------------------------------------------------
         signal Main_Threshold : std_logic_vector(12 downto 0):="0000000101000"; 
         signal Main_Threshold_buf : std_logic_vector(12 downto 0):="0000000101000"; 
         signal Main_Signal_TIME_1 : std_logic_vector(6 downto 0):="0001010";

         signal    Main_Data_subtraction_1 : std_logic_vector(12 downto 0):="0000000000000";
---------------------------------------------------------------------------
         signal flag_out : std_logic;
         signal flag_init : std_logic;
         signal flag_check : std_logic;
         SIGNAL flag_ram : std_logic;
         signal  Swich:  std_logic_vector(3 downto 0);
                signal            acq_done :  std_logic:='0'; --SLCS
                 
               signal          acq_take :  std_logic:='0';
                     
              signal           acq_rd_clk :  std_logic;       
          signal    Spec_out:  std_logic_vector(15 downto 0);  
          signal    uart_wait_cnt : integer range 0 to 10000000 := 0;
          signal    uart_rx_su_cnt : integer range 0 to 63 := 0;
 ---------------------------------------------------------------------------        
         
type Master_state_1 is (UART_idle , UART_1st_Trans , UART_1st_Trans_Hold, UART_2nd_Trans ,UART_2nd_Trans_Hold,UART_Header_Trans, UART_Header_Trans_Hold,
UART_2nd_Header_Trans, UART_Tail_Trans,UART_Tail_Trans_Hold,UART_2nd_Tail_Trans, UART_Hold_Timer,UART_SC_Trans,UART_SC_Trans_Hold,UART_GS_Trans,UART_GS_Trans_Hold,
UART_SR_Trans,UART_SR_Trans_Hold, UART_end);
signal UART_state : Master_state_1;

type Master_state_2 is (UART_RX_idle , UART_1st_Command_RX, UART_RX_1st , UART_RX_2nd, UART_RX_3rd, UART_RX_4th, UART_RX_5th, UART_RX_6th, UART_RX_7th,  
UART_RX_8th, UART_RX_9th,  UART_RX_10th, UART_RX_end, UART_RX_Command,UART_RX_cl_1st ,UART_RX_cl_2nd ,UART_RX_cl_3rd ,UART_RX_cl_4th ,UART_RX_cl_5th ,UART_RX_cl_6th
 ,UART_RX_cl_7th ,UART_RX_cl_8th ,UART_RX_cl_9th  ,UART_RX_cl_10th ,UART_RX_cl_11th ,UART_RX_cl_12th ,UART_RX_cl_13th ,UART_RX_cl_14th 
 ,UART_RX_cl_15th ,UART_RX_cl_16th ,UART_RX_cl_17th ,UART_RX_cl_18th ,UART_RX_cl_19th ,UART_RX_cl_20th ,UART_RX_cl_21th ,UART_RX_cl_22th ,UART_RX_cl_23th 
 ,UART_RX_cl_24th ,UART_RX_cl_25th ,UART_RX_cl_26th ,UART_RX_cl_27th ,UART_RX_cl_28th,UART_RX_su,UART_RX_SW,UART_RX_TC,UART_RX_Init_W  );
signal UART_RX_state : Master_state_2;

signal serial_write_en : std_logic:='0';
signal SW_cnt : integer range 0 to 15:= 0;
signal TC_cnt : integer range 0 to 15:= 0;
signal Init_cnt : integer range 0 to 15:= 0;
signal init_wr_en : std_logic:='0';
signal init_wr_en_pipe : std_logic_vector(1 downto 0):="00";
signal init_wr_addr : std_logic_vector(24 - 1 downto 0):=X"000000";
signal init_wr_data : std_logic_vector(24 - 1 downto 0):=X"000000";







   
type Master_GC_SPI_state is (SPI_GC_idle , SPI_GC_1st_Trans , SPI_GC_1st_Trans_Hold, SPI_GC_2nd_Trans ,SPI_GC_2nd_Trans_Hold, SPI_GC_3rd_Trans, SPI_GC_end);
signal SPI_GC_state : Master_GC_SPI_state;

type Master_HV_SPI_state is (SPI_HV_idle , SPI_HV_1st_Trans , SPI_HV_1st_Trans_Hold, SPI_HV_2nd_Trans ,SPI_HV_2nd_Trans_Hold, SPI_HV_3rd_Trans, SPI_HV_end);
signal SPI_HV_state : Master_HV_SPI_state;

signal  cpu_detect_pipe    : std_logic_vector(1 downto 0);
signal  power_switching_en : std_logic;
signal  power_switching_end : std_logic:='0';
signal  cpu_phold_buf : std_logic := '0';
signal  power_down_cnt : integer:=0;
signal led_cnt : integer:=0;
signal GC_Cal_data : std_logic_vector(16 - 1 downto 0);
signal Temp_Cal_data : std_logic_vector(16 - 1 downto 0);
signal peak32_Cal_data : std_logic_vector(16 - 1 downto 0);
signal peak662_Cal_data : std_logic_vector(16 - 1 downto 0);
signal peak1460_Cal_data : std_logic_vector(16 - 1 downto 0);
signal GC_Change_cnt : integer range 0 to 10000000:= 0;
signal hv_write_en  : std_logic:='0';
signal cl_write_en  : std_logic:='0';
signal su_write_en  : std_logic:='0';
signal su_write_en_pipe  : std_logic_vector(1 downto 0):="00";
signal su_write_en_pipe_1d  : std_logic_vector(1 downto 0):="00";
signal temp_correction_on : std_logic:='1';
signal Gm_count_pre_1s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_2s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_3s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_4s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_5s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_6s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_7s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_8s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_9s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_10s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_11s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_12s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_13s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_14s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_15s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_16s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_17s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_18s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_19s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_20s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_21s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_22s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_23s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_24s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_25s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_26s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_27s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_28s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_29s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_30s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_31s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_32s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_33s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_34s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_35s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_36s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_37s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_38s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_39s : std_logic_vector(6 downto 0) := "0000000";
signal Gm_count_pre_40s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_41s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_42s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_43s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_44s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_45s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_46s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_47s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_48s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_49s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_50s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_51s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_52s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_53s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_54s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_55s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_56s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_57s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_58s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_59s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_60s : std_logic_vector(6 downto 0):= "0000000";
signal Gm_count_pre_sum : std_logic_vector(6 downto 0):= "0000000";

signal i_Gm_count : std_logic_vector(1 downto 0):= "00";

signal GM_count_wait_cnt: integer := 0;
signal GM_count_wait_on : std_logic:= '0';

--signal Sleep_en : std_logic:='0';
signal Gm_time_count : integer:=0;

signal Gm_count_out : std_logic_vector(16 downto 0);
signal Gm_count : std_logic_vector(6 downto 0);
signal Gm_count_read : std_logic;
signal Gm_count_read_pipe : std_logic_vector(1 downto 0);
signal adc_read_cnt : integer range 0 to 10000000:=0;

signal GM_count_Threshold : std_logic_vector(7 downto 0) := "00000010";
signal GM_count_Threshold_read : std_logic_vector(7 downto 0);
signal GM_count_Threshold_write : std_logic_vector(7 downto 0);
signal eeprom_read_end : std_logic:= '0';
attribute mark_debug : string;
attribute keep : string;
attribute mark_debug of r_RX_SERIAL : signal is "true";
attribute mark_debug of w_TX_SERIAL : signal is "true";
attribute mark_debug of peak32_cal_data : signal is "true";
attribute mark_debug of peak662_cal_data : signal is "true";
attribute mark_debug of peak1460_cal_data : signal is "true";
attribute mark_debug of GC_cal_data : signal is "true";
attribute mark_debug of write_gc_flag : signal is "true";
attribute mark_debug of GC_Cal_out : signal is "true";

begin

--test1 <= '1' when cpu_detect ='1' else '0';
--cpu_phold <= '0' when cpu_detect ='1' else '1';
cpu_phold <= cpu_phold_buf;
--test1 <= cpu_phold_buf;

--HV_Enable <= '0';
--adc_sleep <= '1';

process(clk_Main)
begin
    if(rising_edge(clk_Main))then
        Temp_data <= Adc_temp_data(15 downto 4);     
    end if;
end process;




process(clk_Main)
begin
    if(rising_edge(clk_Main))then
        if(led_cnt = 100000000) then
            led_cnt <= 0;
        else
            led_cnt <= led_cnt + 1;
        end if;     
    end if;
end process;


--rd_en_start <= power_switching_en


process(clk_Main)
begin
    if(rising_edge(clk_Main))then
        cpu_detect_pipe <= cpu_detect_pipe(0) &  cpu_detect;
    end if;
end process;

        




--test2 <= r_RX_SERIAL_buf;

process(clk_Main)
begin
    if(rising_edge(clk_uart))then    
       r_RX_SERIAL_buf <= r_RX_SERIAL;
 
    end if;
end process;
	i_UART_RX: UART_RX 

  generic map (
      g_CLKS_PER_BIT => c_CLKS_PER_BIT
      )

	PORT MAP(
		i_Clk => clk_uart,
      i_rx_serial => r_RX_SERIAL,
--      i_rx_serial => test2,
      o_rx_dv     => w_RX_DV,
      o_rx_byte   => w_RX_BYTE
	);
--w_TX_SERIAL <= w_TX_SERIAL_buf;
--test1 <= w_TX_SERIAL_buf;
  	i_UART_TX: UART_TX 
    generic map (
      g_CLKS_PER_BIT => c_CLKS_PER_BIT
      )
	PORT MAP(
		i_Clk => clk_uart,
      i_tx_dv     => r_TX_DV,
      i_tx_byte   => r_TX_BYTE,
      o_tx_active => open,
      o_tx_serial => w_TX_SERIAL,
      o_tx_done   => w_TX_DONE
	);







    master_i : SPI_MASTER
    generic map(
        CLK_FREQ    => 10e6,
        SCLK_FREQ   => 1e6,
        SLAVE_COUNT => SLAVE_COUNT
    )
    port map (
        CLK      => clk_Uart,
        RST      => '0',
        -- SPI MASTER INTERFACE
        SCLK     => sclk,
        CS_N     => cs_n,
        MOSI     => mosi,
        MISO     => miso,
        -- USER INTERFACE
        ADDR     => m_addr,
        DIN      => m_din,
        DIN_LAST => m_din_last,
        DIN_VLD  => m_din_vld,
        READY    => m_ready,
        DOUT     => m_dout,
        DOUT_VLD => m_dout_vld
    );

   master_iI : SPI_MASTER
    generic map(
        CLK_FREQ    => 10e6,
        SCLK_FREQ   => 1e6,
        SLAVE_COUNT => SLAVE_COUNT
    )
    port map (
        CLK      => clk_uart,
        RST      => '0',
        -- SPI MASTER INTERFACE
        SCLK     => sclk_2,
        CS_N     => cs_n_2,
        MOSI     => mosi_2,
        MISO     => miso_2,
        -- USER INTERFACE
        ADDR     => m_addr_2,
        DIN      => m_din_2,
        DIN_LAST => m_din_last_2,
        DIN_VLD  => m_din_vld_2,
        READY    => m_ready_2,
        DOUT     => m_dout_2,
        DOUT_VLD => m_dout_vld_2
    );

i_clk_wiz_0 : clk_wiz_0 
PORT map(
       clk_out1  => clk_Main,
       clk_out2  => clk_uart,
        clk_out3 => clk_ADC,
--         clk_XADC=> clk_XADC,
       reset  => '0',
       locked => open,
        clk_in1 => clk
        );
        
i_Clk_1ns  :  Clk_1ns 
PORT map(
        clk=> clk_uart,
	clk_1ns=> clk_1ns_T
	);

i_clk_100ms  :  clk_100ms 
PORT map(
        clk=> clk_Main,
	clk_100ms=> clk_100ms_T
	);




i_ADC_invert : ADC_invert 
PORT map(
	clk => clk_Main,
	ADC_ORT=>ADC_ORT,
	ADC_value => ADC_value,
	inva =>ADC_inv
        ); 

i_SCA_Module : SCA_Module
PORT map(
	clk=> clk_Main,
	rst=> rst,
	acq_start=>SC_Start,
    Ch_all=>Ch_all,  
	flag_acq_in =>SC_take,
	flag_CH=>flag_CH_SCA
	);	
i_Smoothing_Shifter_SC  : Smoothing_Shifter 
PORT map(
	 clk=> clk_Main,	
	rst=>'1',
	acq_start=>SC_start,
	data_in=>ADC_inv_buf,
	Trapezoidal_out =>Trapezoidal_out_SC	
	);
ADC_inv_BUF <=  ADC_inv & "00";
i_Radiation_detect14bit_8192 : Radiation_detect14bit_8192 
PORT map(
	clk=> clk_Main,
	rst=> rst,
	acq_start=>acq_start,
	--CH_ACQ: In std_logic;
	--ADC_ORT : in std_logic;
	--flag_data_stop : inout std_logic;
	flag_start=>open,
	Trapezoidal_out=>Trapezoidal_out, 
	Threshold =>Main_Threshold,
	Signal_TIME=>Main_Signal_TIME_1,
	Data_subtraction=>Main_Data_subtraction_1,

		--Pileup_ce =>Pileup_ce_T,
	--Ch_Data_subtraction_all : in std_logic_vector(11 downto 0);
	data_in=>ADC_inv_BUF,
	dout_CH=>dout_CH,
	flag_CH=>flag_CH
    );


i_Radiation_SCA14bit : Radiation_SCA14bit
PORT map(
	clk=> clk_Main,
	rst=> rst,
	acq_start=>SC_Start,
	--CH_ACQ: In std_logic;
	--ADC_ORT : in std_logic;
	--flag_data_stop : inout std_logic;
	flag_start=>open,
	Trapezoidal_out=>Trapezoidal_out_SC, 
	Threshold =>Main_Threshold,
	Signal_TIME=>Main_Signal_TIME_1,
	Data_subtraction=>Main_Data_subtraction_1,

		--Pileup_ce =>Pileup_ce_T,
	--Ch_Data_subtraction_all : in std_logic_vector(11 downto 0);
	data_in=>ADC_inv_BUF,
	--dout_CH=>dout_CH,
	flag_CH=>flag_CH_SCA
    ); 

    

i_RAM_Spectrum_H  : RAM_Spectrum 
PORT map(
            clk=> clk_Main,	
			clk_RAM => clk_ADC,
			rst=> rst,
			Swich_mode=> Swich,
			GM_count=> Pin_Trig_signal,
			laser_count => '0',
			neutron_count => '0',
			flag_check =>flag_check,
			
			flag_init=>flag_init,
			acq_done => acq_done,
			flag_out=>flag_out,
			acq_take=> acq_take, -- Read Start
			acq_count  => acq_rd_clk, -- Read RAM Addr
			acq_start=> acq_start,
			flag_aq_1  => flag_CH,
            bat_adc_in=> bat_adc_in,
            Pileup_sp_T =>Pileup_ce_T,
            GM_En=>GM_En,
            Neutron_En=>Domino_En,
            Det_label=>Det_label,
            R_Counter_RAM =>R_Counter_RAM,            
            MEASURED_TEMP_in=> MEASURED_TEMP_Buf,
            MEASURED_VCCAUX_in=>MEASURED_VCCAUX_Buf, 
            MEASURED_VCCINT_in=> MEASURED_VCCINT_Buf,
            adc_temp_in => adc_temp_data,
            adc_3p3_in  => adc_3p3_data,
            adc_2p8_in  => adc_2p8_data,
            adc_1p8_in  => adc_1p8_data,
            adc_1p0_in  => adc_1p0_data,
            GC=>GC, 
            HV_DAC=>HV_DAC,

			HV_buf_Sm =>HV_buf_Sm,
			Bat_Status_in =>Bat_Status_in,
			flag_ram=>flag_ram,
			
			data_in_1  => dout_CH,

			Spec_out =>Spec_out 
		);	



i_Smoothing_Shifter  : Smoothing_Shifter 
PORT map(
	 clk=> clk_Main,	
	rst=>'1',
	acq_start=>acq_start,
	data_in=>ADC_inv_buf,
	Trapezoidal_out =>Trapezoidal_out	
	);











process(clk_uart) --UART_TX
begin
    
	if rising_edge(clk_uart) then
		
	case UART_state is
     when UART_idle =>		
		cnt_DV <= 0;
         r_TX_DV   <= '0';
		acq_rd_clk<='0';
          Header_Counter <="000"; 
          Tail_counter<="000";
          TX_Hold_count<=0;  
          
         SC_Counter<="00000";  
         GS_Counter<="000000";  
         SR_Counter<=0;  
         i_GS_on(0)<=GS_on;
         i_GS_on(1)<=i_GS_on(0);
         SR_on_pipe <= SR_on_pipe(0) & SR_on;
         
		if  acq_start = '1' then
            if Time_counter = 10000000 then
                  UART_state  <= UART_Header_Trans;
                  Time_counter<=0;
                       
                   acq_take<='1';
	         else
	           Time_counter <= Time_counter + 1;
	           acq_take<='0';
	         end if;   
	     elsif  SC_start = '1' then
            if Time_counter = 3000000 then
                  UART_state  <= UART_SC_Trans;
                  Time_counter<=0;
                  SC_CH<=Ch_all;     
                   SC_take<='1';
                  if SC_Stamp = "1111111111111111" then
                     SC_Stamp<= "0000000000000000";
                   else  
                    SC_Stamp<=SC_Stamp+'1';
                  end if;  
                   SC_Time<=SC_Time_counter;
                   SC_Time_counter<="00000000000000000000000000000000";
	         else
	        
	         
	           Time_counter <= Time_counter + 1;
	           SC_take<='0';
	           SC_Time_counter<=SC_Time_counter + '1';
	         end if;   	         
	         
         else
          if i_GS_on(0) > i_GS_on(1) then
	           UART_state  <= UART_GS_Trans;
	         end if;  
	       if SR_on_pipe = "01" then
	           UART_state  <= UART_SR_Trans;
	       end if;
           acq_take<='0';  
           SC_take<='0';              
            Time_counter<=0;
            SC_Stamp<="0000000000000000";
            SC_Time_counter<="00000000000000000000000000000000";
         end if;
		
	 when Uart_1st_Trans =>		
		 r_TX_DV   <= '1';     
       
          r_TX_BYTE<=Spec_out(15 downto 8);
            
          UART_state  <=UART_1st_Trans_Hold;
         Time_counter <= Time_counter + 1;
    when UART_1st_Trans_Hold =>	  
           r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
               acq_rd_clk<='0';
              UART_state  <= UART_2nd_Trans;
           
          end if;
          Time_counter <= Time_counter + 1;
     when UART_2nd_Trans =>       
  		 r_TX_DV   <= '1';     
       
          r_TX_BYTE<=Spec_out(7 downto 0);
            
          UART_state  <=UART_2nd_Trans_Hold;
         Time_counter <= Time_counter + 1;                         

		 
	    when UART_2nd_Trans_Hold =>	  	 
           r_TX_DV   <= '0';    
     
          if  w_TX_DONE = '1' then
          
            if TX_count = 2082 then
                
                TX_count<=0;
                UART_state  <= UART_Tail_Trans;    
                --XADC_Rst<='0';    
                                           
            elsif TX_count = 0 then
                 TX_count<=TX_count+1;
                 UART_state  <= UART_1st_Trans;
                                         
            else       
                acq_rd_clk <='1';
                 TX_count<=TX_count+1;
                 UART_state  <= UART_1st_Trans;
            end if;
          end if;
	     Time_counter <= Time_counter + 1; 
	when UART_Header_Trans =>
	       r_TX_DV   <= '1';     
       
          r_TX_BYTE<=X"55";--ASCII "U"
            
          UART_state  <=UART_Header_Trans_Hold;
         Time_counter <= Time_counter + 1;
         
	when UART_Header_Trans_Hold =>	
		r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
              
              UART_state  <= UART_2nd_Header_Trans;
           
          end if;
          Time_counter <= Time_counter + 1;
          
 	when UART_2nd_Header_Trans =>         
	       r_TX_DV   <= '1';     
	       r_TX_BYTE<=X"55";--ASCII "U"
--       if Header_Counter ="000" then
--          r_TX_BYTE<=X"30";--ASCII "0"
--       elsif Header_Counter ="001" then    
--          r_TX_BYTE<=X"31";--ASCII "1"  
--       elsif Header_Counter ="010" then    
--          r_TX_BYTE<=X"32";--ASCII "2"            
--       elsif Header_Counter ="011" then    
--          r_TX_BYTE<=X"33";--ASCII "3"            
--        elsif Header_Counter ="100" then    
--          r_TX_BYTE<=X"34";--ASCII "4"   
--        end if;   
                        
         UART_state  <=UART_2nd_Trans_Hold;
         Time_counter <= Time_counter + 1;  
         Header_Counter<=Header_Counter +'1';   
    
	when UART_Tail_Trans =>	 	
	       r_TX_DV   <= '1';     
       
          r_TX_BYTE<=X"46"; --ASCII "F"
            
          UART_state  <=UART_Tail_Trans_Hold;
         Time_counter <= Time_counter + 1;
         
 	when UART_Tail_Trans_Hold =>	
		r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
              
              UART_state  <= UART_2nd_Tail_Trans;
           
          end if;
          Time_counter <= Time_counter + 1;        	
	when UART_2nd_Tail_Trans =>	 	
	       r_TX_DV   <= '1';     
       
          r_TX_BYTE<=X"46"; --ASCII "F"
 
            Tail_counter<="000";
             UART_state  <=UART_end;
   
         
         Time_counter <= Time_counter + 1;	 
     when UART_Hold_Timer=>
           Time_counter <= Time_counter + 1;	
--          if TX_Hold_count =  10000 then -- 1ms --TEST
          if TX_Hold_count =  50000 then -- 5ms -- SPRD
             TX_Hold_count<=0;
             UART_state  <=UART_Header_Trans;
          else
             TX_Hold_count<=TX_Hold_count+1;
          end if;   

 when UART_SC_Trans=>
       r_TX_DV   <= '1';     
       if SC_Counter ="0000" then
          r_TX_BYTE<=X"4C";--ASCII "L"
          UART_state  <=UART_SC_Trans_Hold;         
       elsif SC_Counter ="0001" then    
          r_TX_BYTE<=X"53";--ASCII "S" 
          UART_state  <=UART_SC_Trans_Hold;   
       elsif SC_Counter ="0010" then    
          r_TX_BYTE<=SC_CH(31 downto 24);  
          UART_state  <=UART_SC_Trans_Hold;             
       elsif SC_Counter ="0011" then    
          r_TX_BYTE<=SC_CH(23 downto 16);  
          UART_state  <=UART_SC_Trans_Hold;            
        elsif SC_Counter ="0100" then    
          r_TX_BYTE<=SC_CH(15 downto 8);  
          UART_state  <=UART_SC_Trans_Hold;    
        elsif SC_Counter ="0101" then    
          r_TX_BYTE<=SC_CH(7 downto 0);    
          UART_state  <=UART_SC_Trans_Hold;          
         elsif SC_Counter ="0110" then    
          r_TX_BYTE<=SC_time(31 downto 24);   
          UART_state  <=UART_SC_Trans_Hold;            
       elsif SC_Counter ="0111" then    
          r_TX_BYTE<=SC_time(23 downto 16);  
          UART_state  <=UART_SC_Trans_Hold;            
        elsif SC_Counter ="1000" then    
          r_TX_BYTE<=SC_time(15 downto 8);    
          UART_state  <=UART_SC_Trans_Hold;  
        elsif SC_Counter ="1001" then    
          r_TX_BYTE<=SC_time(7 downto 0);   
          UART_state  <=UART_SC_Trans_Hold;  
        elsif SC_Counter ="1010" then    
          r_TX_BYTE<=SC_stamp(15 downto 8); 
          UART_state  <=UART_SC_Trans_Hold;     
        elsif SC_Counter ="1011" then    
          r_TX_BYTE<=SC_stamp(7 downto 0);   
          UART_state  <=UART_SC_Trans_Hold;            
        elsif SC_Counter ="1100" then    
          r_TX_BYTE<=X"36";--ASCII "6"   
          UART_state  <=UART_SC_Trans_Hold;  
        elsif SC_Counter ="1101" then    
          r_TX_BYTE<=X"36";--ASCII "6"    
          UART_state  <=UART_end;          
        end if;   
                        
        SC_Time_counter<=SC_Time_counter + '1';
         Time_counter <= Time_counter + 1;  
         SC_Counter<=SC_Counter +'1';   

	when UART_SC_Trans_Hold =>	
		r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
              
              UART_state  <= UART_SC_Trans;
           
          end if;
          Time_counter <= Time_counter + 1;
         SC_Time_counter<=SC_Time_counter + '1';    
         
     when UART_GS_Trans=>       
        r_TX_DV   <= '1';     
       if GS_Counter ="0000" then
          r_TX_BYTE<=X"47";--ASCII "G"
          UART_state  <=UART_GS_Trans_Hold;         
       elsif GS_Counter ="0001" then    
          r_TX_BYTE<=X"44";--ASCII "D" 
          UART_state  <=UART_GS_Trans_Hold;   
       elsif GS_Counter ="0010" then    
          r_TX_BYTE<=GC_buf(15 downto 8);--GC
          UART_state  <=UART_GS_Trans_Hold;             
       elsif GS_Counter ="0011" then    
          r_TX_BYTE<=GC_buf(7 downto 0);--GC
          UART_state  <=UART_GS_Trans_Hold;             
       elsif GS_Counter ="0100" then    
          r_TX_BYTE<=K40_1460KeV(15 downto 8);--K40_1460KeV
          UART_state  <=UART_GS_Trans_Hold;   
       elsif GS_Counter ="0101" then    
          r_TX_BYTE<=K40_1460KeV(7 downto 0);--K40_1460KeV
          UART_state  <=UART_GS_Trans_Hold;                 
       elsif GS_Counter ="0110" then    
          r_TX_BYTE<=Det_label(15 downto 8);--Det_label
          UART_state  <=UART_GS_Trans_Hold;   
       elsif GS_Counter ="0111" then    
          r_TX_BYTE<=Det_label(7 downto 0);--Det_label
          UART_state  <=UART_GS_Trans_Hold;     
       elsif GS_Counter ="1000" then    
          r_TX_BYTE<=Cs137_32KeV(15 downto 8);--Cs137_32KeV
          UART_state  <=UART_GS_Trans_Hold;   
       elsif GS_Counter ="1001" then    
          r_TX_BYTE<=Cs137_32KeV(7 downto 0);--Cs137_32KeV
          UART_state  <=UART_GS_Trans_Hold;                 
       elsif GS_Counter ="1010" then    
          r_TX_BYTE<=Cs137_662KeV(15 downto 8);--Cs137_662KeV
          UART_state  <=UART_GS_Trans_Hold;   
       elsif GS_Counter ="1011" then    
          r_TX_BYTE<=Cs137_662KeV(7 downto 0);--Cs137_662KeV
          UART_state  <=UART_GS_Trans_Hold;  
          
       elsif GS_Counter ="1100" then    
          r_TX_BYTE<=Serial_1;
          UART_state  <=UART_GS_Trans_Hold;  
          elsif GS_Counter ="1101" then    
          r_TX_BYTE<=Serial_2;
          UART_state  <=UART_GS_Trans_Hold;
          elsif GS_Counter ="1110" then    
          r_TX_BYTE<=Serial_3;
          UART_state  <=UART_GS_Trans_Hold;
          elsif GS_Counter ="1111" then    
          r_TX_BYTE<=Serial_4;
          UART_state  <=UART_GS_Trans_Hold;
          elsif GS_Counter ="10000" then    
          r_TX_BYTE<=X"54"; -- T(ASCII)
          UART_state  <=UART_GS_Trans_Hold;
          elsif GS_Counter ="10001" then    
          r_TX_BYTE<="0000"&temp_buf(15 downto 12);--temp
          UART_state  <=UART_GS_Trans_Hold;
          elsif GS_Counter ="10010" then    
          r_TX_BYTE<=temp_buf(11 downto 4); --temp
          UART_state  <=UART_GS_Trans_Hold;
          elsif GS_Counter ="10011" then    
          r_TX_BYTE<=BNC_Serial_1;
          UART_state  <=UART_GS_Trans_Hold;        
           elsif GS_Counter ="10100" then    
          r_TX_BYTE<=BNC_Serial_2;
          UART_state  <=UART_GS_Trans_Hold;             
           elsif GS_Counter ="10101" then    
          r_TX_BYTE<=BNC_Serial_3;
          UART_state  <=UART_GS_Trans_Hold;             
          elsif GS_Counter ="10110" then    
          r_TX_BYTE<=BNC_Serial_4;
          UART_state  <=UART_GS_Trans_Hold;              
           elsif GS_Counter ="10111" then    
          r_TX_BYTE<=BNC_Serial_5;
          UART_state  <=UART_GS_Trans_Hold;             
            elsif GS_Counter ="11000" then    
          r_TX_BYTE<=BNC_Serial_6;
          UART_state  <=UART_GS_Trans_Hold;    
          
                    
          elsif GS_Counter ="11001" then    
          r_TX_BYTE<=X"00";
          UART_state  <=UART_GS_Trans_Hold;           
          
            
       elsif GS_Counter ="11010" then
          r_TX_BYTE<=X"36";--ASCII "6"
          UART_state  <=UART_GS_Trans_Hold;         
       elsif GS_Counter ="11011" then    
          r_TX_BYTE<=X"36";--ASCII "6" 
          UART_state  <=UART_end;          
           
        end if;   
                         
         GS_Counter<=GS_Counter +'1'; 
            
            
	when UART_GS_Trans_Hold =>	
		r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
              
              UART_state  <= UART_GS_Trans;
           
          end if;              
when UART_SR_Trans=>       
        r_TX_DV   <= '1';     
       if SR_Counter = 0 then
          r_TX_BYTE<=GC_buf(15 downto 8);
          UART_state  <=UART_SR_Trans_Hold;         
       elsif SR_Counter = 1 then
          r_TX_BYTE<=GC_buf(7 downto 0);  
          UART_state  <=UART_SR_Trans_Hold;            
       elsif SR_Counter = 2 then
          r_TX_BYTE<=Temp_buf(15 downto 8);
          UART_state  <=UART_SR_Trans_Hold;  
       elsif SR_Counter = 3 then
          r_TX_BYTE<=Temp_buf(7 downto 0);
          UART_state  <=UART_SR_Trans_Hold;  
       elsif SR_Counter = 4 then
          r_TX_BYTE<=Cs137_32KeV(15 downto 8);
          UART_state  <=UART_SR_Trans_Hold;  
       elsif SR_Counter = 5 then
          r_TX_BYTE<=Cs137_32KeV(7 downto 0);
          UART_state  <=UART_SR_Trans_Hold;  
       elsif SR_Counter = 6 then
          r_TX_BYTE<=Cs137_662KeV(15 downto 8);
          UART_state  <=UART_SR_Trans_Hold;  
       elsif SR_Counter = 7 then
          r_TX_BYTE<=Cs137_662KeV(7 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 8 then
          r_TX_BYTE<=K40_1460Kev(15 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 9 then
          r_TX_BYTE<=K40_1460Kev(7 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 10 then
          r_TX_BYTE<=det_label(15 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 11 then
          r_TX_BYTE<=det_label(7 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 12 then
          r_TX_BYTE<=HV_DAC(15 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 13 then
          r_TX_BYTE<=HV_DAC(7 downto 0);
		UART_state  <=UART_SR_Trans_Hold; 		  
       elsif SR_Counter = 14 then
          r_TX_BYTE<=Main_threshold(9 downto 2);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 15 then
          r_TX_BYTE<='0'&Main_Signal_Time_1(6 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 16 then
          r_TX_BYTE<=Main_data_subtraction_1(9 downto 2);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 17 then
          r_TX_BYTE<=BNC_Serial_1(7 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 18 then
          r_TX_BYTE<=BNC_Serial_2(7 downto 0); 
		  UART_state  <=UART_SR_Trans_Hold; 
        elsif SR_Counter = 19 then
          r_TX_BYTE<=BNC_Serial_3(7 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 20 then
          r_TX_BYTE<=BNC_Serial_4(7 downto 0);   
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 21 then
          r_TX_BYTE<=BNC_Serial_5(7 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 22 then
          r_TX_BYTE<=BNC_Serial_6(7 downto 0);    
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 23 then
          r_TX_BYTE<=GM_count_threshold(7 downto 0);    
		  UART_state  <=UART_SR_Trans_Hold;   
          
          
                  
       elsif SR_Counter = 26 then
          r_TX_BYTE<=Temp_a(32 -1 downto 24);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 27 then
          r_TX_BYTE<=Temp_a(24 - 1 downto 16);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 28 then
          r_TX_BYTE<=Temp_a(16-1 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 29 then
          r_TX_BYTE<=Temp_a(8-1 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 30 then
          r_TX_BYTE<=Temp_b(32 -1 downto 24);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 31 then
          r_TX_BYTE<=Temp_b(24 - 1 downto 16);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 32 then
          r_TX_BYTE<=Temp_b(16-1 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 33 then
          r_TX_BYTE<=Temp_b(8-1 downto 0);  
		  UART_state  <=UART_SR_Trans_Hold; 		  
       
       elsif SR_Counter = 34 then
          r_TX_BYTE<=gc_a(32 -1 downto 24);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 35 then
          r_TX_BYTE<=gc_a(24 - 1 downto 16);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 36 then
          r_TX_BYTE<=gc_a(16-1 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 37 then
          r_TX_BYTE<=gc_a(8-1 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 
       
       elsif SR_Counter = 38 then
          r_TX_BYTE<=gc_b(32 -1 downto 24);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 39 then
          r_TX_BYTE<=gc_b(24 - 1 downto 16);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 40 then
          r_TX_BYTE<=gc_b(16-1 downto 8);
		  UART_state  <=UART_SR_Trans_Hold; 
       elsif SR_Counter = 41 then
          r_TX_BYTE<=gc_b(8-1 downto 0);
		  UART_state  <=UART_SR_Trans_Hold; 

       
       elsif SR_Counter =55 then    
          r_TX_BYTE<="0000000"&Temp_correction_on;
          UART_state  <=UART_SR_Trans_Hold;
          
       elsif SR_Counter =56 then    
          r_TX_BYTE<=X"36";--ASCII "6" 
          UART_state  <=UART_SR_Trans_Hold;
       elsif SR_Counter =57 then    
          r_TX_BYTE<=X"36";--ASCII "6" 
          UART_state  <=UART_end;          
       else
		  r_TX_BYTE<=X"00";  -- reserve
		  UART_state  <=UART_SR_Trans_Hold;
       end if;   
                         
         SR_Counter<=SR_Counter +1; 
            
            
	when UART_SR_Trans_Hold =>	
		r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
              
              UART_state  <= UART_SR_Trans;
           
          end if;      
                        	 
	 when UART_end =>         
	     		r_TX_DV   <= '0';    
          if  w_TX_DONE = '1' then
              
              UART_state  <= UART_idle;
           
          end if;
          Time_counter <= Time_counter + 1;  
   SC_Time_counter<=SC_Time_counter + '1';         
	  end case;             

	
	
	end if;
	
	
	
	
end process;




process(clk_uart) --UART_RX
begin
    
	if rising_edge(clk_uart) then
	   if(sleep_en = '1') then
            if(led_red = '0')then
                led_blue <= '1';
                led_green_buf <= '0';
            else
                led_blue <= '0';
            end if;    
        else
            
            if(led_red = '0') then
                if( cpu_phold_buf = '0') then
                    led_green_buf <= '0';
                else
                   if((power_check1 ='1')and(power_check2='1')and(power_check3='1')and(power_check4='1'))then
                        if(Temp_correction_on = '1')then
                            led_green_buf <= '1';
                            led_blue <= '0';
                        else
                            led_green_buf <= '1';
                            led_blue <= '1';
                        end if;    
                   else
                        if(led_green_cnt = 5000000)then
                            led_green_cnt <= 0;
                            led_green_buf <= not(led_green_buf);
                        else
                            led_green_cnt <= led_green_cnt +1;
                        end if;
                  end if;

                end if;    
            else
                led_green_buf <= '0';
                led_blue <= '0';
            end if;
        end if;
         if( cpu_detect_pipe = "10" ) then
            power_switching_en <= '1';
            eeprom_test_write_en <= '1';
        elsif( cpu_detect_pipe = "01") then 
            eeprom_test_write_en <= '0';   
        elsif(  cpu_detect_pipe = "00" ) then
            if( power_switching_end = '1') then
                power_switching_en <= '0';
            else
                
                power_switching_en <= '1';
            end if;     
        else
            power_switching_end <= '0';
            power_switching_en <= '0';  
        end if;
    
    
          if(power_switching_en  = '1' ) then   
            if( cpu_phold_buf = '0') then
                if(power_down_cnt = 10000000 - 1)then
                    power_down_cnt <= 0;
                    cpu_phold_buf <= '1';
                    power_switching_end <= '1';
                else
                    power_down_cnt <= power_down_cnt + 1;
                end if;  
            else    
                if(power_down_cnt = 100000000 - 1)then   -- 10 s
                    power_down_cnt <= 0;
                    cpu_phold_buf <= '0';
                    power_switching_end <= '1';
                else
                    power_down_cnt <= power_down_cnt + 1;
                end if;  
            end if;            
           else
             
              power_down_cnt <= 0;
           end if;
	 if(read_end_pipe = "01") then
		 if(HV_DAC_read = X"FFFF" or HV_DAC_read=X"0000")then  
         else HV_DAC <= HV_DAC_read; end if; 
     end if;
     if(su_write_en_pipe = "01") then
		 if( HV_DAC_Write=X"0000")then  
         else HV_DAC <= HV_DAC_Write; end if; 
     end if;      
    case UART_RX_state is
     when UART_RX_idle =>		
            Write_GC_flag_buf <='0';
            su_write_en <= '0';
            Write_HV_flag <='0'; 
            uart_wait_cnt <= 0;  
            Cal_read_done <= '0'; 
            hv_write_en  <= '0';   
   
		if  w_RX_DV = '1' then
		
		  w_RX_BYTE_out(0)<=w_RX_BYTE;
		  UART_RX_state  <= UART_1st_Command_RX;		
        end if;
     when UART_1st_Command_RX =>	  
          if  w_RX_DV = '1' then
              w_RX_BYTE_out(1)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_Command;		
          else
              if uart_wait_cnt = 10000000 then
                 w_RX_BYTE_out(0) <= (others => '0');
                 w_RX_BYTE_out(1) <= (others => '0'); 	
                 UART_RX_state  <= UART_RX_idle;
              else
                 uart_wait_cnt <= uart_wait_cnt + 1;
              end if;     
          end if;
     when  UART_RX_Command=>
           if w_RX_BYTE_out(0) = X"41" and w_RX_BYTE_out(1) = X"32" then -- ASCII "A2"
                acq_start <='1';
                --rst <= '1';
                test1 <= '1';
                sleep_en <= '0';
                HV_Enable <= '1';          
                Adc_sleep <= '0';
                UART_RX_state  <= UART_RX_end;
           elsif    w_RX_BYTE_out(0) = X"41" and w_RX_BYTE_out(1) = X"34" then -- ASCII "A4"   
                 acq_start <='0';
                -- rst <= '1';
                 UART_RX_state  <= UART_RX_end;
           elsif  w_RX_BYTE_out(0) = X"47" and w_RX_BYTE_out(1) = X"43" then -- ASCII "GC" 
                 UART_RX_state  <= UART_RX_1st;
           elsif  w_RX_BYTE_out(0) = X"43" and w_RX_BYTE_out(1) = X"4C" then -- ASCII "CL" 
                 UART_RX_state  <= UART_RX_cl_1st;           
           elsif  w_RX_BYTE_out(0) = X"54" and w_RX_BYTE_out(1) = X"43" then -- ASCII "TC" 
                 UART_RX_state  <=  UART_RX_TC;   
          elsif  w_RX_BYTE_out(0) = X"53" and w_RX_BYTE_out(1) = X"57" then -- ASCII "SW" 
                 UART_RX_state  <=  UART_RX_SW; 
          elsif  w_RX_BYTE_out(0) = X"47" and w_RX_BYTE_out(1) = X"49" then -- ASCII "GI"  
                 UART_RX_state  <=  UART_RX_Init_W;      
                 init_wr_addr   <= X"000001";
          elsif  w_RX_BYTE_out(0) = X"54" and w_RX_BYTE_out(1) = X"49" then -- ASCII "TI"  
                 UART_RX_state  <=  UART_RX_Init_W;
                 init_wr_addr   <= X"000003";          
          elsif  w_RX_BYTE_out(0) = X"53" and w_RX_BYTE_out(1) = X"52" then -- ASCII "SR"
                 UART_RX_state  <=  UART_RX_end;            
                 SR_on <= '1';
           elsif  w_RX_BYTE_out(0) = X"52" and w_RX_BYTE_out(1) = X"52" then -- ASCII "SR"
                 UART_RX_state  <=  UART_RX_end;            
--                 rd_en_start <= '1';      
            elsif  w_RX_BYTE_out(0) = X"53" and w_RX_BYTE_out(1) = X"4C" then -- ASCII "SL"
                 UART_RX_state  <=  UART_RX_end;   
                 sleep_en <= '1';  
                 --rst <= '1';       
                 test1 <= '0';
                 acq_start <='0';     
                   HV_Enable <= '0';          
                   Adc_sleep <= '1';
             elsif  w_RX_BYTE_out(0) = X"41" and w_RX_BYTE_out(1) = X"4B" then -- ASCII "AK" 
                acq_start <='1';
                sleep_en <= '0';
                test1 <= '1';
                 UART_RX_state  <=  UART_RX_end;   
                 HV_Enable <= '1';          
                   Adc_sleep <= '0';      
             elsif  w_RX_BYTE_out(0) = X"47" and w_RX_BYTE_out(1) = X"53" then -- ASCII "GS"
                 UART_RX_state  <=  UART_RX_end;                 
                 GS_on <= '1';     
                                 
           elsif  w_RX_BYTE_out(0) = X"50" and w_RX_BYTE_out(1) = X"44" then -- ASCII "PD" 
             --    w_TX_SERIAL_Bat <= '0'; 
                 cpu_phold_buf  <= '0';    
                 UART_RX_state  <=  UART_RX_end;  
           elsif  w_RX_BYTE_out(0) = X"53" and w_RX_BYTE_out(1) = X"43" then -- ASCII "SC"
                 UART_RX_state  <=  UART_RX_end;     
                  SC_Start<='1';     
           elsif  w_RX_BYTE_out(0) = X"53" and w_RX_BYTE_out(1) = X"50" then -- ASCII "SP"
                 UART_RX_state  <=  UART_RX_end;                 
                   SC_Start<='0';       
           else
             UART_RX_state  <= UART_RX_end;	
           end if;    
            		
     when  UART_RX_1st=>           
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(2)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_2nd;		
            end if;
    when  UART_RX_2nd=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(3)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_3rd;		
            end if;
     when  UART_RX_3rd=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(4)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_4th;		
            end if;   
     when  UART_RX_4th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(5)<=w_RX_BYTE;
              if SW_Write_init = '1' then
                  UART_RX_state  <= UART_RX_5th;
                  
              else
                UART_RX_state  <= UART_RX_end;
             
                if 	w_RX_BYTE = X"01" then
                    GC_sw_Buf(15 downto 8)<=w_RX_BYTE_out(2);
                    GC_sw_Buf(7 downto 0)<=w_RX_BYTE_out(3);
                    Write_GC_flag_buf <='1';
                    
               else
                    hv_write_en  <= '1';
                    HV_DAC(15 downto 8)<=w_RX_BYTE_out(2);
                    HV_DAC(7 downto 0)<=w_RX_BYTE_out(3);
                    Write_HV_flag <='1';                           
                 end if;   
              end if;  		
            end if;   
            
     when  UART_RX_5th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(6)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_6th;		
            end if;                 
      when  UART_RX_6th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(7)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_7th;		
            end if;                
      when  UART_RX_7th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(8)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_8th;		
            end if;                
            
      when  UART_RX_8th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(9)<=w_RX_BYTE;
              UART_RX_state  <=UART_RX_9th;		
            end if;                
        when  UART_RX_9th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(10)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_10th;		
            end if;                
         when  UART_RX_10th=>  
             if  w_RX_DV = '1' then
		
              w_RX_BYTE_out(11)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_end;		
--               Write_GC_flag <='1';
               hv_write_en  <= '1';
               Write_HV_flag <='1';
                if 	w_RX_BYTE = X"36" then
--                    GC(15 downto 8)<=w_RX_BYTE_out(6);
--                    GC(7 downto 0)<=w_RX_BYTE_out(7);
--                    if HV_Fix = '0' then
                        HV_DAC(15 downto 8)<=w_RX_BYTE_out(4);
                        HV_DAC(7 downto 0)<=w_RX_BYTE_out(5);        
--                    elsif HV_Fix = '1' then         
--                        HV_ADC(11 downto 8)<= w_RX_BYTE_out(8)(3 downto 0);             
--                        HV_ADC(7 downto 0)<= w_RX_BYTE_out(9);                     
--                    end if;       
                 end if;    
            end if;                         
      when  UART_RX_cl_1st=>     
             Cal_read_done <= '0';     
             if  w_RX_DV = '1' then
		
              GC_cal_data(15 downto 8)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_2nd;		
            end if;
      when  UART_RX_cl_2nd=>   
       Cal_read_done <= '0';        
             if  w_RX_DV = '1' then
		
              GC_cal_data(7 downto 0)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_3rd;		
            end if;
      when  UART_RX_cl_3rd=>           
       Cal_read_done <= '0';
             if  w_RX_DV = '1' then
		
              temp_cal_data(15 downto 8)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_4th;		
            end if;
      when  UART_RX_cl_4th=>   
       Cal_read_done <= '0';        
             if  w_RX_DV = '1' then
		
              temp_cal_data(7 downto 0)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_5th;		
            end if;  
      when  UART_RX_cl_5th=>    
       Cal_read_done <= '0';       
             if  w_RX_DV = '1' then
		
              peak32_cal_data(15 downto 8)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_6th;		
            end if;
      when  UART_RX_cl_6th=>  
       Cal_read_done <= '0';         
             if  w_RX_DV = '1' then
		
              peak32_cal_data(7 downto 0)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_7th;		
            end if; 
      when  UART_RX_cl_7th=>     
       Cal_read_done <= '0';      
             if  w_RX_DV = '1' then
		
              peak662_cal_data(15 downto 8)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_8th;		
            end if;
      when  UART_RX_cl_8th=> 
       Cal_read_done <= '0';          
             if  w_RX_DV = '1' then
		
              peak662_cal_data(7 downto 0)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_9th;		
            end if; 
      when  UART_RX_cl_9th=>  
       Cal_read_done <= '0';         
             if  w_RX_DV = '1' then
		
              peak1460_cal_data(15 downto 8)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_10th;		
            end if;
      when  UART_RX_cl_10th=>     
       Cal_read_done <= '0';      
             if  w_RX_DV = '1' then
		
              peak1460_cal_data(7 downto 0)<=w_RX_BYTE;
              UART_RX_state  <= UART_RX_cl_11th;		
              
            end if;
      when  UART_RX_cl_11th=>  
              Cal_read_done <= '1';         
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_12th;    --reserve
             end if; 
      when  UART_RX_cl_12th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_13th;    --reserve
             end if;
      when  UART_RX_cl_13th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_14th;    --reserve
             end if;
      when  UART_RX_cl_14th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_15th;    --reserve
             end if;
      when  UART_RX_cl_15th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_16th;    --reserve
             end if;
      when  UART_RX_cl_16th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_17th;    --reserve
             end if;
      when  UART_RX_cl_17th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_18th;    --reserve
             end if;
      when  UART_RX_cl_18th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_19th;    --reserve
             end if;
      when  UART_RX_cl_19th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_20th;    --reserve
             end if;
      when  UART_RX_cl_20th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_21th;    --reserve
             end if;
      when  UART_RX_cl_21th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_22th;    --reserve
             end if;
      when  UART_RX_cl_22th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_23th;    --reserve
             end if;
      when  UART_RX_cl_23th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_24th;    --reserve
             end if;
      when  UART_RX_cl_24th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_25th;    --reserve
             end if;
      when  UART_RX_cl_25th=>           
             if  w_RX_DV = '1' then
              UART_RX_state  <= UART_RX_cl_26th;    --reserve
             end if;
      when  UART_RX_cl_26th=>       
                 
             if  w_RX_DV = '1' then
               Cal_read_done <= '1';
              UART_RX_state  <= UART_RX_end;    --reserve
             end if;
--      when UART_RX_su =>   
--            if(uart_rx_su_cnt = 0)then  if  w_RX_DV = '1'    then Gc_write(16-1 downto 8)<=w_RX_BYTE;   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 1)then  if  w_RX_DV = '1' then Gc_write(8-1 downto 0)<=w_RX_BYTE;    uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 2)then  if  w_RX_DV = '1' then temp_write(16-1 downto 8)<=w_RX_BYTE; uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 3)then  if  w_RX_DV = '1' then temp_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 4)then  if  w_RX_DV = '1' then Ch_32Kev_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 5)then  if  w_RX_DV = '1' then Ch_32Kev_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 6)then  if  w_RX_DV = '1' then Ch_662Kev_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 7)then  if  w_RX_DV = '1' then Ch_662Kev_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 8)then  if  w_RX_DV = '1' then Ch_1460Kev_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 9)then  if  w_RX_DV = '1' then Ch_1460Kev_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 10)then  if  w_RX_DV = '1' then d_lab_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 11)then  if  w_RX_DV = '1' then d_lab_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 12)then  if  w_RX_DV = '1' then hv_dac_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 13)then  if  w_RX_DV = '1' then hv_dac_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 14)then  if  w_RX_DV = '1' then threshold_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 15)then  if  w_RX_DV = '1' then signaltime_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 16)then  if  w_RX_DV = '1' then data_subtraction_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 17)then  if  w_RX_DV = '1' then Serial_1_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 18)then  if  w_RX_DV = '1' then Serial_2_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 19)then  if  w_RX_DV = '1' then Serial_3_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 20)then  if  w_RX_DV = '1' then Serial_4_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 21)then  if  w_RX_DV = '1' then Serial_5_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 22)then  if  w_RX_DV = '1' then Serial_6_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 23)then  if  w_RX_DV = '1' then GM_count_threshold_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 24)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 25)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 26)then  if  w_RX_DV = '1' then temp_a_write(32-1 downto 24)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 27)then  if  w_RX_DV = '1' then temp_a_write(24-1 downto 16)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 28)then  if  w_RX_DV = '1' then temp_a_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 29)then  if  w_RX_DV = '1' then temp_a_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 30)then  if  w_RX_DV = '1' then temp_b_write(32-1 downto 24)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 31)then  if  w_RX_DV = '1' then temp_b_write(24-1 downto 16)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 32)then  if  w_RX_DV = '1' then temp_b_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 33)then  if  w_RX_DV = '1' then temp_b_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 34)then  if  w_RX_DV = '1' then gc_a_write(32-1 downto 24)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 35)then  if  w_RX_DV = '1' then gc_a_write(24-1 downto 16)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 36)then  if  w_RX_DV = '1' then gc_a_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 37)then  if  w_RX_DV = '1' then gc_a_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 38)then  if  w_RX_DV = '1' then gc_b_write(32-1 downto 24)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 39)then  if  w_RX_DV = '1' then gc_b_write(24-1 downto 16)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 40)then  if  w_RX_DV = '1' then gc_b_write(16-1 downto 8)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 41)then  if  w_RX_DV = '1' then gc_b_write(8-1 downto 0)<=w_RX_BYTE;  uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;
--            elsif(uart_rx_su_cnt = 42)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 43)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 44)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 45)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 46)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 47)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 48)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 49)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 50)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 51)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 52)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 53)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 54)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 55)then  if  w_RX_DV = '1' then   uart_rx_su_cnt <= uart_rx_su_cnt + 1;  end if;--reserve
--            elsif(uart_rx_su_cnt = 56)then  if  w_RX_DV = '1' then if(w_RX_BYTE =X"36")then  su_write_en <= '1'; uart_rx_su_cnt <= uart_rx_su_cnt + 1; end if; end if;--6
--            elsif(uart_rx_su_cnt = 57)then  if  w_RX_DV = '1' then if(w_RX_BYTE =X"36")then  uart_rx_su_cnt <= 0; UART_RX_state  <= UART_RX_end; end if;  end if;--6
            
              
            
            
            
            
            
--            end if;   
        when UART_RX_SW =>   
            if(SW_cnt = 0)then     if  w_RX_DV = '1'  then Serial_1_write(8-1 downto 0)<=w_RX_BYTE;   SW_cnt <= SW_cnt + 1;  end if;
            elsif(SW_cnt = 1)then  if  w_RX_DV = '1'  then Serial_2_write(8-1 downto 0)<=w_RX_BYTE;    SW_cnt <= SW_cnt + 1;  end if;
            elsif(SW_cnt = 2)then  if  w_RX_DV = '1'  then Serial_3_write(8-1 downto 0)<=w_RX_BYTE; SW_cnt <= SW_cnt + 1;  end if;
            elsif(SW_cnt = 3)then  if  w_RX_DV = '1'  then Serial_4_write(8-1 downto 0)<=w_RX_BYTE;  SW_cnt <= SW_cnt + 1;  end if;
            elsif(SW_cnt = 4)then  if  w_RX_DV = '1'  then Serial_5_write(8-1 downto 0)<=w_RX_BYTE;  SW_cnt <= SW_cnt + 1;  end if;
            elsif(SW_cnt = 5)then  if  w_RX_DV = '1'  then Serial_6_write(8-1 downto 0)<=w_RX_BYTE;  SW_cnt <= SW_cnt + 1;  end if;
            elsif(SW_cnt = 6)then  if  w_RX_DV = '1'  then if(w_RX_BYTE =X"36")then  Serial_write_en <= '1'; SW_cnt <= SW_cnt + 1; end if; end if;--6
            elsif(SW_cnt = 7)then  if  w_RX_DV = '1'  then if(w_RX_BYTE =X"36")then  SW_cnt <= 0; UART_RX_state  <= UART_RX_end; end if;  end if;--6      
            end if;     
       when UART_RX_TC =>   
            if(TC_cnt = 0)then     
                if  w_RX_DV = '1'  then 
                    if(w_RX_BYTE = X"30")then
                        Temp_correction_on<='0';   
                    elsif(w_RX_BYTE = X"31")then
                        Temp_correction_on<='1'; 
                    end if;
                    TC_cnt <= TC_cnt + 1;  
                end if;
            elsif(TC_cnt = 1)then  if  w_RX_DV = '1'  then if(w_RX_BYTE =X"36")then  TC_cnt <= TC_cnt + 1; end if; end if;--6
            elsif(TC_cnt = 2)then  if  w_RX_DV = '1'  then if(w_RX_BYTE =X"36")then  TC_cnt <= 0; UART_RX_state  <= UART_RX_end; end if;  end if;--6      
            end if;    
      when UART_RX_Init_W =>
                if(init_cnt = 0)then     if  w_RX_DV = '1'  then init_wr_data(16-1 downto 8)<=w_RX_BYTE;   init_cnt <= init_cnt + 1;  end if;
            elsif(init_cnt = 1)then  if  w_RX_DV = '1'  then init_wr_data(8-1 downto 0)<=w_RX_BYTE;    init_cnt <= init_cnt + 1;  end if;
       
            elsif(init_cnt = 2)then  if  w_RX_DV = '1'  then if(w_RX_BYTE =X"36")then   init_cnt <= init_cnt + 1; 
                                                                if(init_wr_addr = X"000001")then 
                                                                    Gc_write <= init_wr_data(16 - 1 downto 0);
                                                                elsif(init_wr_addr = X"000003")then
                                                                    temp_write <= init_wr_data(16 - 1 downto 0);
                                                                end if; end if; end if;--
            elsif(init_cnt = 3)then  if  w_RX_DV = '1'  then if(w_RX_BYTE =X"36")then  init_wr_en <= '1'; init_cnt <= 0; UART_RX_state  <= UART_RX_end; end if;  end if;--6      
            end if;                      
      
      
                                                                                                                                                    
      when   UART_RX_end=>
            su_write_en <= '0';
            Serial_write_en <= '0';
            SW_Write_init <='0'; 
             SR_on <= '0';
             init_wr_en <= '0';
            GS_on <= '0';
--            rd_en_start <= '0';
            UART_RX_state  <= UART_RX_idle;                             
	when others => UART_RX_state  <= UART_RX_idle;
	end case;

   
     
	
	
end if;
end process;	
		




process(clk_uart) --SPI - GC
begin
    
	if rising_edge(clk_uart) then
		
    GC_flag_buf(0)<=Write_GC_flag ;
    GC_flag_buf(1)<=GC_flag_buf(0);                 
                          
    if GC_flag_buf(0) > GC_flag_buf(1) then
       GC_en <= '1';
    end if;           		
		
		



		
	case SPI_GC_state is
     when SPI_GC_idle =>		
         m_din <= X"00";
         m_din_vld<='0';	
		m_addr<="0";
		 m_din_last<='0';
		         
		
		if cnt_DV_GC_T_1 = 1000 then
                SPI_GC_state  <= SPI_GC_1st_Trans;
         else
            cnt_DV_GC_T_1 <= cnt_DV_GC_T_1  + 1;
         end if;
		
	 when SPI_GC_1st_Trans =>		
		 -- m_din <= X"A0";
		  m_din <= GC(15 downto 8);
          m_din_vld<='1';
 		             
          SPI_GC_state  <=SPI_GC_1st_Trans_Hold;
         
    when SPI_GC_1st_Trans_Hold =>	  
                         
          if  m_ready = '1' then
             m_din_vld<='0';  
            
             SPI_GC_state  <= SPI_GC_2nd_Trans;
          end if;
          
     when SPI_GC_2nd_Trans =>       
         --   m_din <= X"00";
             m_din <= GC(7 downto 0);
             m_din_vld<='1';
             m_din_last<='1';    
        
		 SPI_GC_state  <= SPI_GC_end;
	    		 GC_en<= '0';	  
	 when SPI_GC_end =>  	 
	         if  m_ready = '1' then
	             m_din_vld<='0';
	               m_din_last<='0';
	        
	           if GC_en = '1' then
	               SPI_GC_state  <= SPI_GC_1st_Trans;
	           end if;    
	               
	            
	          end if;
	  when others =>        
	  end case;             


	end if;
end process;	
process(clk_uart)
begin
    if (rising_edge(clk_uart)) then
        if(read_end_pipe = "01") then 
           eeprom_read_end <= '1';    
        end if;
    end if;
end process;   	
process(clk_uart) --SPI - hv
begin
    
	if rising_edge(clk_uart) then    
    
 HV_flag_buf(0)<=Write_HV_flag ;
    HV_flag_buf(1)<=HV_flag_buf(0);                 
  
  HV_Contr_Write_HV_flag_buf(0)<=HV_Contr_Write_HV_flag ;
    HV_Contr_Write_HV_flag_buf(1)<=HV_Contr_Write_HV_flag_buf(0);   
               
   
                          
    if HV_flag_buf(0) > HV_flag_buf(1) then
       HV_en <= '1';
    end if;   

    if HV_Contr_Write_HV_flag_buf(0) > HV_Contr_Write_HV_flag_buf(1) then
       HV_en <= '1';
    end if; 


	case SPI_HV_state is
     when SPI_HV_idle =>		
		
                m_din_2 <= X"00";
                 m_din_vld_2<='0';    
                m_addr_2<="0";
                 m_din_last_2<='0';		
		
		if eeprom_read_end = '1' then
                SPI_HV_state  <= SPI_HV_1st_Trans;
  
         end if;
		
	 when SPI_HV_1st_Trans =>		

 		  m_din_2 <=  HV_DAC(15 downto 8);-- Write to and Update DAC Register
          m_din_vld_2<='1';         
          
          SPI_HV_state  <=SPI_HV_1st_Trans_Hold;
         
    when SPI_HV_1st_Trans_Hold =>	  
                         
          if  m_ready_2 = '1' then
             
             m_din_vld_2<='0';
             SPI_HV_state  <= SPI_HV_2nd_Trans;
          end if;
          
     when SPI_HV_2nd_Trans =>       
 
             
             m_din_2 <=  HV_DAC(7 downto 0);
              m_din_vld_2<='1';
              m_din_last_2<='1';
    		 SPI_HV_state  <= SPI_HV_end;    
    		 HV_en<= '0';  
    		   
	 when SPI_HV_end =>  	 
	         if  m_ready_2 = '1' then
	        	    HV_Contr_Rdy<='1';              
	               	 m_din_vld_2<='0';
                     m_din_last_2<='0';
                  if HV_en = '1' then
	               SPI_HV_state  <= SPI_HV_1st_Trans;   
                   end if;  
	          end if;
	   when others =>       
	  end case;             
	end if;
end process;	

Ch_temp_t1 <= X"00" & Temp_Buf;
Ch_temp_t2 <= X"000"&ADC_temp_data(15 downto 4);
inst_floating_point_top :floating_point_top 
  Port map( 
        clk => clk_uart,    
        acq_start => temp_correction_on,
        cl_wr_en_pipe => cl_wr_en_pipe,
        Ch_temp_t1 => Ch_temp_t1,
        Ch_662Kev_read => Ch_662Kev_read,
        Ch_temp_t2  => Ch_temp_t2,
        GC_Cal_out => GC_Cal_out,
        K40_Pre_GC => GC_Buf,
--        temp_a => temp_a, 
--        temp_b => temp_b,
        gc_a => gc_a,
        gc_b => gc_b,
        Compare_rdy => '1');

process(clk_uart)
begin
    if(rising_edge(clk_uart)) then
       if(rd_en_cnt = 10000000) then  -- 1s
           rd_en_start <= '1';
       else
           rd_en_start <= '0';
           rd_en_cnt  <= rd_en_cnt+1;
       end if;
    end if;   
end process;
inst_eeprom_top : eeprom_top 
  Port map(
        clk                =>   clk_uart,
        hv_wr_en           =>   hv_write_en,
        cl_wr_en           =>   Cal_read_done,
        su_wr_en           =>   Serial_write_en,
        rd_en              =>   rd_en_start, 
        
        init_wr_en   => init_wr_en,
        init_wr_addr => init_wr_addr,
        init_wr_data => init_wr_data,
        
        GC_write                 =>   GC_Buf, 
        Temp_write               =>   Temp_buf, 
        Ch_32Kev_write           =>   Cs137_32KeV, 
        Ch_662Kev_write          =>   Cs137_662KeV, 
        Ch_1460Kev_write         =>   K40_1460KeV, 
        D_lab_write              =>   Det_label, 
        HV_DAC_write             =>   HV_DAC, 
        Threshold_write          =>   Main_threshold(9 downto 2), 
        SignalTime_write         =>   Main_Signal_TIME_1_buf, 
        Data_subtraction_write   =>   Main_Data_subtraction_1(9 downto 2), 
        Serial_1_write           =>   BNC_Serial_1, 
        Serial_2_write           =>   BNC_Serial_2,    
        Serial_3_write           =>   BNC_Serial_3, 
        Serial_4_write           =>   BNC_Serial_4, 
        Serial_5_write           =>   BNC_Serial_5, 
        Serial_6_write           =>   BNC_Serial_6, 
        GM_count_threshold_write => GM_count_threshold,
        temp_a_write             => temp_a_write_check,
        temp_b_write             => temp_b_write_check,
        gc_a_write               => gc_a_write_check,
        gc_b_write               => gc_b_write_check,
        
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
         GM_count_threshold_read => GM_count_threshold_read,
        temp_a_read            => temp_a_read,
        temp_b_read            => temp_b_read,
        gc_a_read              => gc_a_read,
        gc_b_read              => gc_b_read,
        read_end               => read_end,
        
        cs_n               =>   eeprom_cs_n,
        sclk               =>   eeprom_sclk,
        miso               =>   eeprom_miso,
        mosi               =>   eeprom_mosi

         );         
process(clk_uart)  
begin
    if(rising_edge(clk_uart)) then
    
       
        if((Temp_data > 1365))then
            Main_Threshold <= Main_Threshold_buf + 36; 
        elsif (( 1365 >= Temp_data )and(Temp_data > 1220)) then
            Main_Threshold <= Main_Threshold_buf + 20;  
        elsif(1220 >= Temp_data)then
            Main_Threshold <= Main_Threshold_buf;     
        end if;     
        cl_wr_en_pipe <= cl_wr_en_pipe(0) & cal_read_done;
        su_write_en_pipe <= su_write_en_pipe(0) & Serial_write_en;
        read_end_pipe <= read_end_pipe(0) & read_end;
        
        init_wr_en_pipe<= init_wr_en_pipe(0) & init_wr_en;
        
        su_write_en_pipe_1d <= su_write_en_pipe;
        read_end_pipe_1d <=read_end_pipe;
        if(read_end_pipe = "01")then  -- eeprom read
            GC_Buf <= gc_read;
            if(Ch_32Kev_read /= X"FFFF")        then  Temp_Buf <= Temp_read;   end if; 
            if(Ch_32Kev_read /= X"FFFF")        then  Cs137_32Kev <= Ch_32Kev_read; end if;
            if(Ch_662Kev_read /= X"FFFF")       then  Cs137_662Kev <= Ch_662Kev_read; end if;
            if(Ch_1460Kev_read /= X"FFFF")      then  K40_1460Kev <= Ch_1460Kev_read; end if;
--            if(d_lab_read /= X"FFFF")           then  det_label     <= d_lab_read; end if;
--            if(Threshold_read /= X"FF")         then  Main_threshold <= "000"&Threshold_read&"00"; Main_threshold_buf <= "000"&Threshold_read&"00"; end if;  
--            if(SignalTime_read /= X"FF")        then  Main_Signal_TIME_1 <= SignalTime_read(6 downto 0); end if;
--            if(Data_subtraction_read /= X"FF")  then  Main_data_subtraction_1 <= "000"&Data_subtraction_read&"00"; end if;
            if(Serial_1_read /= X"FF")          then  BNC_Serial_1 <= Serial_1_read; end if;
            if(Serial_2_read /= X"FF")          then  BNC_Serial_2 <= Serial_2_read; end if;
            if(Serial_3_read /= X"FF")          then  BNC_Serial_3 <= Serial_3_read; end if;
            if(Serial_4_read /= X"FF")          then  BNC_Serial_4 <= Serial_4_read; end if;
            if(Serial_5_read /= X"FF")          then  BNC_Serial_5 <= Serial_5_read; end if;
            if(Serial_6_read /= X"FF")          then  BNC_Serial_6 <= Serial_6_read; end if;
--            if(GM_count_threshold_read /= X"FF")          then  GM_count_threshold <= GM_count_threshold_read; end if;
--            if(temp_a_read /= X"FFFFFFFF")            then  temp_a <= temp_a_read; end if;
--            if(temp_b_read /= X"FFFFFFFF")            then  temp_b <= temp_b_read; end if;
--            if(gc_a_read /= X"FFFFFFFF")              then  gc_a <= gc_a_read; end if;
--            if(gc_b_read /= X"FFFFFFFF")              then  gc_b <= gc_b_read; end if;
            
        end if;   
        if(read_end_pipe_1d = "01")then
            Main_Threshold_buf <= Main_Threshold;    
        end if; 
        
        if(su_write_en_pipe = "01") then -- eeprom write
           
            if(Serial_1_write /= X"00")          then  BNC_Serial_1 <= Serial_1_write; end if;
            if(Serial_2_write /= X"00")          then  BNC_Serial_2 <= Serial_2_write; end if;
            if(Serial_3_write /= X"00")          then  BNC_Serial_3 <= Serial_3_write; end if;
            if(Serial_4_write /= X"00")          then  BNC_Serial_4 <= Serial_4_write; end if;
            if(Serial_5_write /= X"00")          then  BNC_Serial_5 <= Serial_5_write; end if;
            if(Serial_6_write /= X"00")          then  BNC_Serial_6 <= Serial_6_write; end if;
           
        end if;
        if(init_wr_en_pipe = "01") then
            Gc_buf   <= Gc_write;
            temp_buf <= temp_write;     
        end if;   
--        if(su_write_en_pipe_1d = "01") then
--             if(temp_a_write_check  /= X"FFFFFFFF")     then  temp_a <= temp_a_write_check; end if;
--            if(temp_b_write_check   /= X"FFFFFFFF")     then  temp_b <= temp_b_write_check;  end if;
--            if(gc_a_write_check     /= X"FFFFFFFF")       then  gc_a <= gc_a_write_check;  end if;
--            if(gc_b_write_check     /= X"FFFFFFFF")       then  gc_b <= gc_b_write_check;   end if;
--        end if;
        if (cl_wr_en_pipe = "01") then
            if(GC_cal_data /= X"0000")        then  GC_Buf <= GC_cal_data; end if;
            if(Temp_cal_data /= X"0000")            then  Temp_Buf <= Temp_cal_data; end if;
            if(peak32_cal_data /= X"0000")        then  Cs137_32Kev <= peak32_cal_data; end if;
            if(peak662_cal_data /= X"0000")       then  Cs137_662Kev <= peak662_cal_data; end if;
            if(peak1460_cal_data /= X"0000")      then  K40_1460Kev <= peak1460_cal_data; end if;
        end if;
    end if;
end process;           



process(clk_uart)
begin
    if (rising_edge(clk_uart)) then
        if(acq_start = '1')then
            if(temp_correction_on = '0')then
                GC <= GC_sw_Buf;
                Write_GC_flag <= Write_GC_flag_Buf;
            else

                if(GC_Change_cnt = 5000000) then
                    GC_Change_cnt <= 0;
                    GC <= GC_Cal_out;
                    Write_GC_flag <= '1';
                else
                    GC_Change_cnt <= GC_Change_cnt + 1;
                    Write_GC_flag <= '0';
                end if;
            end if;    
        end if;
    end if;

end process;

         
rst_n <= not(sleep_en);
inst_adc_protocol_top : adc_protocol_top
Port map(
      rst_n => rst_n,
      clk => clk_Main,
      sda => adc_sda,
      scl => adc_scl,
      adc_temp_out =>  Adc_temp_data_buf,
      adc_3p3_out  =>  Adc_3p3_data_buf,
      adc_2p8_out  =>  Adc_2p8_data_buf,
      adc_1p8_out  =>  Adc_1p8_data_buf,
      adc_1p0_out  =>  Adc_1p0_data_buf
          );
          
process(clk_uart)
begin
    if (rising_edge(clk_uart)) then
        if(adc_read_cnt = 10000000) then
            adc_read_cnt <=0;
            Adc_temp_data <= Adc_temp_data_buf;
            Adc_3p3_data <= Adc_3p3_data_buf;
            Adc_2p8_data  <= Adc_2p8_data_buf;
            Adc_1p8_data  <= Adc_1p8_data_buf;
            Adc_1p0_data  <= Adc_1p0_data_buf; 
        else
            adc_read_cnt <= adc_read_cnt + 1;
        
        end if;
    
    
    end if;
end process;          
process(clk_uart)
begin
    if (rising_edge(clk_uart)) then
       if(Adc_3p3_data(15 downto 4) > 3685) then
            power_check1 <= '1';
       else
            power_check1 <= '0'; 
       end if;  
       if((3823 > Adc_2p8_data(15 downto 4))and(Adc_2p8_data(15 downto 4) > 3128)) then
            power_check2 <= '1';
       else
            power_check2 <= '0'; 
       end if;
       if((2457 > Adc_1p8_data(15 downto 4))and(Adc_1p8_data(15 downto 4) > 2011)) then
            power_check3 <= '1';
       else
            power_check3 <= '0'; 
       end if;
       if((1365 > Adc_1p0_data(15 downto 4))and(Adc_1p0_data(15 downto 4) > 1117)) then
            power_check4 <= '1';
       else
            power_check4 <= '0'; 
       end if;   
    end if;
end process;    
    
led_green <= led_green_buf;
  
clk_ADC_p<=clk_ADC;


process(clk_main)
begin
    if(rising_edge(clk_main))then
        i_GM_count <= i_GM_count(0)&pin_trig_signal;
    end if;
end process;

process(clk_main)
begin
    if(rising_edge(clk_main))then
        if(sleep_en = '1') then
        --------------------time-----------
            if(gm_time_count = 50000000) then  --1s
                Gm_count_read <= '1';
                gm_time_count <= 0;
            elsif(gm_time_count = 5) then
                Gm_count_out <= (others => '0');
                gm_time_count <= gm_time_count + 1;
            else
                Gm_count_read <= '0';
                gm_time_count <= gm_time_count + 1;
                if(i_GM_count = "01" and GM_count_wait_on = '0') then
                    Gm_count_out <= Gm_count_out + 1;
                    GM_count_wait_on <= '1';
                end if;
            end if;        
        if(GM_count_wait_on = '1')then
		  if(GM_count_wait_cnt = 20000)   then    --- 400 us     1clk : 20ns
		      GM_count_wait_cnt <= 0;
		      GM_count_wait_on <= '0';
		  else
		      GM_count_wait_cnt <= GM_count_wait_cnt + 1;
		  end if;
		else
		  GM_count_wait_cnt <= 0;
		end if;
        
        
           
        else --------------------sleep_en = '0'--------------------
            GM_count_wait_cnt <= 0;
            GM_count_wait_on <= '0';
            Gm_count_read <= '0';
            gm_time_count <= 0;
            Gm_count_out <= (others => '0');
        end if;    
    end if;
end process;

process(clk_main)
begin
    if(rising_edge(clk_main))then

            if(Gm_count_out =0)then
                Gm_count <= "0000000";
            elsif(Gm_count_out = 1) then
                 Gm_count <= "0000001";
			elsif(Gm_count_out = 2) then
				Gm_count <= "0000010";
            else
                Gm_count <= "0000011";
                
            end if;    
    end if;
end process;		
process(clk_main)
begin
    if(rising_edge(clk_main))then
        Gm_count_read_pipe <= Gm_count_read_pipe(0) & Gm_count_read;
    end if;
end process;

process(clk_main)
begin
    if(rising_edge(clk_main))then
        if(sleep_en = '1') then
            if(Gm_count_read_pipe = "01")then
                Gm_count_pre_1s <= Gm_count;
                Gm_count_pre_2s <= Gm_count_pre_1s;
                Gm_count_pre_3s <= Gm_count_pre_2s;
                Gm_count_pre_4s <= Gm_count_pre_3s;
                Gm_count_pre_5s <= Gm_count_pre_4s;
                Gm_count_pre_6s <= Gm_count_pre_5s;
                Gm_count_pre_7s <= Gm_count_pre_6s;
                Gm_count_pre_8s <= Gm_count_pre_7s;
                Gm_count_pre_9s <= Gm_count_pre_8s;
                Gm_count_pre_10s <= Gm_count_pre_9s;
                Gm_count_pre_11s <= Gm_count_pre_10s;
                Gm_count_pre_12s <= Gm_count_pre_11s;
                Gm_count_pre_13s <= Gm_count_pre_12s;
                Gm_count_pre_14s <= Gm_count_pre_13s;
                Gm_count_pre_15s <= Gm_count_pre_14s;
                Gm_count_pre_16s <= Gm_count_pre_15s;
                Gm_count_pre_17s <= Gm_count_pre_16s;
                Gm_count_pre_18s <= Gm_count_pre_17s;
                Gm_count_pre_19s <= Gm_count_pre_18s;
                Gm_count_pre_20s <= Gm_count_pre_19s;
                Gm_count_pre_21s <= Gm_count_pre_20s;
                Gm_count_pre_22s <= Gm_count_pre_21s;
                Gm_count_pre_23s <= Gm_count_pre_22s;
                Gm_count_pre_24s <= Gm_count_pre_23s;
                Gm_count_pre_25s <= Gm_count_pre_24s;
                Gm_count_pre_26s <= Gm_count_pre_25s;
                Gm_count_pre_27s <= Gm_count_pre_26s;
                Gm_count_pre_28s <= Gm_count_pre_27s;
                Gm_count_pre_29s <= Gm_count_pre_28s;
                Gm_count_pre_30s <= Gm_count_pre_29s;
                Gm_count_pre_31s <= Gm_count_pre_30s;
                Gm_count_pre_32s <= Gm_count_pre_31s;
                Gm_count_pre_33s <= Gm_count_pre_32s;
                Gm_count_pre_34s <= Gm_count_pre_33s;
                Gm_count_pre_35s <= Gm_count_pre_34s;
                Gm_count_pre_36s <= Gm_count_pre_35s;
                Gm_count_pre_37s <= Gm_count_pre_36s;
                Gm_count_pre_38s <= Gm_count_pre_37s;
                Gm_count_pre_39s <= Gm_count_pre_38s;
                Gm_count_pre_40s <= Gm_count_pre_39s;
                Gm_count_pre_41s <= Gm_count_pre_40s;
                Gm_count_pre_42s <= Gm_count_pre_41s;
                Gm_count_pre_43s <= Gm_count_pre_42s;
                Gm_count_pre_44s <= Gm_count_pre_43s;
                Gm_count_pre_45s <= Gm_count_pre_44s;
                Gm_count_pre_46s <= Gm_count_pre_45s;
                Gm_count_pre_47s <= Gm_count_pre_46s;
                Gm_count_pre_48s <= Gm_count_pre_47s;
                Gm_count_pre_49s <= Gm_count_pre_48s;
                Gm_count_pre_50s <= Gm_count_pre_49s;
                Gm_count_pre_51s <= Gm_count_pre_50s;
                Gm_count_pre_52s <= Gm_count_pre_51s;
                Gm_count_pre_53s <= Gm_count_pre_52s;
                Gm_count_pre_54s <= Gm_count_pre_53s;
                Gm_count_pre_55s <= Gm_count_pre_54s;
                Gm_count_pre_56s <= Gm_count_pre_55s;
                Gm_count_pre_57s <= Gm_count_pre_56s;
                Gm_count_pre_58s <= Gm_count_pre_57s;
                Gm_count_pre_59s <= Gm_count_pre_58s;
--                Gm_count_pre_30s <= Gm_count_pre_29s;
          
            end if;   
        else
             Gm_count_pre_1s <= (others =>'0');
             Gm_count_pre_2s <= (others =>'0');
             Gm_count_pre_3s <= (others =>'0');
             Gm_count_pre_4s <= (others =>'0');
             Gm_count_pre_5s <= (others =>'0');
             Gm_count_pre_6s <= (others =>'0');
             Gm_count_pre_7s <= (others =>'0');
             Gm_count_pre_8s <= (others =>'0');
             Gm_count_pre_9s <= (others =>'0');
             Gm_count_pre_10s <= (others =>'0');
             Gm_count_pre_11s <= (others =>'0');
             Gm_count_pre_12s <= (others =>'0');
             Gm_count_pre_13s <= (others =>'0');
             Gm_count_pre_14s <= (others =>'0');
             Gm_count_pre_15s <= (others =>'0');
             Gm_count_pre_16s <= (others =>'0');
             Gm_count_pre_17s <= (others =>'0');
             Gm_count_pre_18s <= (others =>'0');
             Gm_count_pre_19s <= (others =>'0');
             Gm_count_pre_20s <= (others =>'0');
             Gm_count_pre_21s <= (others =>'0');
             Gm_count_pre_22s <= (others =>'0');
             Gm_count_pre_23s <= (others =>'0');
             Gm_count_pre_24s <= (others =>'0');
             Gm_count_pre_25s <= (others =>'0');
             Gm_count_pre_26s <= (others =>'0');
             Gm_count_pre_27s <= (others =>'0');
             Gm_count_pre_28s <= (others =>'0');
             Gm_count_pre_29s <= (others =>'0');
             Gm_count_pre_30s <= (others =>'0');
             Gm_count_pre_31s <= (others =>'0');
             Gm_count_pre_32s <= (others =>'0');
             Gm_count_pre_33s <= (others =>'0');
             Gm_count_pre_34s <= (others =>'0');
             Gm_count_pre_35s <= (others =>'0');
             Gm_count_pre_36s <= (others =>'0');
             Gm_count_pre_37s <= (others =>'0');
             Gm_count_pre_38s <= (others =>'0');
             Gm_count_pre_39s <= (others =>'0');
             Gm_count_pre_40s <= (others =>'0');
             Gm_count_pre_41s <= (others =>'0');
             Gm_count_pre_42s <= (others =>'0');
             Gm_count_pre_43s <= (others =>'0');
             Gm_count_pre_44s <= (others =>'0');
             Gm_count_pre_45s <= (others =>'0');
             Gm_count_pre_46s <= (others =>'0');
             Gm_count_pre_47s <= (others =>'0');
             Gm_count_pre_48s <= (others =>'0');
             Gm_count_pre_49s <= (others =>'0');
             Gm_count_pre_50s <= (others =>'0');
             Gm_count_pre_51s <= (others =>'0');
             Gm_count_pre_52s <= (others =>'0');
             Gm_count_pre_53s <= (others =>'0');
             Gm_count_pre_54s <= (others =>'0');
             Gm_count_pre_55s <= (others =>'0');
             Gm_count_pre_56s <= (others =>'0');
             Gm_count_pre_57s <= (others =>'0');
             Gm_count_pre_58s <= (others =>'0');
             Gm_count_pre_59s <= (others =>'0');
        
             
        end if;     
    end if;
end process;

process(clk_main)
begin
    if(rising_edge(clk_main))then
        Gm_count_pre_sum <=    Gm_count_pre_1s + Gm_count_pre_2s + Gm_count_pre_3s + Gm_count_pre_4s + Gm_count_pre_5s 
                              +Gm_count_pre_6s + Gm_count_pre_7s + Gm_count_pre_8s + Gm_count_pre_9s + Gm_count_pre_10s
                              +Gm_count_pre_11s+Gm_count_pre_12s+Gm_count_pre_13s+Gm_count_pre_14s+Gm_count_pre_15s
                              +Gm_count_pre_16s+Gm_count_pre_17s+Gm_count_pre_18s+Gm_count_pre_19s+Gm_count_pre_20s
                              +Gm_count_pre_21s+Gm_count_pre_22s+Gm_count_pre_23s+Gm_count_pre_24s+Gm_count_pre_25s
                              +Gm_count_pre_26s+Gm_count_pre_27s+Gm_count_pre_28s+Gm_count_pre_29s+Gm_count;--Gm_count_pre_30s 
--                              +Gm_count_pre_31s+ Gm_count_pre_32s + Gm_count_pre_33s + Gm_count_pre_34s + Gm_count_pre_35s 
--                              +Gm_count_pre_36s + Gm_count_pre_37s + Gm_count_pre_38s + Gm_count_pre_39s + Gm_count_pre_40s
--                              +Gm_count_pre_41s+Gm_count_pre_42s+Gm_count_pre_43s+Gm_count_pre_44s+Gm_count_pre_45s
--                              +Gm_count_pre_46s+Gm_count_pre_47s+Gm_count_pre_48s+Gm_count_pre_49s+Gm_count_pre_50s
--                              +Gm_count_pre_51s+Gm_count_pre_52s+Gm_count_pre_53s+Gm_count_pre_54s+Gm_count_pre_55s
--                              +Gm_count_pre_56s+Gm_count_pre_57s+Gm_count_pre_58s+Gm_count_pre_59s+Gm_count;
    end if;
end process;
fpga_wakeup <= wakup_buf;
fpga_awake <= '0';
process(clk_main)
begin
    if(rising_edge(clk_main))then
        if(sleep_en = '1') then
            if(Gm_count_pre_sum >= 1) then
                if(wakup_cnt = 2500000) then --0.05s
                    wakup_cnt <= 0;
                elsif(wakup_cnt =0) then
                    wakup_buf <= not(wakup_buf);
                    wakup_cnt <= wakup_cnt + 1;
                else    
                    wakup_cnt <= wakup_cnt + 1;
                end if;
            end if;    
        else
            wakup_buf <= '1';  
            wakup_cnt <= 0;
        end if;    
    end if;
end process;

end Behavioral;
