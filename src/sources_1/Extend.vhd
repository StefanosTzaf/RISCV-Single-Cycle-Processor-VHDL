----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:31:48 PM
-- Design Name: 
-- Module Name: Extend - Behavioral
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

entity Extend is
    Port (
        instr  : in  STD_LOGIC_VECTOR (31 downto 7);
        ImmSrc : in  STD_LOGIC_VECTOR (1 downto 0);
        ExtImm : out STD_LOGIC_VECTOR (31 downto 0)
    );
end Extend;

architecture Behavioral of Extend is
begin
    process(instr, ImmSrc)
    begin
        case ImmSrc is
            -- type I
            when "00" =>
                ExtImm <= (31 downto 12 => instr(31)) & instr(31 downto 20);
            
            -- type S
            when "01" =>
                ExtImm <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            
            -- type B
            when "10" =>
                ExtImm <= (31 downto 13 => '0') & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
            
            when others =>
                ExtImm <= (others => '0');
        end case;
    end process;
end Behavioral;
