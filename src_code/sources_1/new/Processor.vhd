----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 09:39:31 PM
-- Design Name: 
-- Module Name: Processor - Structural
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

entity Processor is
    generic (
        N: positive := 32
    );
    Port ( 
        Clk : in STD_LOGIC;
        Reset : in STD_LOGIC;
        ALUResult_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        WriteData_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        Result_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        PC_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        Instr_out : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end Processor;

architecture Structural of Processor is

component datapath is
    generic (
        N: positive := 32
    );
    Port (
        Clk           : in  STD_LOGIC;
        Reset         : in  STD_LOGIC;
        RegWrite      : in  STD_LOGIC;
        ALUSrc        : in  STD_LOGIC;
        MemWrite      : in  STD_LOGIC;
        ResultSrc     : in  STD_LOGIC;
        ALUControl    : in  STD_LOGIC_VECTOR(2 downto 0);
        ImmSrc        : in  STD_LOGIC_VECTOR(1 downto 0);
        
        -- outputs for the control unit
        NZVC           : out  STD_LOGIC_VECTOR(3 downto 0);
        -- ouptuts for the general outputs of the processor
        PC_out        : out STD_LOGIC_VECTOR(N-1 downto 0);
        Instr_out     : out STD_LOGIC_VECTOR(N-1 downto 0);
        ALUResult_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        WriteData_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        Result_out    : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end component;


component ControlUnit is
    Port (
        opcode : in std_logic_vector(4 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        funct7 : in std_logic;
 
        ResultSrc : out std_logic;
        MemWrite : out std_logic;
        ALUSrc : out std_logic;
        ImmSrc : out std_logic_vector(1 downto 0);
        RegWrite : out std_logic;
        ALUControl : out std_logic_vector(2 downto 0)
     );
end component;


signal RegWrite_internal : std_logic;
signal ALUSrc_internal : std_logic;
signal MemWrite_internal : std_logic;
signal ResultSrc_internal : std_logic;
signal ALUControl_internal : std_logic_vector(2 downto 0);
signal ImmSrc_internal : std_logic_vector(1 downto 0);
signal NZVC_internal : std_logic_vector(3 downto 0);
signal instr_internal : std_logic_vector(N-1 downto 0);
 
begin

    Datapath_component : datapath
        generic map ( N => N )
        port map ( Clk => Clk,
                   Reset => Reset,
                   RegWrite => RegWrite_internal,
                   ALUSrc => ALUSrc_internal, 
                   MemWrite => MemWrite_internal,
                   ResultSrc => ResultSrc_internal,
                   ALUControl => ALUControl_internal,
                   ImmSrc => ImmSrc_internal,
                   PC_out => PC_out,
                   Instr_out => instr_internal,
                   ALUResult_out => ALUResult_out,
                   WriteData_out => WriteData_out,
                   Result_out => Result_out,
                   NZVC => NZVC_internal
        );

    ControlUnit_component : ControlUnit
        port map(Opcode => instr_internal(6 downto 2),
                 funct3 => instr_internal(14 downto 12),
                 funct7 => instr_internal(30),
                 ResultSrc => ResultSrc_internal,
                 MemWrite => MemWrite_internal,
                 ALUSrc => ALUSrc_internal,
                 ImmSrc => ImmSrc_internal,
                 RegWrite => RegWrite_internal,
                 ALUControl => ALUControl_internal
        );

    instr_out <= instr_internal;
    
end Structural;
