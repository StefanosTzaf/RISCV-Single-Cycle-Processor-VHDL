----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 02:32:32 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is

    generic (
        N : positive := 32
    );

    Port ( 
        SrcA            : in STD_LOGIC_VECTOR (N-1 downto 0);
        SrcB            : in STD_LOGIC_VECTOR (N-1 downto 0);
        ALUControl      : in STD_LOGIC_VECTOR (2 downto 0);

        N_flag          : out STD_LOGIC;
        Z_flag          : out STD_LOGIC;
        C_flag          : out STD_LOGIC;
        V_flag          : out STD_LOGIC;
        ALUResult       : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
    
end ALU;

architecture Behavioral of ALU is
begin
-- Follow Esa Protocol, everything with variables inside a single process
P_ALU_COMB: process(SrcA, SrcB, ALUControl)
        variable v_res          : signed(N-1 downto 0);
        variable v_srcA         : signed(N-1 downto 0);
        variable v_srcB         : signed(N-1 downto 0);
        variable v_flags        : STD_LOGIC_VECTOR(3 downto 0);
        variable v_alu_control  : STD_LOGIC_VECTOR(2 downto 0);
        variable v_ext_res      : unsigned(N downto 0);
        -- for NOR gate z flag
        variable v_or_reduction : STD_LOGIC;

    begin
        
        v_srcA        := signed(SrcA);
        v_srcB        := signed(SrcB);
        v_alu_control := ALUControl;
        v_res         := (others => '0');
        v_ext_res     := (others => '0');
        v_flags    := "0000";
        
        case v_alu_control is
            when "000" =>
                v_res     := v_srcA + v_srcB;
                v_ext_res := unsigned('0' & std_logic_vector(v_srcA)) + unsigned('0' & std_logic_vector(v_srcB));
                                   
            when "001" =>
                v_res     := v_srcA - v_srcB;
                v_ext_res := unsigned('0' & std_logic_vector(v_srcA)) - unsigned('0' & std_logic_vector(v_srcB));

            when "100" =>
                v_res     := v_srcA and v_srcB;

            when "101" =>
                v_res     := v_srcA or v_srcB;

            when "110" =>
                v_res     := v_srcA xor v_srcB;

            when others =>
                    v_res := (others => '0');
        end case;
        
        -- FLAGS
        if v_alu_control = "000" or v_alu_control = "001" then
            -- Carry flag
            if v_ext_res(N) = '1' then
                v_flags(0) := '1';
            end if;

            -- Overflow flag SUB case
            if(v_alu_control = "001") then
                if((v_srcA(N-1) /= v_srcB(N-1)) and (v_res(N-1) /= v_srcA(N-1))) then
                    v_flags(1) := '1';
                end if;
            else -- ADD case
                if((v_srcA(N-1) = v_srcB(N-1)) and (v_res(N-1) /= v_srcA(N-1))) then
                    v_flags(1) := '1';
                end if;
            end if;    
            
            -- in VHDL 2008 this can be written more easily but since a NOR gate is asked 
            -- we had to implement it
            v_or_reduction := '0';
            for i in 0 to N-1 loop
                v_or_reduction := v_or_reduction or v_res(i);
            end loop;
            v_flags(2) := not v_or_reduction;

            -- Negative flag
            v_flags(3) := v_res(N-1);
        end if;
        -- write outputs
        ALUResult <= std_logic_vector(v_res);
        N_flag    <= v_flags(3);
        Z_flag    <= v_flags(2);
        V_flag    <= v_flags(1);
        C_flag    <= v_flags(0);
        
        
    end process P_ALU_COMB;


end Behavioral;