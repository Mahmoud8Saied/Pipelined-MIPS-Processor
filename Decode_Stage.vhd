library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Decode_Stage is
    port (
        PC_temp      : In std_logic_vector(31 downto 0);
        RD           : In std_logic_vector(4 downto 0);
        WriteData    : In std_logic_vector(31 downto 0);
        RegWrite     : In std_logic;
        clk, rst     : In std_logic;
        Instruction  : In std_logic_vector(31 downto 0);

        Sign_Ext_Out         : Out std_logic_vector(31 downto 0);
        Rdst11, Rdst22       : Out std_logic_vector(4 downto 0);
        Rs1_Out, Rs2_Out     : Out std_logic_vector(4 downto 0);
        PC_temp_out          : Out std_logic_vector(31 downto 0);
        ReadData1, ReadData2 : Out std_logic_vector(31 downto 0);        
        MEM_Write            : Out std_logic;
        MEM_to_Reg           : Out std_logic;
        Reg_Write            : Out std_logic;
        Reg_Dst              : Out std_logic;
        Sp_or_Pc             : Out std_logic;
        LD_Imm               : Out std_logic;
        Jmp                  : Out std_logic;
        Jmp_Cond             : Out std_logic_vector(1 downto 0) ;
        Call_Control         : Out std_logic;
        INT_Control          : Out std_logic;
        ALU_Control          : Out std_logic_vector(3 downto 0);
        ALU_Src              : Out std_logic;
        Buffers_En           : Out std_logic_vector(3 downto 0);
        HLT_Control          : Out std_logic;
        IN_or_WB             : Out std_logic;
        Out_Control          : Out std_logic;
        swape                : Out std_logic;
        Ret_op               : Out std_logic;
        Load_Op              : Out std_logic

    );
end entity Decode_Stage;

architecture rtl of Decode_Stage is
    
    component CU is
        port (
            Opcode : In std_logic_vector(5 downto 0);
            Funct  : In std_logic_vector(10 downto 0);
    
            MEM_Write    : Out std_logic;
            MEM_to_Reg   : Out std_logic;
            Reg_Write    : Out std_logic;
            Reg_Dst      : Out std_logic;
            Sp_or_Pc     : Out std_logic;
            LD_Imm       : Out std_logic;
      
            Jmp          : Out std_logic;
            Jmp_Cond     : Out std_logic_vector(1 downto 0) ;
            Call_Control : Out std_logic;
            INT_Control  : Out std_logic;
    
            ALU_Control  : Out std_logic_vector(3 downto 0);
            ALU_Src      : Out std_logic;
    
            Buffers_En   : Out std_logic_vector(3 downto 0);
            HLT_Control  : Out std_logic;
            IN_or_WB     : Out std_logic;
            Out_Control  : Out std_logic;
            swape        : Out std_logic;
            Ret_op       : Out std_logic;
            Load_Op      : Out std_logic
        );
    end component CU;

    component Sign_Extend is
        port (
            in1  :  IN std_logic_vector(15 downto 0);
            out1 : OUT std_logic_vector(31 downto 0)
        );
    end component Sign_Extend;

    component RegisterFile is
        port (
            RegWrite     : In std_logic;
            clk, rst     : In std_logic;
            Rs1, Rs2     : In std_logic_vector(4 downto 0);
            RD           : In std_logic_vector(4 downto 0);
            WriteData    : In std_logic_vector(31 downto 0);
    
            ReadData1    : Out std_logic_vector(31 downto 0); 
            ReadData2    : Out std_logic_vector(31 downto 0)
        );
    end component RegisterFile;

    signal OPcode  : std_logic_vector(5 downto 0);

    signal Funct : std_logic_vector(10 downto 0);
    
    signal Rs1, Rs2, Rdst1, Rdst2 : std_logic_vector(4 downto 0);

    signal SignExtend_In : std_logic_vector(15 downto 0);

    signal Swape_temp : std_logic;

begin

    OPcode <= Instruction (31 downto 26);

    Funct  <= Instruction (10 downto 0);

    Rs1    <= Instruction (25 downto 21);
    
    Rs2    <= Instruction (20 downto 16);

    Rdst1  <= Instruction (15 downto 11);
    
    Rdst2  <= Instruction (20 downto 16);

    SignExtend_In <= Instruction (15 downto 0);
    
    Sign_Extend1  : Sign_Extend PORT MAP (SignExtend_In, Sign_Ext_Out);

    Control_Unit : CU PORT MAP (Opcode, Funct, MEM_Write, MEM_to_Reg, Reg_Write, Reg_Dst, Sp_or_Pc, LD_Imm, Jmp, Jmp_Cond, Call_Control, INT_Control, ALU_Control, ALU_Src, Buffers_En, HLT_Control, IN_or_WB, Out_Control, Swape_temp, Ret_op, Load_Op);

    RegisterFile1 : RegisterFile PORT MAP (RegWrite, clk, rst, Rs1, Rs2, RD, WriteData, ReadData1, ReadData2);

    PC_temp_out <= PC_temp;

    Rdst11 <= Rdst1;

    Rdst22 <= Rdst2;

    Rs1_Out <= Rs1;

    Rs2_Out <= Rs2;

    swape   <= Swape_temp;

end architecture rtl;