----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:29:29 PM
-- Design Name: 
-- Module Name: Program_counter - Behavioral
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

entity Program_counter is
    generic (
        N : positive := 32
    );
    port (
        Clk      : in  STD_LOGIC;
        Reset    : in  STD_LOGIC;
        PC_In    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        PC_Out   : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end Program_counter;

architecture Behavioral of Program_counter is
begin

    PC_update: process(clk, Reset)
    begin
        if Reset = '1' then
            PC_Out <= (others => '0');
        elsif rising_edge(Clk) then
            PC_Out <= PC_In;
        end if;
    end process PC_update;

end Behavioral;

