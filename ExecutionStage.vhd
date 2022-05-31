LIBRARY ieee;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY ExecutionStage IS
    PORT (
        clk, rst, alu_source : IN STD_LOGIC; --Clock, Reset, ALU Source for R2(1 means immediate value)
        opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --Opcode of the operation
        register1_decoded, register2_decoded, immediate_value, input_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --The value decoded from Rs, Rd, and the immediate value coming from sign extend
        ExMem_WB, MemWB_WB : IN STD_LOGIC; --Write back signal From buffers after execution and after memory
        IdEx_Rs, IdEx_Rd, ExMem_Rd, MemWB_Rd : IN STD_LOGIC_VECTOR (4 DOWNTO 0); --Register values used for forwarding
        Dest1,Dest2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0); --15:11 or 20:16
        ExMem_Val, MemWB_Val : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --The forwarded values from the next stages 
        MEM_Write            : IN std_logic;
        MEM_to_Reg           : IN std_logic;
       
        Reg_Write            : IN std_logic;
        Reg_Dst              : IN std_logic;
        Sp_or_Pc             : IN std_logic;
        LD_Imm               : IN std_logic;
        Jmp                  : IN std_logic;
        Jmp_Cond             : IN std_logic_vector(1 downto 0) ;
        Call_Control         : IN std_logic;
        INT_Control          : IN std_logic;
        --ALU_Control          : IN std_logic_vector(3 downto 0);
        HLT_Control          : IN std_logic;
        IN_or_WB             : IN std_logic;
        Out_Control          : IN std_logic;


        zero_flag, negative_flag, carry_flag : OUT STD_LOGIC; --The flag register outputs;
        alu_result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --The final output of the ALU execution;
        

        MEM_Write_Out            : Out std_logic;
        
        MEM_to_Reg_Out       : Out std_logic;
        Reg_Write_Out        : Out std_logic;
        Sp_or_Pc_Out             : Out std_logic;
        LD_Imm_Out                : Out std_logic;
        --Jmp_Out                   : Out std_logic;
        --Jmp_Cond_Out              : Out std_logic_vector(1 downto 0) ;
        Call_Control_Out          : Out std_logic;
        INT_Control_Out           : Out std_logic;    
        HLT_Control_Out           : Out std_logic;
        Out_Control_Out           : Out std_logic;
    ----------------------------------------------------------------------------------------------
        Dest                      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        IN_or_WB_Out              : Out std_logic;
        Sign_Ext_Exec_out         : Out std_logic_vector(31 downto 0);
        branch_control            : Out std_logic; 

        ALU_In1, ALU_In2          : Out std_logic_vector(31 downto 0); 

    ---- For Inport Forwarding

        In_or_WB_Forwarding       : In std_logic;

        Inport_WB_Forwarding      : In std_logic_vector(31 downto 0);
        
        IN_or_WB_MEM              : IN std_logic;

        INport_MEM_Data           : IN std_logic_vector(31 downto 0);

    ------------------------------------------------------------------------------------------
    ---- For Swape Forwarding 

        Swape_WB_Forwarding       : In std_logic;
        Swap_Dst_Forwarding       : In std_logic_vector(4 downto 0);
        Swap_Data_Forwarding      : In std_logic_vector(31 downto 0);

        Swape_MEM_Forwarding          : In std_logic;
        Swap_Dst_MEM_Forwarding       : In std_logic_vector(4 downto 0);
        Swap_Data_MEM_Forwarding      : In std_logic_vector(31 downto 0);
    ------------------------------------------------------------------------------------------
    ----- For LoadImm Forwarding

        LoadImm_MEM, LoadImm_WB                 : In std_logic;
        LoadImm_MEM_Data, LoadImm_WB_Data       : In std_logic_vector(31 downto 0)

    ------------------------------------------------------------------------------------------

    );
END ENTITY ExecutionStage;

ARCHITECTURE ExecutionStage1 OF ExecutionStage IS

    COMPONENT ALU IS
        GENERIC (n : INTEGER := 32);
        PORT (
            inp1, inp2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0); --Inputs
            opr : IN STD_LOGIC_VECTOR (3 DOWNTO 0); --Operation to be done, take only 4 bits (2->5)
            result_output : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0); --Result of operation
            zero_flag, negative_flag, carry_flag : OUT STD_LOGIC; --Flags
            flags_enable : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)); --Flags Enable, 0->Zero, 1->Neg, 2->Carry
    END COMPONENT;

    COMPONENT FlagRegister IS
        GENERIC (n : INTEGER := 3);
        PORT (
            clk, rst : IN STD_LOGIC;
            d, enable,clear : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0); -- enable(0) -> Zero, enable(1) -> negative, enable(2) -> carry
            q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
    END COMPONENT;



     COMPONENT ForwardingUnit IS
        PORT (
            IdEx_Rs, IdEx_Rd, ExMem_Rd, MemWB_Rd : IN STD_LOGIC_VECTOR (4 DOWNTO 0); --Register values
            ExMem_WB, MemWB_WB : IN STD_LOGIC; --Write back signal

            IN_or_WB           : IN std_logic;
            IN_or_WB_MEM       : IN std_logic;

            Swape_WB_Forwarding       : In std_logic;
            Swap_Dst_Forwarding       : In std_logic_vector(4 downto 0);

            Swape_MEM_Forwarding          : In std_logic;
            Swap_Dst_MEM_Forwarding       : In std_logic_vector(4 downto 0);

            LoadImm_MEM, LoadImm_WB       : In std_logic;

            R1_signal, R2_signal : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)); --Signal for mux for both inputs of the ALU
    END COMPONENT;
    COMPONENT MUX4 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            s : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            data_in3 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            data_in4 : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            data_in5 : in std_logic_vector(n - 1 downto 0);
            data_in6 : in std_logic_vector(n - 1 downto 0);
            data_in7 : in std_logic_vector(n - 1 downto 0);
            data_in8 : in std_logic_vector(n - 1 downto 0);
            data_in9 : in std_logic_vector(n - 1 downto 0);
            
            data_out : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
    END COMPONENT;

--------------------------------------------------------------------
    component CCReg IS
	PORT( 
		ZF,NF,CF : IN  std_logic;
		s 	     : IN  std_logic_vector (1 DOWNTO 0); --JmpCond
		out0 	 : OUT std_logic
	);
    END component CCReg;

    signal alu_flags_clear : std_logic_vector(2 downto 0);
    signal Jmp_Cond_out : std_logic;
--------------------------------------------------------------------


    SIGNAL forwarding_unit_signal1, forwarding_unit_signal2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL alu_input1, alu_input1_tmp, alu_input2_tmp, alu_input2, alu_result_tmp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_flags_output : STD_LOGIC_VECTOR(2 DOWNTO 0); --The output of flags for current operation, 0-> zero, 1->neg, 2->carry
    SIGNAL alu_flags_enable : STD_LOGIC_VECTOR(2 DOWNTO 0); --The output of flags for current operation, 0-> zero, 1->neg, 2->carry
    SIGNAL flag_final_value : STD_LOGIC_VECTOR(2 DOWNTO 0); --The value of the flag registers
BEGIN
    --Instantiate the MUXes and the correct input for ALU
    m1 : MUX4 GENERIC MAP(32) PORT MAP(forwarding_unit_signal1, register1_decoded, ExMem_Val, MemWB_Val, Inport_WB_Forwarding, Swap_Data_Forwarding, Swap_Data_MEM_Forwarding, INport_MEM_Data, LoadImm_WB_Data, LoadImm_MEM_Data, alu_input1_tmp);
    m2 : MUX4 GENERIC MAP(32) PORT MAP(forwarding_unit_signal2, register2_decoded, ExMem_Val, MemWB_Val, Inport_WB_Forwarding, Swap_Data_Forwarding, Swap_Data_MEM_Forwarding, INport_MEM_Data, LoadImm_WB_Data, LoadImm_MEM_Data, alu_input2_tmp); --We use a tmp register for alu inp2 as we still have to make a condition for immediate values 
    
    alu_input2 <= alu_input2_tmp WHEN alu_source = '0' ELSE
        immediate_value;
--    WITH opcode SELECT --Select input from Rdst if it is a one operand instruction
--         alu_input1 <= alu_input2_tmp WHEN "0010" | "0011",
--         alu_input1_tmp WHEN OTHERS;

    alu_input1 <= alu_input1_tmp;
    
    --Instantiate the ALU unit
    alu1 : ALU GENERIC MAP(32) PORT MAP(alu_input1, alu_input2, opcode(3 DOWNTO 0), alu_result_tmp, alu_flags_output(0), alu_flags_output(1), alu_flags_output(2), alu_flags_enable);
    
    
    ----------------------------------------------------------------------------------------------------------------    
    
    ALU_In1 <= alu_input1;
    ALU_In2 <= alu_input2_tmp;

    --If Jmp satisfied clear the flag

    alu_flags_clear (0) <= '1' when (Jmp = '1' and Jmp_cond = "01")
    else '0';

    alu_flags_clear (1) <= '1' when (Jmp = '1' and Jmp_cond = "10")
    else '0';

    alu_flags_clear (2) <= '1' when (Jmp = '1' and Jmp_cond = "11")
    else '0';

    --branch control signal

    Branch : CCReg PORT MAP (flag_final_value(0), flag_final_value(1), flag_final_value(2), Jmp_cond, Jmp_Cond_out);

    branch_control <= Jmp_Cond_out and Jmp;
    -----------------------------------------------------------------------------------------------------------------

    
    --Instantiate the ALU Flags register
    ccr1 : FlagRegister GENERIC MAP(3) PORT MAP(clk, rst, alu_flags_output, alu_flags_enable, alu_flags_clear, flag_final_value);
    --Instantiate the Forwarding Unit
    fu1 : ForwardingUnit PORT MAP(IdEx_Rs, IdEx_Rd, ExMem_Rd, MemWB_Rd, ExMem_WB, MemWB_WB, In_or_WB_Forwarding, IN_or_WB_MEM, Swape_WB_Forwarding, Swap_Dst_Forwarding, Swape_MEM_Forwarding, Swap_Dst_MEM_Forwarding, LoadImm_MEM, LoadImm_WB, forwarding_unit_signal1, forwarding_unit_signal2);

    --Instantiate the MUX for destination of the WB whether it's Load or ALU
    Dest <= Dest1 WHEN Reg_Dst = '0' ELSE
        Dest2;

    alu_result <= alu_result_tmp;
    zero_flag <= flag_final_value(0);
    negative_flag <= flag_final_value(1);
    carry_flag <= flag_final_value(2);

    MEM_Write_Out <= MEM_Write;
    
    MEM_to_Reg_Out <= MEM_to_Reg ;     
    Reg_Write_Out <= Reg_Write;

    Sp_or_Pc_Out <= Sp_or_Pc;
    LD_Imm_Out <=  LD_Imm;            

    Call_Control_Out <= Call_Control;
    INT_Control_Out <= INT_Control;
         
    HLT_Control_Out <= HLT_Control;           
    Out_Control_Out <= Out_Control;  
    IN_or_WB_Out    <= IN_or_WB;
    
    Sign_Ext_Exec_out <= immediate_value;    

end architecture;
