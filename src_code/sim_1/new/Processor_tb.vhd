----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 12:17:56 AM
-- Design Name: 
-- Module Name: Processor_tb - Behavioral
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

entity Processor_tb is
--  Port ( );
end Processor_tb;


architecture Behavioral of Processor_tb is

    constant N_tb : integer := 32;

    component Processor is
        Port ( 
            Clk           : in STD_LOGIC;
            Reset         : in STD_LOGIC;
            ALUResult_out : out STD_LOGIC_VECTOR(N_tb-1 downto 0);
            WriteData_out : out STD_LOGIC_VECTOR(N_tb-1 downto 0);
            Result_out    : out STD_LOGIC_VECTOR(N_tb-1 downto 0);
            PC_out        : out STD_LOGIC_VECTOR(N_tb-1 downto 0);
            Instr_out     : out STD_LOGIC_VECTOR(N_tb-1 downto 0)
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;

    signal Clk_tb, Reset_tb : STD_LOGIC := '0';
    signal ALUResult_out_tb, WriteData_out_tb, Result_out_tb, PC_out_tb, Instr_out_tb : STD_LOGIC_VECTOR(N_tb-1 downto 0);
begin

    UUT: Processor port map ( Clk => Clk_tb,
                              Reset => Reset_tb,
                              ALUResult_out => ALUResult_out_tb, 
                              WriteData_out => WriteData_out_tb,
                              Result_out => Result_out_tb, 
                              PC_out => PC_out_tb,
                              Instr_out => Instr_out_tb 
                             );
        
    clk_process : process
    begin
        Clk_tb <= '0';
        wait for CLK_PERIOD/2;
        Clk_tb <= '1';
        wait for CLK_PERIOD/2;
    end process;

    test_process : process
    begin
        -- Reset the processor
        Reset_tb <= '1';
        wait for 100 ns;
        wait until rising_edge(Clk_tb);
        Reset_tb <= '0';
        -- Wait for some time to observe the outputs
        wait for 17*CLK_PERIOD;
        -- End the simulation
    end process;
end Behavioral;

