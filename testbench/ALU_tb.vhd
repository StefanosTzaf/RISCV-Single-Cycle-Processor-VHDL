----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 03:01:45 PM
-- Design Name: 
-- Module Name: ALU_tb - Behavioral
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

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is

    constant N_tb : integer := 32;
    
    component ALU is
        Port ( 
            SrcA        : in STD_LOGIC_VECTOR (N_tb-1 downto 0);
            SrcB        : in STD_LOGIC_VECTOR (N_tb-1 downto 0);
            ALUControl  : in STD_LOGIC_VECTOR (2 downto 0);
            N_flag      : out STD_LOGIC;
            Z_flag      : out STD_LOGIC;
            C_flag      : out STD_LOGIC;
            V_flag      : out STD_LOGIC;
            ALUResult   : out STD_LOGIC_VECTOR (N_tb-1 downto 0)
        );
    end component;

    signal SrcA_tb, SrcB_tb       : STD_LOGIC_VECTOR(N_tb-1 downto 0) := (others => '0');
    signal ALUControl_tb          : STD_LOGIC_VECTOR(2 downto 0) := "000";
    
    signal ALUResult_tb           : STD_LOGIC_VECTOR(N_tb-1 downto 0);
    signal N_tb_flag, Z_tb_flag   : STD_LOGIC;
    signal C_tb_flag, V_tb_flag   : STD_LOGIC;

begin

    UUT: ALU
        port map(
            SrcA       => SrcA_tb,
            SrcB       => SrcB_tb,
            ALUControl => ALUControl_tb,
            N_flag     => N_tb_flag,
            Z_flag     => Z_tb_flag,
            C_flag     => C_tb_flag,
            V_flag     => V_tb_flag,
            ALUResult  => ALUResult_tb
         );

    test: process
    begin

        -- 10 + 20 = 30
        -- Result=30 Flags 0
        ------------------------------------------------------------
        SrcA_tb       <= std_logic_vector(to_unsigned(10, 32));
        SrcB_tb       <= std_logic_vector(to_unsigned(20, 32));
        ALUControl_tb <= "000";
        wait for 20 ns;
        ------------------------------------------------------------
        -- 15 - 15 = 0
        -- Result=0 Z_flag 1
        SrcA_tb       <= std_logic_vector(to_unsigned(15, 32));
        SrcB_tb       <= std_logic_vector(to_unsigned(15, 32));
        ALUControl_tb <= "001";
        wait for 20 ns;

        ------------------------------------------------------------
        -- Max Positive (0x7FFFFFFF) + 1 = 0x80000000 (Negative)
        -- V_flag=1 N_flag=1 overflow

        SrcA_tb       <= x"7FFFFFFF";
        SrcB_tb       <= x"00000001";
        ALUControl_tb <= "000";
        wait for 20 ns;

        ------------------------------------------------------------
        -- Carry(Unsigned Overflow)
        -- 0xFFFFFFFF + 1 = 0x00000000
        -- C_flag=1

        SrcA_tb       <= x"FFFFFFFF";
        SrcB_tb       <= x"00000001";
        ALUControl_tb <= "000";
        wait for 20 ns;


        ------------------------------------------------------------
        -- Max Negative (0x80000000) - 1 = 0x7FFFFFFF (Positive) V_flag=1
        SrcA_tb       <= x"80000000";
        SrcB_tb       <= x"00000001";
        ALUControl_tb <= "001";
        wait for 20 ns;
        
        -- overflow positive max - negative max
        SrcA_tb <= x"7fffffff";
        SrcB_tb <= x"80000000";
        ALUControl_tb <= "001";
        wait for 20 ns;

        ------------------------------------------------------------
        -- result 0 with no flag Z set in logical operations
        SrcA_tb <= x"F0F0F0F0";
        SrcB_tb <= x"0F0F0F0F";
        ALUControl_tb <= "100";
        wait for 20 ns;
        
        -- result -1 = ffffffff (OR)
        ALUControl_tb <= "101";
        wait for 20 ns;
        
        -- result -1 XOR        
        ALUControl_tb <= "110";
        wait for 20 ns;
        
        wait;
    end process;

end Behavioral;