----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2026 06:17:25 PM
-- Design Name: 
-- Module Name: ControlUnit_tb - Behavioral
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

entity ControlUnit_tb is
--  Port ( );
end ControlUnit_tb;

architecture Behavioral of ControlUnit_tb is

    component ControlUnit is
        Port (
            opcode : in std_logic_vector(4 downto 0);
            funct3 : in std_logic_vector(2 downto 0);
            funct7 : in std_logic;

            ResultSrc  : out std_logic;
            MemWrite   : out std_logic;
            ALUSrc     : out std_logic;
            ImmSrc     : out std_logic_vector(1 downto 0);
            RegWrite   : out std_logic;
            ALUControl : out std_logic_vector(2 downto 0)
        );
    end component;

    signal opcode_tb     : STD_LOGIC_VECTOR(4 downto 0);
    signal funct3_tb     : STD_LOGIC_VECTOR(2 downto 0);
    signal funct7_tb     : STD_LOGIC;
    signal ResultSrc_tb  : STD_LOGIC;
    signal MemWrite_tb   : STD_LOGIC;
    signal ALUSrc_tb     : STD_LOGIC;
    signal ImmSrc_tb     : STD_LOGIC_VECTOR(1 downto 0);
    signal RegWrite_tb   : STD_LOGIC;
    signal ALUControl_tb : STD_LOGIC_VECTOR(2 downto 0);


begin
    UUT: ControlUnit
        Port map (
            opcode     => opcode_tb,
            funct3     => funct3_tb,
            funct7     => funct7_tb,
            ResultSrc  => ResultSrc_tb,
            MemWrite   => MemWrite_tb,
            ALUSrc     => ALUSrc_tb,
            ImmSrc     => ImmSrc_tb,
            RegWrite   => RegWrite_tb,
            ALUControl => ALUControl_tb
        );


    test_process: process
    begin
        -- TEST CASE 1: R-Type (Opcode = 01100)
        -- RegWrite=1, ALUSrc=0, ImmSrc=00, MemWrite=0, ResultSrc=0

        -- ADD (funct3=000, funct7=0) ALUControl 000
        opcode_tb <= "01100";
        funct3_tb <= "000";
        funct7_tb <= '0';
        wait for 10 ns;
        
        -- SUB (funct3=000, funct7=1) ALUControl 001
        opcode_tb <= "01100"; 
        funct3_tb <= "000"; 
        funct7_tb <= '1';
        wait for 10 ns;

        -- AND (funct3=111) ALUControl 100
        opcode_tb <= "01100"; 
        funct3_tb <= "111"; 
        funct7_tb <= '0';
        wait for 10 ns;

        -- OR (funct3=110) ALUControl 101
        opcode_tb <= "01100"; 
        funct3_tb <= "110"; 
        funct7_tb <= '0';
        wait for 10 ns;
        
        -- XOR (funct3=100) ALUControl 110
        opcode_tb <= "01100"; 
        funct3_tb <= "100"; 
        funct7_tb <= '0';
        wait for 10 ns;


        -- I-Type Opcode = 00100
        -- RegWrite=1, ALUSrc=1, ImmSrc=00, MemWrite=0, ResultSrc=0
        -- ADDI (funct3=000) ALUControl 000
        opcode_tb <= "00100";
        funct3_tb <= "000";
        funct7_tb <= '0';
        wait for 10 ns;

        -- XORI (funct3=100) ALUControl 110
        opcode_tb <= "00100"; 
        funct3_tb <= "100"; 
        wait for 10 ns;

        -- ORI (funct3=110) ALUControl 101
        opcode_tb <= "00100"; 
        funct3_tb <= "110"; 
        wait for 10 ns;

        -- ANDI (funct3=111) ALUControl 100
        opcode_tb <= "00100";
        funct3_tb <= "111";
        wait for 10 ns;


        -- LW (Opcode = 00000)
        -- ResultSrc=1, ALUSrc=1, RegWrite=1, ALUControl="000" ImmSrc="00" MemWrite=0
        opcode_tb <= "00000";
        funct3_tb <= "010";
        wait for 10 ns;

        -- SW (Opcode = 01000)
        -- MemWrite=1, ALUSrc=1, ImmSrc="01", RegWrite=0, ALUControl="000" ResultSrc=0
        opcode_tb <= "01000"; 
        funct3_tb <= "010"; 
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
