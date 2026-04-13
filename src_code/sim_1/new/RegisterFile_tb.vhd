----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:49:27 PM
-- Design Name: 
-- Module Name: RegisterFile_tb - Behavioral
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

entity RegisterFile_tb is
end RegisterFile_tb;

architecture Behavioral of RegisterFile_tb is

    -- to avoid problems with generic map in Post Synthesis simulations
    constant N_tb : integer := 4;
    constant M_tb : integer := 32;
    constant CLK_PERIOD : time := 10 ns;

    component RegisterFile is
    
        Port (
            Clk       : in STD_LOGIC;
            RegWrite  : in STD_LOGIC;
            ADDR_W    : in STD_LOGIC_VECTOR (N_tb-1 downto 0);
            ADDR_R1   : in STD_LOGIC_VECTOR (N_tb-1 downto 0);
            ADDR_R2   : in STD_LOGIC_VECTOR (N_tb-1 downto 0);
            DATA_IN   : in STD_LOGIC_VECTOR (M_tb-1 downto 0);
            DATA_OUT1 : out STD_LOGIC_VECTOR (M_tb-1 downto 0);
            DATA_OUT2 : out STD_LOGIC_VECTOR (M_tb-1 downto 0)
         );
    end component;
    
    signal Clk_tb, RegWrite_tb              : std_logic := '0';
    signal ADDR_W_tb, ADDR_R1_tb,ADDR_R2_tb : std_logic_vector(N_tb-1 downto 0) := (others => '0');
    signal DATA_IN_tb                       : std_logic_vector(M_tb-1 downto 0) := (others => '0');
    signal DATA_OUT1_tb, DATA_OUT2_tb       : std_logic_vector(M_tb-1 downto 0);
    
begin

    UUT: RegisterFile 
        port map ( 
            Clk       => Clk_tb,
            RegWrite  => RegWrite_tb,
            ADDR_W    => ADDR_W_tb,
            ADDR_R1   => ADDR_R1_tb,
            ADDR_R2   => ADDR_R2_tb,
            DATA_IN   => DATA_IN_tb,
            DATA_OUT1 => DATA_OUT1_tb,
            DATA_OUT2 => DATA_OUT2_tb
         );
         
         
    clk_process: process
    begin
        Clk_tb <= '0';
        wait for CLK_PERIOD/2;
        Clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    
    test: process
    begin
        
        RegWrite_tb <= '1';
        ADDR_W_tb   <= "0001"; -- x1
        DATA_IN_tb  <= x"0000000A"; -- value 10
        wait for CLK_PERIOD;
        
        -- read must have value 10
        ADDR_R1_tb  <= "0001";
        wait for CLK_PERIOD;
        
        RegWrite_tb <= '0';
        wait for CLK_PERIOD;
        
        -- write should not work WE=0
        ADDR_W_tb  <= "0010";
        DATA_IN_tb <= x"FFFFFFFF";
        wait for CLK_PERIOD;
        
        -- read -- must read 0
        ADDR_R2_tb <= "0010";
        wait for CLK_PERIOD;
        
        ADDR_W_tb  <= "0010";
        DATA_IN_tb <= x"00000005";
        wait for CLK_PERIOD;
        
        RegWrite_tb <= '1';
        wait for CLK_PERIOD;
        
        -- now it musst be able to read value 5
        ADDR_R2_tb <= "0010";
        wait for CLK_PERIOD;        
        wait;
    end process test;
    
end Behavioral;

