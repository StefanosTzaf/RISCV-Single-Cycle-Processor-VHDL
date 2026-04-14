----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:10:28 PM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    generic (
        N : positive := 4;
        M : positive := 32);
    port (
        Clk       : in STD_LOGIC;
        RegWrite  : in STD_LOGIC;
        ADDR_W    : in STD_LOGIC_VECTOR (N-1 downto 0);
        ADDR_R1   : in STD_LOGIC_VECTOR (N-1 downto 0);
        ADDR_R2   : in STD_LOGIC_VECTOR (N-1 downto 0);
        DATA_IN   : in STD_LOGIC_VECTOR (M-1 downto 0);
        DATA_OUT1 : out STD_LOGIC_VECTOR (M-1 downto 0);
        DATA_OUT2 : out STD_LOGIC_VECTOR (M-1 downto 0));
end RegisterFile;


architecture Behavioral of RegisterFile is
    type RF_array is array (0 to 2**N-1) of STD_LOGIC_VECTOR (M-1 downto 0);
    signal RF : RF_array := (others => (others => '0')); 
begin

    REG_FILE: process (Clk)
    begin
        if rising_edge(Clk) then
            if (RegWrite = '1') then 
                -- do not write in reg 0
                if (to_integer(unsigned(ADDR_W)) /= 0) then
                    RF(to_integer(unsigned(ADDR_W))) <= DATA_IN;
                end if;
            end if;
        end if;
    end process;
    -- if register 0 then return 0
    DATA_OUT1 <= (others => '0') when to_integer(unsigned(ADDR_R1)) = 0 else 
                 RF(to_integer(unsigned(ADDR_R1)));
                 
    DATA_OUT2 <= (others => '0') when to_integer(unsigned(ADDR_R2)) = 0 else 
                 RF(to_integer(unsigned(ADDR_R2)));

end Behavioral;