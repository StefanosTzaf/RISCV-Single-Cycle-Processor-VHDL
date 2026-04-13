----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:31:30 PM
-- Design Name: 
-- Module Name: Adder_by_4 - Behavioral
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

entity Adder_by_4 is
    generic (
        N : positive := 32
    );
    port (
        A       : in  std_logic_vector(N-1 downto 0);
        B       : in  std_logic_vector(N-1 downto 0);
        PCPlus4 : out std_logic_vector(N-1 downto 0)
    );
end Adder_by_4;

architecture Behavioral of Adder_by_4 is
begin
    
    PCPlus4 <= std_logic_vector(unsigned(A) + unsigned(B));
end Behavioral;
