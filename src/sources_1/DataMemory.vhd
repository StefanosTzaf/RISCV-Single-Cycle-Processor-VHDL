----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:32:48 PM
-- Design Name: 
-- Module Name: DataMemory - Behavioral
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

entity DataMemory is
    generic (
        N : positive := 5;
        M : positive := 32
    );
    port (
        Clk       : in  STD_LOGIC;
        MemWrite  : in  STD_LOGIC;
        Addr      : in  STD_LOGIC_VECTOR(N-1 downto 0);
        WriteData : in  STD_LOGIC_VECTOR(M-1 downto 0);
        ReadData  : out STD_LOGIC_VECTOR(M-1 downto 0)
    );
end DataMemory;

architecture Behavioral of DataMemory is
    type RAM_type is array (0 to (2**N)-1) of STD_LOGIC_VECTOR(M-1 downto 0);
    signal RAM : RAM_type := (others => (others => '0'));
begin

    -- sync write
    write: process(Clk)
    begin
        if rising_edge(Clk) then
            if MemWrite = '1' then
                RAM(to_integer(unsigned(Addr))) <= WriteData;
            end if;
        end if;
    end process write;

    -- read
    ReadData <= RAM(to_integer(unsigned(Addr)));

end Behavioral;