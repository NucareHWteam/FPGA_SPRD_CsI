----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/10/11 14:13:09
-- Design Name: 
-- Module Name: eeprom_protocol - Behavioral
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

entity eeprom_protocol is
 Port (
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : out     STD_LOGIC;                             --initiate transaction
    hv_wr_en   : in std_logic;
    cl_wr_en   : in std_logic;
    su_wr_en   : in std_logic;
    
    ----25.01.03-----------------------
    init_wr_en : in std_logic;
    init_wr_addr : in std_logic_vector(24 - 1 downto 0);
    init_wr_data : in std_logic_vector(24 - 1 downto 0);
     ------------------------------------
    
    rd_en   : in std_logic;
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
    GM_count_threshold_read  : out std_logic_vector(8 - 1 downto 0);
    temp_a_read              : out std_logic_vector(32 - 1 downto 0);
    temp_b_read              : out std_logic_vector(32 - 1 downto 0);
    GC_a_read                : out std_logic_vector(32 - 1 downto 0);
    GC_b_read                : out std_logic_vector(32 - 1 downto 0);
    
    read_end                 : out std_logic;
    
    rx_data : IN    STD_LOGIC_VECTOR(8-1 DOWNTO 0)); --data received
end eeprom_protocol;



architecture Behavioral of eeprom_protocol is
TYPE spi_machine IS(spi_idle,write_en, data_state,write_disable,hv_data_state,serial_data_state,init_data_state);                           --state machine data type
  SIGNAL spi_state       : spi_machine:=spi_idle;                              --current state
signal ena_buf : std_logic;
signal busy_pipe : std_logic_vector(1 downto 0);
signal busy_cnt : integer:=0;
signal hv_wr_en_pipe : std_logic_vector(1 downto 0);
signal cl_wr_en_pipe : std_logic_vector(1 downto 0);
signal rd_en_pipe : std_logic_vector(1 downto 0);
signal wr_wait_cnt : integer := 0;
signal eeprom_address : std_logic_vector(24-1 downto 0):=X"000001";
signal write_data : std_logic_vector(16-1 downto 0):=X"6978";
signal read_mode : std_logic := '0';
signal spi_end  : std_logic := '0';
signal read_data : std_logic_vector(16 - 1 downto 0);
signal hv_write : std_logic:='0';
signal su_write_en : std_logic:='0';
signal initial_write_en : std_logic:='0';
signal su_wr_en_pipe : std_logic_vector(1 downto 0):="00";
signal init_wr_en_pipe : std_logic_vector(1 downto 0):="00";
--signal read_end : std_logic:='0';
attribute mark_debug : string;
    attribute mark_debug of hv_wr_en : signal is "true";
    attribute mark_debug of cl_wr_en : signal is "true";
    attribute mark_debug of rd_en : signal is "true";
    attribute mark_debug of busy : signal is "true";
    attribute mark_debug of enable : signal is "true";
    attribute mark_debug of spi_state : signal is "true";
    attribute mark_debug of busy_cnt : signal is "true";
    attribute mark_debug of hv_wr_en_pipe : signal is "true";
    attribute mark_debug of cl_wr_en_pipe : signal is "true";
    attribute mark_debug of rd_en_pipe : signal is "true";
    attribute mark_debug of tx_data : signal is "true";
    attribute mark_debug of busy_pipe : signal is "true";
    attribute mark_debug of rx_data : signal is "true";
    attribute mark_debug of read_data : signal is "true";
    attribute mark_debug of GC_read : signal is "true";
    attribute mark_debug of Temp_read : signal is "true";
    attribute mark_debug of Ch_32Kev_read : signal is "true";
    attribute mark_debug of Ch_662Kev_read : signal is "true";
    attribute mark_debug of Ch_1460Kev_read : signal is "true";
    attribute mark_debug of D_lab_read : signal is "true";
    attribute mark_debug of HV_DAC_read : signal is "true";
    attribute mark_debug of Threshold_read : signal is "true";
    attribute mark_debug of SignalTime_read : signal is "true";
    attribute mark_debug of Data_subtraction_read : signal is "true";
    attribute mark_debug of Serial_1_read : signal is "true";
    attribute mark_debug of Serial_2_read : signal is "true";
    attribute mark_debug of Serial_3_read : signal is "true";
    attribute mark_debug of Serial_4_read : signal is "true";
    attribute mark_debug of Serial_5_read : signal is "true";
    attribute mark_debug of Serial_6_read : signal is "true";
    
    
    
    
begin
enable <= ena_buf;
process(reset_n,clock)
begin
    if(reset_n = '0')then
    elsif(rising_edge(clock))then
        busy_pipe <= busy_pipe(0) & busy;
        hv_wr_en_pipe<= hv_wr_en_pipe(0) & hv_wr_en;
        cl_wr_en_pipe<= cl_wr_en_pipe(0) & cl_wr_en;
        rd_en_pipe<= rd_en_pipe(0) & rd_en;
        su_wr_en_pipe <= su_wr_en_pipe(0) & su_wr_en;
        init_wr_en_pipe <= init_wr_en_pipe(0) & init_wr_en;
        if(busy_pipe = "01")then
           busy_cnt <= busy_cnt + 1;
        end if;
        case spi_state is
            when spi_idle =>
            read_end <= '0';
            busy_cnt <= 0;
            spi_end  <= '0';
                if(hv_wr_en_pipe = "01") then
                    spi_state <= write_en;
                    read_mode <= '0';
                    su_write_en  <= '0';
                    hv_write  <= '1';
                elsif(cl_wr_en_pipe = "01") then 
                    spi_state <= write_en;
                    read_mode <= '0';
                    hv_write  <= '0';
                    su_write_en  <= '0';
                elsif(rd_en_pipe = "01") then
                    spi_state <= data_state;
                    read_mode <= '1';
                    read_end <= '0';
                    su_write_en  <= '0';
                elsif(su_wr_en_pipe = "01") then
                    spi_state <= write_en;
                    read_mode <= '0';
                    hv_write  <= '0';
                    su_write_en  <= '1';  
                elsif(init_wr_en_pipe = "01") then
                    spi_state <= write_en;  
                    initial_write_en <= '1';
                    
                end if;
            when write_en =>
                case busy_cnt is
                    when 0 =>  
                            spi_end         <= '0';
                            ena_buf         <= '1';
                            tx_data         <= "00000110";
                            cont            <= '0';
                           
                    when 1 =>
                        ena_buf      <= '0'; 
                        if(busy_pipe = "10") then
                            spi_end <= '1';
                        end if;
                        if(spi_end = '1') then
                            if(wr_wait_cnt = 10000) then
                                                                           
                                busy_cnt     <=  0 ;    
                                wr_wait_cnt  <=  0 ;
                                if(hv_write = '1') then    
                                    spi_state    <= hv_data_state;
                                elsif(su_write_en = '1') then
                                    spi_state    <= Serial_data_state;
                                elsif(initial_write_en = '1') then
                                    spi_state <= init_data_state;
                                else
                                    spi_state    <= data_state;
                                end if;    
                            else
                                wr_wait_cnt <= wr_wait_cnt + 1;    
                            end if; 
                          end if;         
                    when others =>
                    
                    end case;
             when data_state =>
                case busy_cnt is
                    when 0 =>                          
                         ena_buf         <= '1';
                         if(read_mode = '0') then
                            tx_data         <= "00000010";   -- write mode
                         else
                            tx_data         <= "00000011";   -- read mode
                         end if; 
                         cont            <= '1';  
                    when 1 =>
                         ena_buf      <= '0';
                          tx_data         <=eeprom_address(24 - 1 downto 16);   
                                 
                    when 2 =>
                         tx_data         <=eeprom_address(16 - 1 downto 8); 
                              
                    when 3 =>
--                      if(read_mode = '0') then
                          tx_data         <=eeprom_address(8 - 1 downto 0); 
--                      else
--                          tx_data         <= X"02";
--                      end if;    
                         
                    when 4 =>  
                        if(read_mode = '0') then
                            tx_data         <=GC(16 - 1 downto 8);
                        else
                            tx_data         <=(others => '0');
                        end if;
                    when 5 =>  
                        if(read_mode = '0') then
                            tx_data         <=GC(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                GC_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                    when 6 =>  
                        if(read_mode = '0') then
                            tx_data         <=Temp(16 - 1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                GC_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 7 =>  
                        if(read_mode = '0') then
                            tx_data         <=Temp(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                temp_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                   when 8 =>  
                        if(read_mode = '0') then
                            tx_data         <=Ch_32Kev(16 - 1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                temp_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                   when 9 =>  
                        if(read_mode = '0') then
                            tx_data         <=Ch_32Kev(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Ch_32Kev_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                   when 10 =>  
                        if(read_mode = '0') then
                            tx_data         <=Ch_662Kev(16 - 1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Ch_32Kev_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                   when 11 =>  
                        if(read_mode = '0') then
                            tx_data         <=Ch_662Kev(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Ch_662Kev_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                   when 12 =>  
                        if(read_mode = '0') then
                            tx_data         <=Ch_1460Kev(16 - 1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Ch_662Kev_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                   when 13 =>  
                        if(read_mode = '0') then
                            tx_data         <=Ch_1460Kev(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Ch_1460Kev_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                   when 14 =>  
                        if(read_mode = '0') then
                            tx_data         <=D_lab(16 - 1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Ch_1460Kev_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 15 =>  
                        if(read_mode = '0') then
                            tx_data         <=D_lab(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                D_lab_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                    when 16 =>  
                        if(read_mode = '0') then
                            tx_data         <=HV_DAC(16 - 1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                D_lab_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 17 =>  
                        if(read_mode = '0') then
                            tx_data         <=HV_DAC(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                hv_dac_read(16 - 1 downto 8) <= rx_data;
                            end if;
                        end if;
                    when 18 =>  
                        if(read_mode = '0') then
                            tx_data         <=Threshold(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                hv_dac_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 19 =>  
                        if(read_mode = '0') then
                            tx_data         <=SignalTime(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Threshold_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 20 =>  
                        if(read_mode = '0') then
                            tx_data         <=Data_subtraction(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                SignalTime_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 21 =>  
                        if(read_mode = '0') then
                            tx_data         <=Serial_1(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Data_subtraction_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 22 =>  
                        if(read_mode = '0') then
                            tx_data         <=Serial_2(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Serial_1_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 23 =>  
                        if(read_mode = '0') then
                            tx_data         <=Serial_3(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Serial_2_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 24 =>  
                        if(read_mode = '0') then
                            tx_data         <=Serial_4(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Serial_3_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 25 =>  
                        if(read_mode = '0') then
                            tx_data         <=Serial_5(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Serial_4_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                    when 26 =>  
                        if(read_mode = '0') then
                            tx_data         <=Serial_6(8 - 1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Serial_5_read(8 - 1 downto 0) <= rx_data;
                            end if;
                        end if;
                                
                    when 27 =>
                       if((su_write_en = '0')and(read_mode='0'))then  
                            if(busy_pipe = "10") then
                                spi_end <= '1';         
                            end if;
                            if(spi_end = '1') then
                                if(wr_wait_cnt = 10000) then
                                    busy_cnt     <=  0 ;    
                                    wr_wait_cnt  <=  0 ;  
                                    spi_state <= write_disable;       
                                else
                                    wr_wait_cnt <= wr_wait_cnt + 1;    
                                end if; 
                            end if; 
                            cont <= '0';   
                        else
                            if(read_mode = '0') then
                                tx_data         <= GM_count_threshold; --Reserve 
                            else
                                tx_data         <=(others => '0');
                                if(busy_pipe = "10") then
                                    Serial_6_read(8 - 1 downto 0) <= rx_data;
                                end if;
                            end if;
                        end if;  
                    when 28 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --Reserve
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                GM_count_threshold_read(8 - 1 downto 0) <= rx_data;  --Reserve
                            end if;
                        end if; 
                    when 29 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --Reserve 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                               -- Serial_6_read(8 - 1 downto 0) <= rx_data;  --Reserve
                            end if;
                        end if;
                    when 30 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_a(32-1 downto 24);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                               -- Serial_6_read(8 - 1 downto 0) <= rx_data;  --Reserve
                            end if;
                        end if;
                     when 31 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_a(24-1 downto 16);
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_a_read(32 - 1 downto 24) <= rx_data; 
                            end if;
                        end if; 
                    when 32 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_a(16-1 downto 8); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_a_read(24 - 1 downto 16) <= rx_data; 
                            end if;
                        end if;
                    when 33 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_a(8-1 downto 0);
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_a_read(16 - 1 downto 8) <= rx_data; 
                            end if;
                        end if;                              
                    when 34 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_b(32-1 downto 24); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_a_read(8 - 1 downto 0) <= rx_data; 
                            end if;
                        end if;
                    when 35 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_b(24-1 downto 16);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_b_read(32 - 1 downto 24) <= rx_data; 
                            end if;
                        end if;
                    when 36 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_b(16-1 downto 8);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_b_read(24 - 1 downto 16) <= rx_data; 
                            end if;
                        end if;
                    when 37 => 
                        if(read_mode = '0') then
                            tx_data         <=Temp_b(8-1 downto 0); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_b_read(16 - 1 downto 8) <= rx_data; 
                            end if;
                        end if;
                    when 38 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_a(32-1 downto 24); 
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Temp_b_read(8 - 1 downto 0) <= rx_data;  
                            end if;
                        end if;    
                    when 39 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_a(24-1 downto 16);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_a_read(32 - 1 downto 24) <= rx_data;  
                            end if;
                        end if;
                    when 40 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_a(16-1 downto 8);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_a_read(24 - 1 downto 16) <= rx_data;  
                            end if;
                        end if;
                     when 41 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_a(8-1 downto 0);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_a_read(16 - 1 downto 8) <= rx_data;  
                            end if;
                        end if;
                    when 42 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_b(32-1 downto 24);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_a_read(8 - 1 downto 0) <= rx_data;  
                            end if;
                        end if;
                    when 43 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_b(24-1 downto 16);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_b_read(32 - 1 downto 24) <= rx_data;  
                            end if;
                        end if;
                    when 44 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_b(16-1 downto 8);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_b_read(24 - 1 downto 16) <= rx_data;  
                            end if;
                        end if;
                    when 45 => 
                        if(read_mode = '0') then
                            tx_data         <=GC_b(8-1 downto 0);  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_b_read(16 - 1 downto 8) <= rx_data;  
                            end if;
                        end if;
                    when 46 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --reserve  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                                Gc_b_read(8 - 1 downto 0) <= rx_data;  
                            end if;
                        end if;
                    when 47 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --reserve  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                               -- Gc_b_read(8 - 1 downto 0) <= rx_data; -- Reserve  
                            end if;
                        end if;
                    when 48 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --reserve  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                               -- Gc_b_read(8 - 1 downto 0) <= rx_data; -- Reserve  
                            end if;
                        end if;
                    when 49 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --reserve  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                               -- Gc_b_read(8 - 1 downto 0) <= rx_data; -- Reserve  
                            end if;
                        end if;
                    when 50 => 
                        if(read_mode = '0') then
                            tx_data         <=X"FF"; --reserve  
                        else
                            tx_data         <=(others => '0');
                            if(busy_pipe = "10") then
                               -- Gc_b_read(8 - 1 downto 0) <= rx_data; -- Reserve  
                            end if;
                        end if;
                    when 51 =>
                        if(busy_pipe = "10") then
                            spi_end <= '1';
                            if(read_mode = '1') then
                                read_end <= '1';
                                --Serial_6_read(8 - 1 downto 0) <= rx_data; --Reserve
                            end if;    
                        end if;
                        if(spi_end = '1') then
                            if(wr_wait_cnt = 10000) then
                                busy_cnt     <=  0 ;    
                                wr_wait_cnt  <=  0 ;  
                                if(read_mode = '1') then  
                                    spi_state <= spi_idle;
                                else
                                    spi_state <= write_disable;
                                end if;       
                            else
                                wr_wait_cnt <= wr_wait_cnt + 1;    
                            end if; 
                        end if; 
                        cont <= '0';  
                    when others =>
                    
                    end case;
            when write_disable => 
                case busy_cnt is
                    when 0 =>  
                          ena_buf         <= '1';
                          tx_data         <= "00000100";
                          cont            <= '0';
                    when 1 =>  
                          ena_buf         <= '0';
                          if(busy_pipe = "10") then 
                                busy_cnt <= 0;
                                spi_state <= spi_idle; 
                          end if;      
                    when others =>
                    end case;   
            when hv_data_state =>
                case busy_cnt is
                    when 0 =>                          
                         ena_buf         <= '1';                         
                         tx_data         <= "00000010";   -- write mode
                         cont            <= '1';  
                         hv_write        <= '0';
                    when 1 =>
                         ena_buf      <= '0';
                          tx_data         <=X"00";     -- addr
                                 
                    when 2 =>
                         tx_data          <=X"00";     -- addr   
                    when 3 =>
                          tx_data         <=X"0d";     -- addr
                    when 4 =>  
                          tx_data         <=HV_DAC(16 - 1 downto 8);
                    when 5 =>  
                          tx_data         <=HV_DAC(8 - 1 downto 0); 
                    when 6 => 
                        if(busy_pipe = "10") then
                            spi_end <= '1';   
                        end if;
                        if(spi_end = '1') then
                            if(wr_wait_cnt = 10000) then
                                busy_cnt     <=  0 ;    
                                wr_wait_cnt  <=  0 ;  
                                if(read_mode = '1') then  
                                    spi_state <= spi_idle;
                                else
                                    spi_state <= write_disable;
                                end if;       
                            else
                                wr_wait_cnt <= wr_wait_cnt + 1;    
                            end if; 
                        end if; 
                        cont <= '0'; 
                         
                    when others =>
                    end case;  
            when serial_data_state =>
                case busy_cnt is
                    when 0 =>                          
                         ena_buf         <= '1';                         
                         tx_data         <= "00000010";   -- write mode
                         cont            <= '1';  
                         hv_write        <= '0';
                    when 1 =>
                         ena_buf      <= '0';
                          tx_data         <=X"00";     -- addr
                                 
                    when 2 =>
                         tx_data          <=X"00";     -- addr   
                    when 3 =>
                          tx_data         <=X"12";     -- addr   Serial1 addr
                    when 4 =>  
                          tx_data         <=Serial_1(8 - 1 downto 0);
                    when 5 =>  
                          tx_data         <=Serial_2(8 - 1 downto 0);
                    when 6 =>  
                          tx_data         <=Serial_3(8 - 1 downto 0);
                    when 7 =>  
                          tx_data         <=Serial_4(8 - 1 downto 0);
                    when 8 =>  
                          tx_data         <=Serial_5(8 - 1 downto 0);
                    when 9 =>  
                          tx_data         <=Serial_6(8 - 1 downto 0);             
                    when 10 => 
                        if(busy_pipe = "10") then
                            spi_end <= '1';   
                        end if;
                        if(spi_end = '1') then
                            if(wr_wait_cnt = 10000) then
                                busy_cnt     <=  0 ;    
                                wr_wait_cnt  <=  0 ;  
                                if(read_mode = '1') then  
                                    spi_state <= spi_idle;
                                else
                                    spi_state <= write_disable;
                                end if;       
                            else
                                wr_wait_cnt <= wr_wait_cnt + 1;    
                            end if; 
                        end if; 
                        cont <= '0'; 
                   when others =>
            
                   end case;      
            when init_data_state =>
                case busy_cnt is
                    when 0 =>                          
                         ena_buf         <= '1';                         
                         tx_data         <= "00000010";   -- write mode
                         cont            <= '1';  
                         initial_write_en        <= '0';
                    when 1 =>
                         ena_buf      <= '0';
                          tx_data         <=init_wr_addr(24 - 1 downto 16);     -- addr
                                 
                    when 2 =>
                         tx_data          <=init_wr_addr(16 - 1 downto 8);     -- addr   
                    when 3 =>
                          tx_data         <=init_wr_addr(8 - 1 downto 0);     -- addr
                    when 4 =>  
                          tx_data         <=init_wr_data(16 - 1 downto 8);
                    when 5 =>  
                          tx_data         <=init_wr_data(8 - 1 downto 0); 
                    when 6 => 
                        if(busy_pipe = "10") then
                            spi_end <= '1';   
                        end if;
                        if(spi_end = '1') then
                            if(wr_wait_cnt = 10000) then
                                busy_cnt     <=  0 ;    
                                wr_wait_cnt  <=  0 ;  
                                if(read_mode = '1') then  
                                    spi_state <= spi_idle;
                                else
                                    spi_state <= write_disable;
                                end if;       
                            else
                                wr_wait_cnt <= wr_wait_cnt + 1;    
                            end if; 
                        end if; 
                        cont <= '0'; 
                         
                    when others =>
                    end case;                    
            when others =>
            
            end case;        
    end if;
end process;

end Behavioral;
