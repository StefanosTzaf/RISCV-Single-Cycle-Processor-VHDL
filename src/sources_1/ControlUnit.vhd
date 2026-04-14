----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 09:21:33 PM
-- Design Name: 
-- Module Name: ControlUnit - Structural
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

entity ControlUnit is
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
end ControlUnit;

architecture Structural of ControlUnit is

    component InstrDec is
        Port ( 
            Opcode    : in  STD_LOGIC_VECTOR (4 downto 0);
            ResultSrc : out STD_LOGIC;
            MemWrite  : out STD_LOGIC;
            ALUSrc    : out STD_LOGIC;
            ImmSrc    : out STD_LOGIC_VECTOR(1 downto 0);
            RegWrite  : out STD_LOGIC;
        
            -- for alu decoder
            rop     : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component ALUDec is
    Port (
        funct3     : in STD_LOGIC_VECTOR(2 downto 0);
        Funct7     : in STD_LOGIC;
        rop        : in STD_LOGIC_VECTOR(2 downto 0);
        ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
     );
     end component;

     signal ALUControl_internal : STD_LOGIC_VECTOR(2 downto 0);

begin

    InstrDec_component : InstrDec
        port map(
            Opcode => opcode,
            ResultSrc => ResultSrc,
            MemWrite => MemWrite,
            ALUSrc => ALUSrc,
            ImmSrc => ImmSrc,
            RegWrite => RegWrite,
            rop => ALUControl_internal
         );
         
    ALUDec_component : ALUDec 
        port map(
            funct3 => funct3,
            Funct7 => funct7,
            rop => ALUControl_internal,
            ALUControl => ALUControl
        );
    
end Structural;