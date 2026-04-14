----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:32:09 PM
-- Design Name: 
-- Module Name: Mux2to1 - Behavioral
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

entity Mux2to1 is
    generic (
        N : positive := 32
    );
    port (
        In0    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        In1    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        Sel    : in  STD_LOGIC;
        MuxOut : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end Mux2to1;

architecture Behavioral of Mux2to1 is
begin
    MuxOut <= In0 when (Sel = '0') else In1;
end Behavioral;