----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/02/2026 04:29:58 PM
-- Design Name: 
-- Module Name: datapath - Behavioral
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


entity Datapath is
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
        
        -- output for Control unit
        NZVC          : out STD_LOGIC_VECTOR(3 downto 0);
        -- ouptuts for the general outputs of the processor
        PC_out        : out STD_LOGIC_VECTOR(N-1 downto 0);
        Instr_out     : out STD_LOGIC_VECTOR(N-1 downto 0);
        ALUResult_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        WriteData_out : out STD_LOGIC_VECTOR(N-1 downto 0);
        Result_out    : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end Datapath;

architecture Structural of Datapath is


    component Program_counter is
        generic (
            N : positive := 32
        );
        port (
            Clk      : in  STD_LOGIC;
            Reset    : in  STD_LOGIC;
            PC_In    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            PC_Out   : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    
    component Instruction_memory is
        generic (
            N : positive := 6;
            M : positive := 32
        );
        port (
            A     : in  STD_LOGIC_VECTOR (N-1 downto 0);
            Instr : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
    

    component Adder_by_4 is
        generic (
            N : positive := 32
        );
        port (
            A       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            B       : in  STD_LOGIC_VECTOR(N-1 downto 0);
            PCPlus4 : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;

    
    component RegisterFile is
        generic (
            N : positive := 4;
            M : positive := 32
        );
        port (
            Clk       : in  STD_LOGIC;
            RegWrite  : in  STD_LOGIC;
            ADDR_W    : in  STD_LOGIC_VECTOR (N-1 downto 0);
            ADDR_R1   : in  STD_LOGIC_VECTOR (N-1 downto 0);
            ADDR_R2   : in  STD_LOGIC_VECTOR (N-1 downto 0);
            DATA_IN   : in  STD_LOGIC_VECTOR (M-1 downto 0);
            DATA_OUT1 : out STD_LOGIC_VECTOR (M-1 downto 0);
            DATA_OUT2 : out STD_LOGIC_VECTOR (M-1 downto 0)
        );
    end component;
    

    component Extend is
        Port (
            instr  : in  STD_LOGIC_VECTOR (31 downto 7);
            ImmSrc : in  STD_LOGIC_VECTOR (1 downto 0);
            ExtImm : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
    

    component Mux2to1 is
        generic (
            N : positive := 32
        );
        port (
            In0    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            In1    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Sel    : in  STD_LOGIC;
            MuxOut : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    

    component ALU is
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
            ALUResult  : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;


    component DataMemory is
        generic (
            N : positive := 5;
            M : positive := 32
        );
        port (
            Clk      : in  STD_LOGIC;
            MemWrite : in  STD_LOGIC;
            Addr     : in  STD_LOGIC_VECTOR(N-1 downto 0);
            WriteData: in  STD_LOGIC_VECTOR(M-1 downto 0);
            ReadData : out STD_LOGIC_VECTOR(M-1 downto 0)
        );
    end component;

    
    signal pc_current           : std_logic_vector(N-1 downto 0); -- current value of program counter
    signal pc_plus4             : std_logic_vector(N-1 downto 0); -- pc after addition of 4 component
    signal PC_target            : std_logic_vector(N-1 downto 0); -- target address for branch/jump instructions
    signal Instr                : std_logic_vector(N-1 downto 0); -- output of instruction memory component
    signal rd1, rd2             : std_logic_vector(N-1 downto 0); -- output of register file component
    signal result               : std_logic_vector(N-1 downto 0); -- data to be written back to register file
    signal ExtImm               : std_logic_vector(N-1 downto 0); -- output of extend component
    signal SrcB                 : std_logic_vector(N-1 downto 0); -- second input of ALU (after multiplexer selection)
    signal N_f,Z_f,V_f,C_f      : std_logic;                      -- ALU flags before output
    signal ALUResult            : std_logic_vector(N-1 downto 0); -- output of ALU input for data memory component
    signal read_data_mem        : std_logic_vector(N-1 downto 0); -- output of data memory component


begin

    -- 2.1.1
    PC_component : Program_counter 
        port map ( 
            Clk    => Clk, 
            Reset  => Reset, 
            PC_In  => pc_plus4,
            PC_Out => pc_current 
        );

    -- 2.1.2
    InstructionMem_component : Instruction_memory 
        port map ( 
            A     => pc_current(7 downto 2), 
            Instr => Instr 
        );

    -- 2.1.3
    PCAdder_component : Adder_by_4 
        port map (
            A       => pc_current, 
            B       => std_logic_vector(to_unsigned(4, 32)), 
            PCPlus4 => pc_plus4
        );

    -- 2.2.1
    RegisterFile_component : RegisterFile 
        generic map ( N => 5 )
        port map ( 
            Clk       => Clk, 
            RegWrite  => RegWrite, 
            ADDR_R1   => Instr(19 downto 15), 
            ADDR_R2   => Instr(24 downto 20), 
            ADDR_W    => Instr(11 downto 7), 
            DATA_IN   => result, 
            DATA_OUT1 => rd1, 
            DATA_OUT2 => rd2
        );
                        
    -- 2.2.2
    Extend_component : Extend 
        port map ( 
            instr  => Instr(31 downto 7), 
            ImmSrc => ImmSrc, 
            ExtImm => ExtImm
        );

    -- 2.3.1
    MuxSrcB_component : Mux2to1 
        port map (
            In0    => rd2, 
            In1    => ExtImm, 
            Sel    => AluSrc, 
            MuxOut => SrcB
        );

    -- 2.3.2
    ALU_component : ALU 
        port map (
            SrcA       => rd1, 
            SrcB       => SrcB, 
            ALUControl => ALUControl, 
            N_flag     => N_f, 
            Z_flag     => Z_f, 
            C_flag     => C_f,
            V_flag     => V_f, 
            ALUResult  => ALUResult
        );
          
    -- 2.4.1
    DataMemory_component : DataMemory 
        port map ( 
            Clk       => Clk, 
            MemWrite  => MemWrite, 
            Addr      => ALUResult(6 downto 2), 
            WriteData => rd2, 
            ReadData  => read_data_mem
        );

    -- 2.5.1
    MuxResult_component : Mux2to1 
        port map ( 
            In0    => ALUResult, 
            In1    => read_data_mem, 
            Sel    => ResultSrc, 
            MuxOut => result
        );

    -- 2.5.2 NOT IMPLEMENTED AS ASSIGNMENT SAYS
--    PCAdderBranch_component : Adder_by_4 
--        port map ( 
--            A       => pc_current, 
--            B       => ExtImm, 
--            PCPlus4 => PC_target 
--        );

    -- 2.5.3
--    MuxPCSrc_component : Mux2to1 
--        port map ( 
--            In0    => pc_plus4, 
--            In1    => PC_target, 
--            Sel    => PCSrc, 
--            MuxOut => pc_next 
--        );
        

PC_out        <= pc_current;
ALUResult_out <= ALUResult;
WriteData_out <= rd2;
Result_out    <= result;
Instr_out     <= Instr;
NZVC          <= N_f & Z_f & V_f & C_f;

end Structural;

