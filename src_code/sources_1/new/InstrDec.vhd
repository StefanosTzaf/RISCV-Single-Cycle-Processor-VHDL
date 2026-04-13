----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 08:05:36 PM
-- Design Name: 
-- Module Name: InstrDec - Behavioral
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

entity InstrDec is
    Port ( 
        Opcode    : in  STD_LOGIC_VECTOR (4 downto 0);
        
        -- these signals will go as input to the datapath
        ResultSrc : out STD_LOGIC;
        MemWrite  : out STD_LOGIC;
        ALUSrc    : out STD_LOGIC;
        ImmSrc    : out STD_LOGIC_VECTOR(1 downto 0);
        RegWrite  : out STD_LOGIC;
      
        -- for alu decoder
        rop     : out STD_LOGIC_VECTOR(2 downto 0)
    );
end InstrDec;

architecture Behavioral of InstrDec is

begin

    process(Opcode)

        variable ResultSrc_v : STD_LOGIC;
        variable MemWrite_v  : STD_LOGIC;
        variable ALUSrc_v    : STD_LOGIC;
        variable ImmSrc_v    : STD_LOGIC_VECTOR(1 downto 0);
        variable RegWrite_v  : STD_LOGIC;
        variable rop_v       : STD_LOGIC_VECTOR(2 downto 0);
        variable opcode_v    : STD_LOGIC_VECTOR(4 downto 0);
    begin

        -- initial values to avoid latches
        ResultSrc_v := '0';
        MemWrite_v  := '0';
        ALUSrc_v    := '0';
        ImmSrc_v    := "00";
        RegWrite_v  := '0';
        rop_v       := "111"; -- no op 
        opcode_v    := Opcode;

        case opcode_v is
            -- LW
            when "00000" => 
                ResultSrc_v := '1';
                ALUSrc_v    := '1';
                RegWrite_v  := '1';
                rop_v       := "000";

            --  R-Type
            when "01100" => 
                RegWrite_v  := '1';
                rop_v       := "010";

            -- I-Type
            when "00100" => 
                ALUSrc_v    := '1';
                RegWrite_v  := '1';
                rop_v       := "011";


            -- SW
            when "01000" => 
                MemWrite_v  := '1';
                ALUSrc_v    := '1';
                ImmSrc_v    := "01";
                rop_v       := "001";

            when others =>
                ResultSrc_v := '0';
                MemWrite_v  := '0';
                ALUSrc_v    := '0';
                ImmSrc_v    := "00";
                RegWrite_v  := '0';
                rop_v       := "111"; -- no op
        end case;

        -- assign variable values to output ports
        ResultSrc <= ResultSrc_v;
        MemWrite  <= MemWrite_v;
        ALUSrc    <= ALUSrc_v;
        ImmSrc    <= ImmSrc_v;
        RegWrite  <= RegWrite_v;
        rop       <= rop_v;
    end process;

end Behavioral;
