----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2026 08:31:50 PM
-- Design Name: 
-- Module Name: ALUDec - Behavioral
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

entity ALUDec is
    Port (
        funct3     : in STD_LOGIC_VECTOR(2 downto 0);
        Funct7     : in STD_LOGIC;
        rop        : in STD_LOGIC_VECTOR(2 downto 0);
        ALUControl : out STD_LOGIC_VECTOR(2 downto 0)
     );
end ALUDec;

architecture Behavioral of ALUDec is

begin

    Process(funct3, Funct7, rop)
        variable funct3_v     : STD_LOGIC_VECTOR(2 downto 0);
        variable Funct7_v     : STD_LOGIC;
        variable rop_v        : STD_LOGIC_VECTOR(2 downto 0);
        variable ALUControl_v : STD_LOGIC_VECTOR(2 downto 0);
    begin
        funct3_v     := funct3;
        Funct7_v     := Funct7;
        rop_v        := rop;
        ALUControl_v := "111"; -- default to an invalid control signal
        
        case rop is
            when "000" => --LW
                ALUControl_v := "000";
            when "001" => --SW
                ALUControl_v := "000";
            when "010" => --R-type
                case funct3 is
                    when "000" =>
                        if Funct7_v = '0' then
                            ALUControl_v := "000"; -- ADD
                        else
                            ALUControl_v := "001"; -- SUB
                        end if;
                    when "100" =>
                            ALUControl_v := "110"; -- XOR
                    when "110" =>  
                            ALUControl_v := "101"; -- OR
                    when "111" =>
                            ALUControl_v := "100"; -- AND 
                    when others =>
                        ALUControl_v := "111";
                        
                end case;
            when "011" => --I-type
                case funct3 is
                    when "000" =>
                        ALUControl_v := "000"; -- ADDI
                    when "100" =>
                        ALUControl_v := "110"; -- XORI
                    when "110" =>
                        ALUControl_v := "101"; -- ORI
                    when "111" =>
                        ALUControl_v := "100"; -- ANDI
                    when others =>
                        ALUControl_v := "111";
                end case;
            when others =>
                ALUControl_v := "111"; -- default to an invalid control signal
        end case;

        ALUControl <= ALUControl_v;
    end Process;

                        
end Behavioral;
