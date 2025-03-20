----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2023/05/08 14:11:21
-- Design Name: 
-- Module Name: adc_protocol - Behavioral
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
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
	use UNISIM.vcomponents.all;
library xil_defaultlib;
    use xil_defaultlib.all;

entity adc_protocol is
  Port ( 
        rst  : in std_logic;
        clk  : in std_logic;
        ena  : out std_logic:='0';
        addr : out std_logic_vector(6 downto 0);
        wr   : out std_logic;
        data_rd_sel : in std_logic;
        data_wr : out std_logic_vector(7 downto 0);
        data_rd : in std_logic_vector(7 downto 0);
--        adc_ch  : in std_logic_vector(7 downto 0);
        adc_temp_out : out std_logic_vector(16 - 1 downto 0);
        adc_3p3_out  : out std_logic_vector(16 - 1 downto 0);
        adc_2p8_out  : out std_logic_vector(16 - 1 downto 0);
        adc_1p8_out  : out std_logic_vector(16 - 1 downto 0);
        adc_1p0_out  : out std_logic_vector(16 - 1 downto 0)
  );
end adc_protocol;

architecture Behavioral of adc_protocol is




signal reset : std_logic;
constant i2c_idle : std_logic_vector(3 downto 0):= "0000";
constant i2c_command : std_logic_vector(3 downto 0):= "0001";
constant i2c_read : std_logic_vector(3 downto 0):= "0010";
constant i2c_read2_wait : std_logic_vector(3 downto 0):= "0011";
constant i2c_read2 : std_logic_vector(3 downto 0):= "0100";
constant i2c_config_read_wait : std_logic_vector(3 downto 0):= "0101";
constant i2c_config_read : std_logic_vector(3 downto 0):= "0110";
constant i2c_stop : std_logic_vector(3 downto 0):= "0111";
constant i2c_write_opcode : std_logic_vector(3 downto 0):= "1000";
constant i2c_write_reg : std_logic_vector(3 downto 0):= "1001";
constant i2c_write_data : std_logic_vector(3 downto 0):= "1010";
constant i2c_read_start : std_logic_vector(3 downto 0):= "1011";
constant i2c_stop2 : std_logic_vector(3 downto 0):= "1100";

signal i2c_state : std_logic_vector(3 downto 0):=i2c_idle;
signal data_rd_sel_pipe : std_logic_vector(1 downto 0);
signal data_rd_sel_pipe2 : std_logic_vector(1 downto 0);
signal adc_data : std_logic_vector(15 downto 0);
signal adc_data0 : std_logic_vector(15 downto 0);
signal adc_data1 : std_logic_vector(15 downto 0);
signal adc_data2 : std_logic_vector(15 downto 0);
signal adc_data3 : std_logic_vector(15 downto 0);
signal adc_data4 : std_logic_vector(15 downto 0);
signal adc_data5 : std_logic_vector(15 downto 0);
signal adc_stop_cnt : integer:=0;
signal config_data : std_logic_vector(7 downto 0);
signal rst_n : std_logic:='1';
signal ena_buf : std_logic;
signal ena_pipe : std_logic_vector(1 downto 0);
--signal adc_data_out : std_logic_vector(16 - 1 downto 0);
signal read_ch_sel : integer range 0 to 4 :=0;
signal data_rst : std_logic:='0';
signal cfg_autoseq_set : std_logic_vector(1 downto 0):="00";
signal adc_ch : std_logic_vector( 7 downto 0):=X"01";
attribute mark_debug : string;
    attribute mark_debug of i2c_state : signal is "true";
    attribute mark_debug of adc_data : signal is "true";
    attribute mark_debug of config_data : signal is "true";
    attribute mark_debug of data_rd_sel_pipe : signal is "true";
    attribute mark_debug of adc_stop_cnt : signal is "true";
    attribute mark_debug of adc_temp_out : signal is "true";
    attribute mark_debug of read_ch_sel : signal is "true";
    attribute mark_debug of adc_data0 : signal is "true";
    attribute mark_debug of adc_data1 : signal is "true";
    attribute mark_debug of adc_data2 : signal is "true";
    attribute mark_debug of adc_data3 : signal is "true";
    attribute mark_debug of adc_data4 : signal is "true";
    attribute mark_debug of adc_data5 : signal is "true";
    attribute mark_debug of data_wr : signal is "true";
    attribute mark_debug of adc_ch : signal is "true";


begin
reset <= not(rst);
ena   <= ena_buf;
process(reset,clk)
begin
    if(reset = '1')then
    elsif(rising_edge(clk))then
        data_rd_sel_pipe <= data_rd_sel_pipe(0)&data_rd_sel;
        data_rd_sel_pipe2 <= data_rd_sel_pipe2(0)&data_rd_sel_pipe(0);
        case i2c_state is
            when i2c_idle =>
                adc_stop_cnt <= 0;
                ena_buf         <= '1';
                i2c_state   <= i2c_write_opcode;
                addr <= "0010111";
                if(cfg_autoseq_set = "00")then
                    data_wr <= "00001000";
                else
                    data_wr <= "00001000";
                end if;    
                wr <= '0';
            when i2c_write_opcode =>
                if (data_rd_sel_pipe = "01") then
                    i2c_state   <= i2c_write_reg;
                    if(cfg_autoseq_set = "00")then
                        data_wr <= X"02";    
                    elsif(cfg_autoseq_set = "01")then
                        data_wr <= X"12";      
                    else    
                        data_wr <= X"11";
                    end if;     
                end if; 
             when i2c_write_reg =>
                if (data_rd_sel_pipe = "01") then
                    i2c_state   <= i2c_write_data;
                    if(cfg_autoseq_set = "00")then
                        data_wr <= "00010000"; 
                      elsif(cfg_autoseq_set = "01")then
                        data_wr <= X"1b";       
                    else
                        data_wr <= adc_ch;
                    end if;           
                end if;
            when i2c_write_data =>
                if (data_rd_sel_pipe = "01") then
                    i2c_state   <= i2c_stop;
                    ena_buf <= '0';  
                end if;                            
            when i2c_stop =>
                 if(adc_stop_cnt = 1000) then  
                    if(cfg_autoseq_set = "00")then
                        cfg_autoseq_set <= "01";
                        i2c_state   <= i2c_idle;    
                        adc_stop_cnt <= 0;
                    elsif(cfg_autoseq_set = "01")then
                        cfg_autoseq_set <= "10";
                        i2c_state   <= i2c_idle;    
                        adc_stop_cnt <= 0;    
                    else
                        cfg_autoseq_set <= "00";
                        i2c_state   <= i2c_read_start;    
                        adc_stop_cnt <= 0;
                    end if;   
                 else
                    adc_stop_cnt <= adc_stop_cnt + 1;
                 end if;
            when i2c_read_start =>
                adc_stop_cnt <= 0;
                ena_buf         <= '1';
                i2c_state   <= i2c_command;
                addr <= "0010111";
                wr <= '1';
            when i2c_command =>
                if (data_rd_sel_pipe = "01") then
                    i2c_state   <= i2c_read;
                end if;     
            when i2c_read => 
                    i2c_state   <= i2c_read2_wait;
                    adc_data(15 downto 8) <= data_rd;
      
            when i2c_read2_wait =>
                if (data_rd_sel_pipe = "01") then 
                    i2c_state   <= i2c_read2;  
                    ena_buf         <= '0';                        
                end if;
            when i2c_read2 =>
                    i2c_state   <= i2c_stop2;    
                    adc_stop_cnt <= 0;   
                    adc_data(7 downto 0) <= data_rd;           
             when i2c_stop2 =>
                 if(adc_stop_cnt = 500000) then  
                    i2c_state   <= i2c_idle;    
                    adc_stop_cnt <= 0;   
                       
                        if(adc_data(3 downto 0) = X"0")then
                            adc_data0 <= adc_data;
                            adc_ch  <= X"01";
                        elsif(adc_data(3 downto 0) = X"1")then
                            adc_data1 <= adc_data;
                            adc_ch  <= X"02";
                        elsif(adc_data(3 downto 0) = X"2")then
                            adc_data2 <= adc_data;
                            adc_ch  <= X"03";
                        elsif(adc_data(3 downto 0) = X"3")then
                            adc_data3 <= adc_data;
                            adc_ch  <= X"04";
                        elsif(adc_data(3 downto 0) = X"4")then
                            adc_data4 <= adc_data;
                            adc_ch  <= X"05";
                        elsif(adc_data(3 downto 0) = X"5")then
                            adc_data5 <= adc_data;
                            adc_ch  <= X"00";    
                        end if;
                      
                 else
                    adc_stop_cnt <= adc_stop_cnt + 1;
                 end if;                  
            when others =>
            
            end case;
    end if;
end process;

process(reset,clk)
begin
    if(reset = '1')then
    elsif(rising_edge(clk))then
        ena_pipe <= ena_pipe(0) & ena_buf;
        if(ena_pipe = "10") then
            adc_temp_out <= adc_data1;
            adc_3p3_out <= adc_data2;
            adc_2p8_out <= adc_data3;
            adc_1p8_out <= adc_data4;
            adc_1p0_out <= adc_data5;
        end if;
    end if;
end process;


end Behavioral;
