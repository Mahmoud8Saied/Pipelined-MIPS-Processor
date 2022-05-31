library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity CU is
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
        swape        : OUT std_logic;
        Ret_op       : OUT std_logic; 
        Load_Op      : Out std_logic
    );
end entity CU;

architecture rtl of CU is
    
begin

   proc_name: process(Opcode, Funct)
   begin

    case( Opcode ) is
    
        when "000000" =>  -- NOP 
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0'; 
            Ret_op       <=  '0';
            Load_Op      <=  '0';
                
        when "000001" =>  -- HLT 
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '1'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0'; 
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when "000010" =>  -- SETC 
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0001"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0'; 
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when "000011" =>  -- R-Type operations 

            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '1'; 
            
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
           
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0'; 
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

            case( Funct ) is
            
                when "00000000000" =>   -- NOT Rd 
                    
                    ALU_Control  <=  "0010";  
                    Reg_Dst      <=  '0'; 

                when "00000000001" =>   -- INC Rd 
                    
                    ALU_Control  <=  "0011"; 
                    Reg_Dst      <=  '0'; 
 
            
                when "00000000010" =>   -- Mov Rs, Rd
                    
                    ALU_Control  <=  "1010";  
                    Reg_Dst      <=  '0';

                when "00000000011" =>   -- ADD Rd, Rs1, Rs2
                    
                    ALU_Control  <=  "0100";  
                    Reg_Dst      <=  '0'; 

                when "00000000100" =>   -- SUB Rd, Rs1, Rs2
                    
                    ALU_Control  <=  "0101";  
                    Reg_Dst      <=  '0';

                when "00000000101" =>   -- AND Rd, Rs1, Rs2
                    
                    ALU_Control  <=  "0110";  
                    Reg_Dst      <=  '0';
                    
                when others =>
                    
                    ALU_Control  <=  "0000";  
                    Reg_Dst      <=  '0';
            
            end case ;

        when "000100" =>  -- OUT Rd 
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "1100"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '1';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';
        
        when "010001" =>  -- IN Rd 
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '1'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '1'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';
        
        when "010010" =>  -- IADD Rd, Rs, Imm
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '1'; 
            Reg_Dst      <=  '1'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0111"; 
            ALU_Src      <=  '1'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';
        
        when "000101" =>  -- PUSH and POP Instructions
    
             
            MEM_to_Reg   <=  '1'; 
             
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '1'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

            case( Funct ) is
            
                when "00000000000" =>   -- Push Rd
                    
                    MEM_Write    <=  '1';
                    Reg_Write    <=  '0'; 

                when "00000000001" =>   -- Pop Rd 
                    
                    MEM_Write    <=  '0';
                    Reg_Write    <=  '1';

                when others =>
                
                    MEM_Write    <=  '0';
                    Reg_Write    <=  '0';
                
            
            end case ;

        when "000110" =>  -- LDM Rd, Imm
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '1'; 
            Reg_Dst      <=  '1'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '1'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';
        
        when "000111" =>  -- LDD Rd, offs (Rs)
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '1'; 
            Reg_Write    <=  '1'; 
            Reg_Dst      <=  '1'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0100"; 
            ALU_Src      <=  '1'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '1';
         
        when "001000" =>  -- STD Rs1, offs (Rs2)
    
            MEM_Write    <=  '1'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0100"; 
            ALU_Src      <=  '1'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';
        
        when "001001" =>  -- JZ Imm
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '1'; 
            Jmp_Cond     <=  "01"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '1'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when "001010" =>  -- JN Imm
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '1'; 
            Jmp_Cond     <=  "10"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0'; 
            swape        <=  '0';   
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when "001011" =>  -- JC Imm
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '1'; 
            Jmp_Cond     <=  "11"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when "001100" =>  -- Jmp Imm
    
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '1'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0'; 
            swape        <=  '0';  
            Ret_op       <=  '0';
            Load_Op      <=  '0'; 

        when "001101" =>  -- CALL Imm
    
            MEM_Write    <=  '1'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '1'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '1'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';  
            Ret_op       <=  '0';
            Load_Op      <=  '0';
        
        when "001110" =>  -- RET    

            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '1'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '1';
            Load_Op      <=  '0';

        when "001111" =>  -- INT index    

            MEM_Write    <=  '1'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '1'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '1'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when "010000" =>  -- RTI    

            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '1'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '1';
            Load_Op      <=  '0';

        when "010011"  => -- Swape 
  
            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '1'; 
            
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
           
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "1111"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0'; 

            ALU_Control  <=  "1010";  
            Reg_Dst      <=  '1';

            swape        <=  '1';
            Ret_op       <=  '0';
            Load_Op      <=  '0';

        when others => 

            MEM_Write    <=  '0'; 
            MEM_to_Reg   <=  '0'; 
            Reg_Write    <=  '0'; 
            Reg_Dst      <=  '0'; 
            Sp_or_Pc     <=  '0'; 
            LD_Imm       <=  '0'; 
            Jmp          <=  '0'; 
            Jmp_Cond     <=  "00"; 
            Call_Control <=  '0'; 
            INT_Control  <=  '0'; 
            ALU_Control  <=  "0000"; 
            ALU_Src      <=  '0'; 
            Buffers_En   <=  "0000"; 
            HLT_Control  <=  '0'; 
            IN_or_WB     <=  '0'; 
            Out_Control  <=  '0';
            swape        <=  '0';
            Ret_op       <=  '0';
            Load_Op      <=  '0';
            
    end case ;
       
   end process proc_name;
    
    
    
end architecture rtl;
