library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;


entity MIPS_Integration is
    port (
    -- Main inputs
        INTR_IN, rst, clk : in std_logic; 
        IN_PORT           : in std_logic_vector(31 downto 0);
        
    -- Temporary Inputs
        --sp_en_in          : in std_logic;
        offset_address_in : in std_logic_vector(31 downto 0);
        from_alu_out_in   : in std_logic_vector(31 downto 0);
        --from_adder_out_in : in std_logic_vector(31 downto 0);
        from_reg1_out_in  : in std_logic_vector(31 downto 0);
        from_reg2_out_in  : in std_logic_vector(31 downto 0);
        --from_pc_inc_in    : in std_logic_vector(31 downto 0);
        from_ccr_in       : in std_logic_vector(31 downto 0);
        
        WriteData_in      : in std_logic_vector(31 downto 0);
        mem_write_Exec    : in std_logic;
        mem_to_reg_control_Exec : in std_logic;
        hlt_control_Exec  : in std_logic;
        sp_or_pc_control_Exec : in std_logic;
        call_control_Exec, branch_control_Exec, int_control_Exec: in std_logic;

   
    -- Main Output
        OUT_PORT          : out std_logic_vector(31 downto 0)
    );
end entity MIPS_Integration;

architecture rtl of MIPS_Integration is

    component Fetching is
        port (
            clk: in std_logic;
            rst: in std_logic;
            --sp_en: in std_logic;
            
            -- Control
            -- hazard_control: in std_logic;
            call_control: in std_logic;
            branch_control: in std_logic;
            hlt_control: in std_logic;
            int_control: in std_logic;
            ret_operation: in std_logic;
            mem_write: in std_logic;
            sp_or_pc_control: in std_logic;
            -- struct_hazard_control: in std_logic;
            mem_to_reg_control: in std_logic;
    
            -- 
            offset_address: in std_logic_vector(31 downto 0);
            from_alu_out: in std_logic_vector(31 downto 0);
            from_adder_out: in std_logic_vector(31 downto 0);
            from_reg1_out: in std_logic_vector(31 downto 0);
            from_reg2_out: in std_logic_vector(31 downto 0);
            from_pc_inc: in std_logic_vector(31 downto 0);
            from_ccr: in std_logic_vector(31 downto 0);      -- ! IT CAN BE 3 bit only
    
            --mem_data_in: in std_logic_vector(31 downto 0);

            -- for swape: 

            PC_Swape_En : in std_logic;

            ----------------------------------------------------------------------
        
    
            -- to be connected to the first buffer
            mem_data_out: out std_logic_vector(31 downto 0);
            pc_inc      : out std_logic_vector(31 downto 0);
            buffer_en_out: out std_logic
        
        );
    end component Fetching;

    component Register_NB is
        Generic (N: integer:= 16);
        port (
            clk, rst, en, flush : IN std_logic;
    
            InPort       : IN  std_logic_vector (N-1 downto 0);
            OutPort      : OUT std_logic_vector (N-1 downto 0)
    
        );
    end component Register_NB;

    component Decode_Stage is
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
    end component Decode_Stage;

    -- component ExecutionStage IS
    --     PORT (
    --         clk, rst, alu_source : IN STD_LOGIC; --Clock, Reset, ALU Source for R2(1 means immediate value)
    --         opcode : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --Opcode of the operation
    --         register1_decoded, register2_decoded, immediate_value: IN STD_LOGIC_VECTOR(31 DOWNTO 0); --The value decoded from Rs, Rd, and the immediate value coming from sign extend
    --         --input_port
    --         Dest1,Dest2          : IN STD_LOGIC_VECTOR(4 DOWNTO 0); --15:11 or 20:16
    --         MEM_Write            : IN std_logic;
    --         MEM_to_Reg           : IN std_logic;
            
    --         Reg_Write            : IN std_logic;
    --         Reg_Dst              : IN std_logic;
    --         Sp_or_Pc             : IN std_logic;
    --         LD_Imm               : IN std_logic;
    --         Jmp                  : IN std_logic;
    --         Jmp_Cond             : IN std_logic_vector(1 downto 0) ;
    --         Call_Control         : IN std_logic;
    --         INT_Control          : IN std_logic;
    --         --ALU_Control          : IN std_logic_vector(3 downto 0);
    --         --Buffers_En           : IN std_logic_vector(3 downto 0);
    --         HLT_Control          : IN std_logic;
    --         IN_or_WB             : IN std_logic;
    --         Out_Control          : IN std_logic;

    --         zero_flag, negative_flag, carry_flag : OUT STD_LOGIC; --The flag register outputs;
    --         alu_result                           : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --The final output of the ALU execution;
            
    --         MEM_Write_Out            : Out std_logic;
            
    --         MEM_to_Reg_Out           : Out std_logic;
    --         Reg_Write_Out            : Out std_logic;
    --         Sp_or_Pc_Out             : Out std_logic;
    --         LD_Imm_Out               : Out std_logic;
    --         --Jmp_Out                   : Out std_logic;
    --         --Jmp_Cond_Out              : Out std_logic_vector(1 downto 0) ;
    --         Call_Control_Out          : Out std_logic;
    --         INT_Control_Out           : Out std_logic;     
    --         --Buffers_En_Out            : Out std_logic_vector(3 downto 0);
    --         HLT_Control_Out           : Out std_logic;
    --         Out_Control_Out           : Out std_logic;
    --         IN_or_WB_Out              : Out std_logic;
    --         Sign_Ext_Exec_out         : Out std_logic_vector(31 downto 0);
    --         Dest                      : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        
    --         branch_control            : Out std_logic
    --     );
    -- END component ExecutionStage;

    component ExecutionStage IS
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
END component ExecutionStage;


component MemStage is 
	PORT(
        MemtoReg_in      :IN std_logic;  --green        (1)
        MemWrite_in      :IN std_logic;   --Bronze      (2)
        SP               :IN std_logic;   --or PC --Black [Just above RegFile]
        RegWrite_in      :IN std_logic;   --Blue        (10)
        LoadImm_in       :IN std_logic;   --Black    [Just above RegFile]
        INPort_in        :IN std_logic;   --or WB  --Black(16) --Last Control signal from control unit
        CCR              :IN std_logic_vector(2 DOWNTO 0); --Black(14)
        ALUout_in        :IN std_logic_vector(31 DOWNTO 0); --Black(13)
        ReadData1_in     :IN std_logic_vector(31 downto 0);    --Black(11)
	    ReadData2_in     :IN std_logic_vector(31 downto 0);
        SignExtendOut_in :IN std_logic_vector(31 downto 0);    --Black(17)
        MuxOut_in        :IN std_logic_vector(4 DOWNTO 0);  --Black(18)-out tal3 men a5er mux fe execution stage
        MemoryOut_in     :IN std_logic_vector(31 downto 0);
    
        MemtoReg_out      :OUT std_logic;  --green  (1)
	    MemWrite_out      :OUT std_logic;
	    SP_out            :OUT std_logic;
	    RegWrite_out      :OUT std_logic;   --Blue  (2)
	    LoadImm_out       :OUT std_logic;
	    INPort_out        :OUT std_logic;
	    CCR_out           :OUT std_logic_vector( 2 downto 0);
	    ALUout_out        :OUT std_logic_vector(31 DOWNTO 0);
	    ReadData1_out     :OUT std_logic_vector(31 downto 0);
	    ReadData2_out     :OUT std_logic_vector(31 downto 0);
	    SignExtendOut_out :OUT std_logic_vector(31 downto 0);
	    MuxOut_out        :OUT std_logic_vector(4 downto 0);
	    MemoryOut_out     :OUT std_logic_vector(31 downto 0) 
	);
end component MemStage;

component WbStage is
    PORT(
        --I saved All the signals in .txt file in case we needed any.
        --I used the order in report and numbered them inorder of design occurrence
        
        MemtoReg         :IN std_logic; --green(1)--input
        OUTControl       :IN std_logic; --Black(3)--input
        RegWrite_in      :IN std_logic; --Blue(2)--input
        INPort_in        :IN std_logic; --(or WB) --Black(7)	
        MemoryOut        :IN std_logic_vector(31 downto 0); --Black(4) --input
        ALUOut           :IN std_logic_vector(31 downto 0); --Black(5) --input
        ReadData1        :IN std_logic_vector(31 downto 0); --Black(6)--input
        SignExtendOut_in :IN std_logic_vector(31 downto 0); --Black(8) --input
        MuxOut_in        :IN std_logic_vector(4 DOWNTO 0);  --Black(9)--out tal3 men a5er mux fe execution stage	--input	
                --5bits since 15:11 and 20:16 are inputs to the Mux
        
        OutPort           :OUT std_logic_vector(31 downto 0);
        RegWrite_out      :OUT std_logic; --to register file
        BigMuxOutput      :OUT std_logic_vector(31 downto 0); 
        INPort_out        :OUT std_logic; --going to mux under register file
        SignExtendOut_out :OUT std_logic_vector(31 downto 0); --going to mux under register file
        MuxOut_out        :OUT std_logic_vector(4 DOWNTO 0) --going to forwarding unit
    );
end component WbStage;

component Multiple_Instructions_Unit is
    port (
        Swap_Op  : In std_logic;
        clk, rst : In std_logic;
        Call_Op  : In std_logic;
        INT_Op   : In std_logic;

        -- For Load Use Case 
        Load_Op     : In std_logic;
        RS1         : IN std_logic_vector(4 downto 0);
        RS2         : IN std_logic_vector(4 downto 0);
        RegDest_MEM : IN std_logic_vector(4 downto 0);
        --buffers_En_Load : OUT std_logic;
        
        ----------------------------------------------------------------------------------------

        buffers_en            : Out std_logic;
        pc_en_swape           : Out std_logic; 
        Dest_Data_Selector    : Out std_logic;
        MEM_Write_MI          : Out std_logic;
        FlushRegisters        : Out std_logic;
        SP_Call               : Out std_logic
    );
end component Multiple_Instructions_Unit;

    --signal buffers_Load_En : std_logic;

----- Swape Signals

    signal Swape_WB, Swape_MEM, Swape_Exec : std_logic;
    signal PC_Swape_En, Dest_Data_Sel_Swape, Buffers_Swape_En : std_logic;
    
    signal Rs1_Exec_in_signal, Rs2_Exec_in_signal, Rs1_MEM_in_signal, Rs2_MEM_in_signal, Rs1_WB_in_signal, Rs2_WB_in_signal : std_logic_vector(4 downto 0);
     
    signal WB_RD                 : std_logic_vector(4 downto 0);
    signal WB_Data, ReadData2_WB : std_logic_vector(31 downto 0);

--------------------------------------------------------------------------------------
----- Call Signals

    signal Call_Control_MEM_in  : std_logic;
    signal PC_temp_MEM_Signal, PC_temp_Fetch, PC_temp_Fetch1, PC_temp_Fetch2 : std_logic_vector(31 downto 0);
    signal MEM_Write_Call       : std_logic; 
    signal MEM_Write_MI_Signal  : std_logic;

    signal Flush_Dec, Flush_Exec, Flush_MEM, Flush_WB,  Flush_Call, SP_Call_Signal: std_logic;

----- INT signals

    signal INT_Control_MEM_in : std_logic;
    signal from_adder_out_in  : std_logic_vector (31 downto 0);
--------------------------------------------------------------------------------------

------ RET Signals

    signal ret_operation_Exec :std_logic;
    signal ret_operation_MEM  :std_logic;
    signal Flush_RET          :std_logic;

---------------------------------------------------------------------------------------
---- Forwarding Signals

    signal Src1_Forwarding      : std_logic_vector(31 downto 0);
    signal Src2_Forwarding      : std_logic_vector(31 downto 0);
    
    signal Src1_Forwarding_MEM  : std_logic_vector(31 downto 0);
    signal Src2_Forwarding_MEM  : std_logic_vector(31 downto 0);

    signal Src1_Forwarding_WB   : std_logic_vector(31 downto 0);
    signal Src2_Forwarding_WB   : std_logic_vector(31 downto 0);

---------------------------------------------------------------------------------------

    signal Mem_Out_Signal, PC_inc_Signal : std_logic_vector(31 downto 0);
    signal Decode_Buffer_en, Exec_Buffer_en, MEM_Buffer_en, WB_Buffer_en, Decode_en : std_logic;

    --mem_write_Exec,mem_to_reg_control_Exec, hlt_control_Exec, sp_or_pc_control_Exec
    --call_control_Exec, branch_control_Exec, int_control_Exec, ret_operation_Exec

    signal Decode_Buffer_In, Decode_Buffer_Out : std_logic_vector(95 downto 0); 
    signal Exec_Buffer_In, Exec_Buffer_Out     : std_logic_vector(205 downto 0);
    signal MEM_Buffer_In, MEM_Buffer_Out       : std_logic_vector(284 downto 0); 
    signal WB_Buffer_In, WB_Buffer_Out         : std_logic_vector(244 downto 0);

    signal Sign_Ext_Out_signal                : std_logic_vector(31 downto 0);
    signal Rdst11_signal, Rdst22_signal       : std_logic_vector(4 downto 0);
    signal Rs1_Out_signal, Rs2_Out_signal     : std_logic_vector(4 downto 0);
    signal PC_temp_out_signal                 : std_logic_vector(31 downto 0);
    signal ReadData1_signal, ReadData2_signal : std_logic_vector(31 downto 0);        
    signal MEM_Write_signal                   : std_logic;
    signal MEM_to_Reg_signal                  : std_logic;
    signal Reg_Write_signal                   : std_logic;
    signal Reg_Dst_signal                     : std_logic;
    signal Sp_or_Pc_signal                    : std_logic;
    signal LD_Imm_signal                      : std_logic;
    signal Jmp_signal                         : std_logic;
    signal Jmp_Cond_signal                    : std_logic_vector(1 downto 0) ;
    signal Call_Control_signal                : std_logic;
    signal INT_Control_signal                 : std_logic;
    signal ALU_Control_signal                 : std_logic_vector(3 downto 0);
    signal ALU_Src_signal                     : std_logic;
    signal Buffers_En_signal                  : std_logic_vector(3 downto 0);
    signal HLT_Control_signal                 : std_logic;
    signal IN_or_WB_signal                    : std_logic;
    signal Out_Control_signal                 : std_logic;  
    signal Swape_signal                       : std_logic;
    signal Ret_Operation_signal               : std_logic; 
    
    Signal Control_Signals1                   : std_logic_vector(3 downto 0);
    Signal Control_Signals2                   : std_logic_vector(4 downto 0);
    Signal Control_Signals3                   : std_logic_vector(6 downto 0);
    Signal Control_Signals4                   : std_logic_vector(6 downto 0);

    Signal Control_Signals                    : std_logic_vector(22 downto 0);

    signal RegWrite_WB                        : std_logic;
    signal RD_WB                              : std_logic_vector(4 downto 0);

    -- Execution Stage signals

    signal Rdst_Exec_Signal, ALUsrc_Exec_signal  : std_logic;
    signal ALU_Control_Exec_signal               : std_logic_vector(3 downto 0);
    
    signal SignExt_Out_Exec_signal   :std_logic_vector(31 downto 0);  
    signal Rdst1_Exec_signal         :std_logic_vector(4 downto 0);  
    signal Rdst2_Exec_signal         :std_logic_vector(4 downto 0);  
    signal ReadData1_Exec_signal     :std_logic_vector(31 downto 0);  
    signal ReadData2_Exec_signal     :std_logic_vector(31 downto 0);  
    signal PC_temp_Exec_signal       :std_logic_vector(31 downto 0);  

    signal MEM_Write_Exec_in         : std_logic;
    signal MEM_to_Reg_Exec_in        : std_logic;
    signal Reg_Writ_Exec_in          : std_logic;
    signal Sp_or_Pc_Exec_in          : std_logic;
    signal LD_Imm_Exec_in            : std_logic;
    
    signal Jmp_Exec_in               : std_logic;          
    signal Jmp_Cond_Exec_in          : std_logic_vector (1 downto 0);

    signal Call_Control_Exec_in      : std_logic;
    signal INT_Control_Exec_in       : std_logic;

    signal HLT_Control_Exec_in       : std_logic;
    signal IN_or_WB_Exec_in          : std_logic;
    signal Out_Control_Exec_in       : std_logic;

    signal Exec_flags                : std_logic_vector(2 downto 0);
    signal ALUout_Exec_out           : std_logic_vector(31 downto 0);

    signal MEM_Write_Exec_out        : std_logic;
    signal MEM_to_Reg_Exec_out       : std_logic;  
    signal Reg_Writ_Exec_out         : std_logic;
    signal Sp_or_Pc_Exec_out         : std_logic;
    signal LD_Imm_Exec_out           : std_logic; 

    signal Call_Control_Exec_out     : std_logic;
    signal INT_Control_Exec_out      : std_logic;

    signal HLT_Control_Exec_out      : std_logic;
    signal IN_or_WB_Exec_out         : std_logic;
    signal Out_Control_Exec_out      : std_logic;

    signal SignExt_Exec_out          : std_logic_vector(31 downto 0);
    signal Dest_Exec_Out             : std_logic_vector(4 downto 0);
    signal branch_Control_Exec_Out   : std_logic; 

    -- Mem signals

    signal MEM_Buffer_Inputs1        : std_logic_vector(3 downto 0);
    signal MEM_Buffer_Inputs2        : std_logic_vector(38 downto 0);
    signal MEM_Buffer_Inputs3        : std_logic_vector(34 downto 0);
    signal MEM_Buffer_Inputs4        : std_logic_vector(63 downto 0);

    signal Memtoreg_MEM_in           : std_logic;                
    signal MemWrite_MEM_in           : std_logic;                
    signal SP_or_PC_MEM_in           : std_logic;                
    signal RegWrite_MEM_in           : std_logic;                
    signal Load_Imm_MEM_in           : std_logic;                
    signal IN_or_WB_MEM_in           : std_logic;                
    signal CCR_flag_MEM_in           : std_logic_vector( 2 downto 0);                
    signal ALUout_in_MEM_in          : std_logic_vector(31 downto 0);                
    signal ReadData1_MEM_in          : std_logic_vector(31 downto 0);                
    signal ReadData2_MEM_in          : std_logic_vector(31 downto 0);                
    signal SignExtendOut_MEM_in      : std_logic_vector(31 downto 0);                
    signal MuxOut_MEM_in             : std_logic_vector( 4 downto 0);                
    signal MemoryOut_MEM_in          : std_logic_vector(31 downto 0);    
    
    signal Memtoreg_MEM_out          : std_logic;                
    signal MemWrite_MEM_out          : std_logic;                
    signal SP_or_PC_MEM_out          : std_logic;                
    signal RegWrite_MEM_out          : std_logic;                
    signal Load_Imm_MEM_out          : std_logic;                
    signal IN_or_WB_MEM_out          : std_logic;                
    signal CCR_flag_MEM_out          : std_logic_vector( 2 downto 0);                
    signal ALUout_in_MEM_out         : std_logic_vector(31 downto 0);                
    signal ReadData1_MEM_out         : std_logic_vector(31 downto 0);                
    signal ReadData2_MEM_out         : std_logic_vector(31 downto 0);                
    signal SignExtendOut_MEM_out     : std_logic_vector(31 downto 0);                
    signal MuxOut_MEM_out            : std_logic_vector( 4 downto 0);                
    signal MemoryOut_MEM_out         : std_logic_vector(31 downto 0);

    -------------------------------
    signal mem_data_in_integ         : std_logic_vector(31 downto 0);
    signal from_CCR_MEM              : std_logic_vector(31 downto 0);

    -- WB Signals
    signal MemtoReg_WB               : std_logic;
    signal OUTControl_WB             : std_logic;
    signal RegWrite_in_WB            : std_logic;
    signal In_or_Wb_WB_in            : std_logic;
    signal MemoryOut_WB              : std_logic_vector(31 downto 0);
    signal ALUOut_WB                 : std_logic_vector(31 downto 0);
    signal ReadData1_WB              : std_logic_vector(31 downto 0);
    signal SignExtendOut_in_WB       : std_logic_vector(31 downto 0);
    signal MuxOut_in_WB              : std_logic_vector(4 downto 0);

    signal RegWrite_out_WB           : std_logic;  
    signal BigMuxOutput_WB           : std_logic_vector(31 downto 0);
    signal INPort_out_WB             : std_logic;
    signal SignExtendOut_out_WB      : std_logic_vector(31 downto 0);
    signal MuxOut_out_WB             : std_logic_vector(4 downto 0);

    signal Load_Imm_WB               : std_logic;
    signal WriteData_Reg_File        : std_logic_vector(31 downto 0);

    signal INport_Decode, INport_Exec, INport_MEM, INport_WB : std_logic_vector(31 downto 0);

    signal SP_or_PC_WB : std_logic;

    signal SP_or_PC_Fetch, Mem_Write_Fetch : std_logic;

    
    signal branch_flush_signal             : std_logic;

    -- For Load Use

    signal Load_Op_Signal, Load_Op_Exec, Load_Op_MEM, Load_Op_WB : std_logic;

    --------------------------------------------------------------------------------------------


begin
    -- Flush F/D and D/E buffers when PCsrc (branch control) be set to 1 
    branch_flush_signal <= '1' when branch_Control_Exec_Out = '1' else '0';
    
    Flush_RET <= '1' when ret_operation_MEM = '1'
        else     '0';
    -- SP_or_PC_Fetch <= SP_or_PC_MEM_out when MEM_Write_Exec_out = '1'
    --           else    Sp_or_Pc_Exec_out;

    -- Mem_Write_Fetch <= MemWrite_MEM_out when MEM_Write_Exec_out = '1'
    --            else    MEM_Write_Exec_out;


    MEM_Write_Call <= MemWrite_MEM_out and MEM_Write_MI_Signal;

    SP_or_PC_Fetch <= SP_or_PC_MEM_out and SP_Call_Signal;

    from_adder_out_in <= std_logic_vector(to_unsigned(to_integer(unsigned(SignExtendOut_MEM_in)) + 2, 32));

    PC_temp_Fetch1 <= PC_temp_MEM_Signal;

    PC_temp_Fetch2 <= CCR_flag_MEM_in & PC_temp_Fetch1(28 DOWNTO 0);

    PC_temp_Fetch  <= PC_temp_Fetch1 when Call_Control_MEM_in = '1'
            else      PC_temp_Fetch2 when INT_Control_MEM_in  = '1'
            else      (Others => '0');

 
    from_CCR_MEM <= "00000000000000000000000000000" & CCR_flag_MEM_out;

    Fetch_stage: Fetching PORT MAP ( 
        clk   => clk,
        rst   => rst,
        --sp_en => sp_en_in,  
         
        call_control       => Call_Control_MEM_in, --
        branch_control     => branch_Control_Exec_Out, --
        hlt_control        => HLT_Control_Exec_out, --
        int_control        => INT_Control_MEM_in, --
        ret_operation      => ret_operation_MEM,
        mem_write          => MEM_Write_Call, --
        sp_or_pc_control   => SP_or_PC_Fetch, --
        mem_to_reg_control => Memtoreg_MEM_out,--
 
        offset_address => SignExt_Exec_out,-- 
        from_alu_out   => ALUout_in_MEM_out, --
        from_adder_out => from_adder_out_in,
        from_reg1_out  => ReadData1_MEM_in,-- 
        from_reg2_out  => ReadData2_MEM_in,--
        from_pc_inc    => PC_temp_Fetch,
        from_ccr       => from_CCR_MEM,--  

        -- for swape
        PC_Swape_En    => PC_Swape_En,
        ------------------------------------------------------------------------------
        --mem_data_in    => mem_data_in_integ,

        mem_data_out  => Mem_Out_Signal,
        pc_inc        => PC_inc_Signal,       
        buffer_en_out => Decode_en

        );


    Decode_Buffer_en <= Decode_en and Buffers_Swape_En;

    Decode_Buffer_In <= IN_PORT & PC_inc_Signal & Mem_Out_Signal;
    
    Flush_Dec  <= (Flush_Call or Flush_RET) or branch_flush_signal;

    Decode_Buffer: Register_NB GENERIC MAP (96) PORT MAP (clk, rst, Decode_Buffer_en, Flush_Dec , Decode_Buffer_In, Decode_Buffer_Out);

    Decode_Stage0 : Decode_Stage PORT MAP (
        PC_temp      => Decode_Buffer_Out (63 downto 32),
        RD           => WB_RD,-- Come from WB stage        
        WriteData    => WB_Data,-- need an input
        RegWrite     => RegWrite_out_WB,-- come from WB stage  
        clk          => clk,
        rst          => rst,  
        Instruction  => Decode_Buffer_Out (31 downto 0),

        Sign_Ext_Out         => Sign_Ext_Out_signal,
        Rdst11               => Rdst11_signal,
        Rdst22               => Rdst22_signal, 
        Rs1_Out              => Rs1_Out_signal,  
        Rs2_Out              => Rs2_Out_signal,
        PC_temp_out          => PC_temp_out_signal,
        ReadData1            => ReadData1_signal,
        ReadData2            => ReadData2_signal,       
        MEM_Write            => MEM_Write_signal,
        MEM_to_Reg           => MEM_to_Reg_signal,
        Reg_Write            => Reg_Write_signal,
        Reg_Dst              => Reg_Dst_signal,
        Sp_or_Pc             => Sp_or_Pc_signal,
        LD_Imm               => LD_Imm_signal,
        Jmp                  => Jmp_signal,
        Jmp_Cond             => Jmp_Cond_signal,
        Call_Control         => Call_Control_signal,
        INT_Control          => INT_Control_signal,
        ALU_Control          => ALU_Control_signal,
        ALU_Src              => ALU_Src_signal,
        Buffers_En           => Buffers_En_signal ,
        HLT_Control          => HLT_Control_signal,
        IN_or_WB             => IN_or_WB_signal,
        Out_Control          => Out_Control_signal,
        swape                => Swape_signal,
        Ret_op               => Ret_Operation_signal,  
        Load_op              => Load_Op_Signal                           
    );
 
    INport_Decode <= Decode_Buffer_Out (95 downto 64);

    Control_Signals1 <= MEM_Write_signal & MEM_to_Reg_signal & Reg_Write_signal & Reg_Dst_signal;
    Control_Signals2 <= Sp_or_Pc_signal & LD_Imm_signal & Jmp_signal & Jmp_Cond_signal;
    Control_Signals3 <= Call_Control_signal & INT_Control_signal & ALU_Control_signal & ALU_Src_signal;
    Control_Signals4 <= Buffers_En_signal & HLT_Control_signal & IN_or_WB_signal & Out_Control_signal; 
    
    Control_Signals  <= Control_Signals4 & Control_Signals3 & Control_Signals2 & Control_Signals1;

    Exec_Buffer_In   <= Load_Op_Signal & Ret_Operation_signal & Swape_signal & INport_Decode & Rdst11_signal & Rdst22_signal & Sign_Ext_Out_signal & Rs1_Out_signal & Rs2_Out_signal & ReadData1_signal & ReadData2_signal & PC_temp_out_signal & Control_Signals;  
    
    Exec_Buffer_en <= Buffers_Swape_En ;

    Flush_Exec <= Flush_Call or Flush_RET or branch_flush_signal;
 
    Exec_Buffer  : Register_NB GENERIC MAP (206) PORT MAP (clk, rst, Exec_Buffer_en, Flush_Exec, Exec_Buffer_In, Exec_Buffer_Out);

    -- Execution Stage 

    Rdst_Exec_signal        <= Exec_Buffer_Out(0);
    ALUsrc_Exec_signal      <= Exec_Buffer_Out(9);
    ALU_Control_Exec_signal <= Exec_Buffer_Out(13 downto 10);

    SignExt_Out_Exec_signal <= Exec_Buffer_Out(160 downto 129);
    Rdst1_Exec_signal       <= Exec_Buffer_Out(170 downto 166);
    Rdst2_Exec_signal       <= Exec_Buffer_Out(165 downto 161);
    ReadData1_Exec_signal   <= Exec_Buffer_Out(118 downto 87);
    ReadData2_Exec_signal   <= Exec_Buffer_Out(86 downto 55);
    PC_temp_Exec_signal     <= Exec_Buffer_Out(54 downto 23);

    MEM_Write_Exec_in       <= Exec_Buffer_Out(3); 
    MEM_to_Reg_Exec_in      <= Exec_Buffer_Out(2); 
    Reg_Writ_Exec_in        <= Exec_Buffer_Out(1); 
    Sp_or_Pc_Exec_in        <= Exec_Buffer_Out(8); 
    LD_Imm_Exec_in          <= Exec_Buffer_Out(7);
    
    Jmp_Exec_in             <= Exec_Buffer_Out(6);     
    Jmp_Cond_Exec_in        <= Exec_Buffer_Out(5 downto 4);

    Call_Control_Exec_in    <= Exec_Buffer_Out(15);
    INT_Control_Exec_in     <= Exec_Buffer_Out(14);

    HLT_Control_Exec_in     <= Exec_Buffer_Out(18);
    IN_or_WB_Exec_in        <= Exec_Buffer_Out(17);
    Out_Control_Exec_in     <= Exec_Buffer_Out(16);

    INport_Exec <= Exec_Buffer_Out (202 downto 171);

-- For Swape
    Rs1_Exec_in_signal         <= Exec_Buffer_Out(128 downto 124);  
    Rs2_Exec_in_signal         <= Exec_Buffer_Out(123 downto 119); 
    Swape_Exec                 <= Exec_Buffer_Out(203);
----------------------------------------------------------------------------
-- Ret Operation

    ret_operation_Exec      <= Exec_Buffer_Out(204);

-----------------------------------------------------------------------------
-- For Load Use 

    Load_Op_Exec <= Exec_Buffer_Out(205);

-----------------------------------------------------------------------------

    --Execution Stage Mapping

    -- Exec_Stage : ExecutionStage PORT MAP (

    -- -- inputs

    --     clk                  => clk, 
    --     rst                  => rst, 
    --     alu_source           => ALUsrc_Exec_signal, 
    --     opcode               => ALU_Control_Exec_signal, 
    --     register1_decoded    => ReadData1_Exec_signal, 
    --     register2_decoded    => ReadData2_Exec_signal, 
    --     immediate_value      => SignExt_Out_Exec_signal, 
    --     --The value decoded from Rs, Rd, and the immediate value coming from sign extend
         
    --     Dest1                => Rdst1_Exec_signal,  --15:11 
    --     Dest2                => Rdst2_Exec_signal,  --20:16
        
    --     MEM_Write            => MEM_Write_Exec_in ,
    --     MEM_to_Reg           => MEM_to_Reg_Exec_in,
    --     Reg_Write            => Reg_Writ_Exec_in,
    --     Reg_Dst              => Rdst_Exec_signal, 
    --     Sp_or_Pc             => Sp_or_Pc_Exec_in,
    --     LD_Imm               => LD_Imm_Exec_in,
        
    --     Jmp                  => Jmp_Exec_in,
    --     Jmp_Cond             => Jmp_Cond_Exec_in,
        
    --     Call_Control         => Call_Control_Exec_in,
    --     INT_Control          => INT_Control_Exec_in,
    --     --ALU_Control            : IN std_logic_vector(3 downto 0);
    --     --Buffers_En             : IN std_logic_vector(3 downto 0);
        
    --     HLT_Control          => HLT_Control_Exec_in,
    --     IN_or_WB             => IN_or_WB_Exec_in,
    --     Out_Control          => Out_Control_Exec_in,

    --     --outputs 

    --     zero_flag             => Exec_flags(0), 
    --     negative_flag         => Exec_flags(1), 
    --     carry_flag            => Exec_flags(2),

    --     alu_result            => ALUout_Exec_out,
        
    --     MEM_Write_Out         => MEM_Write_Exec_out,  
    --     MEM_to_Reg_Out        => MEM_to_Reg_Exec_out, 
    --     Reg_Write_Out         => Reg_Writ_Exec_out,
    --     Sp_or_Pc_Out          => Sp_or_Pc_Exec_out,   
    --     LD_Imm_Out            => LD_Imm_Exec_out,    
    --     --Jmp_Out                   : Out std_logic;
    --     --Jmp_Cond_Out              : Out std_logic_vector(1 downto 0) ;
        
    --     Call_Control_Out      => Call_Control_Exec_out,  
    --     INT_Control_Out       => INT_Control_Exec_out,        
        
    --     --Buffers_En_Out       
        
    --     HLT_Control_Out       => HLT_Control_Exec_out,  
    --     Out_Control_Out       => Out_Control_Exec_out, 
        
        
    --     IN_or_WB_Out          => IN_or_WB_Exec_out,   

        
    --     Sign_Ext_Exec_out     => SignExt_Exec_out,
    --     Dest                  => Dest_Exec_Out,

    --     branch_control        => branch_Control_Exec_Out
    -- );

    -- --! Execution stage with forwarding unit
    Exec_Stage : ExecutionStage PORT MAP (

    -- inputs

        clk                  => clk, 
        rst                  => rst, 
        alu_source           => ALUsrc_Exec_signal, 
        opcode               => ALU_Control_Exec_signal, 
        register1_decoded    => ReadData1_Exec_signal, 
        register2_decoded    => ReadData2_Exec_signal, 
        immediate_value      => SignExt_Out_Exec_signal,
        --The value decoded from Rs, Rd, and the immediate value coming from sign extend
         
        input_port => INport_WB,
        ExMem_WB => RegWrite_MEM_in,
        MemWB_WB => RegWrite_in_WB,
        IdEx_Rs => Rs1_Exec_in_signal, 
        IdEx_Rd => Rs2_Exec_in_signal, 
        ExMem_Rd => MuxOut_MEM_in, 
        MemWB_Rd => MuxOut_out_WB,
        ExMem_Val => ALUout_in_MEM_in,
        MemWB_Val => BigMuxOutput_WB,
        


        Dest1                => Rdst1_Exec_signal,  --15:11 
        Dest2                => Rdst2_Exec_signal,  --20:16
        
        MEM_Write            => MEM_Write_Exec_in ,
        MEM_to_Reg           => MEM_to_Reg_Exec_in,
        Reg_Write            => Reg_Writ_Exec_in,
        Reg_Dst              => Rdst_Exec_signal,
        Sp_or_Pc             => Sp_or_Pc_Exec_in,
        LD_Imm               => LD_Imm_Exec_in,
        
        Jmp                  => Jmp_Exec_in,
        Jmp_Cond             => Jmp_Cond_Exec_in,
        
        Call_Control         => Call_Control_Exec_in,
        INT_Control          => INT_Control_Exec_in,
        --ALU_Control            : IN std_logic_vector(3 downto 0);
        --Buffers_En             : IN std_logic_vector(3 downto 0);
        
        HLT_Control          => HLT_Control_Exec_in,
        IN_or_WB             => IN_or_WB_Exec_in,
        Out_Control          => Out_Control_Exec_in,

        --outputs 

        zero_flag             => Exec_flags(0), 
        negative_flag         => Exec_flags(1), 
        carry_flag            => Exec_flags(2),

        alu_result            => ALUout_Exec_out,
        
        MEM_Write_Out         => MEM_Write_Exec_out,  
        MEM_to_Reg_Out        => MEM_to_Reg_Exec_out, 
        Reg_Write_Out         => Reg_Writ_Exec_out,
        Sp_or_Pc_Out          => Sp_or_Pc_Exec_out,   
        LD_Imm_Out            => LD_Imm_Exec_out,    
        --Jmp_Out                   : Out std_logic;
        --Jmp_Cond_Out              : Out std_logic_vector(1 downto 0) ;
        
        Call_Control_Out      => Call_Control_Exec_out,  
        INT_Control_Out       => INT_Control_Exec_out,        
        
        --Buffers_En_Out       
        
        HLT_Control_Out       => HLT_Control_Exec_out,  
        Out_Control_Out       => Out_Control_Exec_out, 
        
        
        IN_or_WB_Out          => IN_or_WB_Exec_out,   

        
        Sign_Ext_Exec_out     => SignExt_Exec_out,
        Dest                  => Dest_Exec_Out,

        branch_control        => branch_Control_Exec_Out,

        ALU_In1               => Src1_Forwarding, 
        ALU_In2               => Src2_Forwarding,

        In_or_WB_Forwarding   => In_or_Wb_WB_in,
        Inport_WB_Forwarding  => INport_WB,
        IN_or_WB_MEM          => IN_or_WB_MEM_in,
        INport_MEM_Data       => INport_MEM,

        Swape_WB_Forwarding   => Swape_WB, 
        Swap_Dst_Forwarding   => Rs1_WB_in_signal,
        Swap_Data_Forwarding  => Src2_Forwarding_WB,

        Swape_MEM_Forwarding     => Swape_MEM,
        Swap_Dst_MEM_Forwarding  => Rs1_MEM_in_signal, 
        Swap_Data_MEM_Forwarding => Src2_Forwarding_MEM,

        LoadImm_MEM   => Load_Imm_MEM_in, 
        LoadImm_WB    => Load_Imm_WB,           
        LoadImm_MEM_Data => SignExtendOut_MEM_in, 
        LoadImm_WB_Data  => SignExtendOut_in_WB  
    );

-- Memory STAGE 

    MEM_Buffer_Inputs1 <= LD_Imm_Exec_out & MEM_to_Reg_Exec_out & MEM_Write_Exec_out & Reg_Writ_Exec_out;
    MEM_Buffer_Inputs2 <= SignExt_Exec_out & Dest_Exec_Out & Sp_or_Pc_Exec_out & IN_or_WB_Exec_out;
    MEM_Buffer_Inputs3 <= Exec_flags & ALUout_Exec_out;
    MEM_Buffer_Inputs4 <= ReadData2_Exec_signal & ReadData1_Exec_signal;

    MEM_Buffer_In <= Load_Op_Exec & Src1_Forwarding & Src2_Forwarding & ret_operation_Exec & INT_Control_Exec_out & PC_temp_Exec_signal & Call_Control_Exec_out & Swape_Exec & Rs1_Exec_in_signal & Rs2_Exec_in_signal & INport_Exec & MEM_Buffer_Inputs4 & MEM_Buffer_Inputs3 & MEM_Buffer_Inputs2 & MEM_Buffer_Inputs1;

    MEM_Buffer_en <= Buffers_Swape_En;

    Flush_MEM <= Flush_Call or Flush_RET; 

    MEM_Buffer   : Register_NB GENERIC MAP (285) PORT MAP (clk, rst, MEM_Buffer_en, Flush_MEM, MEM_Buffer_In, MEM_Buffer_Out);
    
-- Memory Mapping

    Memtoreg_MEM_in      <= MEM_Buffer_Out(2);
    MemWrite_MEM_in      <= MEM_Buffer_Out(1);
    SP_or_PC_MEM_in      <= MEM_Buffer_Out(5);
    RegWrite_MEM_in      <= MEM_Buffer_Out(0);
    Load_Imm_MEM_in      <= MEM_Buffer_Out(3);
    IN_or_WB_MEM_in      <= MEM_Buffer_Out(4);       
    CCR_flag_MEM_in      <= MEM_Buffer_Out(77 downto 75);             
    ALUout_in_MEM_in     <= MEM_Buffer_Out(74 downto 43);       
    ReadData1_MEM_in     <= MEM_Buffer_Out(109 downto 78);
    ReadData2_MEM_in     <= MEM_Buffer_Out(141 downto 110);  
    SignExtendOut_MEM_in <= MEM_Buffer_Out(42 downto 11); 
    MuxOut_MEM_in        <= MEM_Buffer_Out(10 downto 6);        
    MemoryOut_MEM_in     <= Mem_Out_Signal;   

    INport_MEM  <= MEM_Buffer_Out(173 downto 142);

-- for swape

    Rs1_MEM_in_signal <= MEM_Buffer_Out(183 downto 179);
    Rs2_MEM_in_signal <= MEM_Buffer_Out(178 downto 174);
    Swape_MEM         <= MEM_Buffer_Out(184);
---------------------------------------------------------------------------------------------
-- for Call

    Call_Control_MEM_in <= MEM_Buffer_Out(185);
    PC_temp_MEM_Signal  <= MEM_Buffer_Out(217 downto 186);
----------------------------------------------------------------------------------------------
-- For INT 

    INT_Control_MEM_in  <= MEM_Buffer_Out(218);
----------------------------------------------------------------------------------------------
-- For RET

    ret_operation_MEM   <= MEM_Buffer_Out(219);

----------------------------------------------------------------------------------------------
-- For Forwarding

    Src1_Forwarding_MEM  <= MEM_Buffer_Out(283 downto 252);  
    Src2_Forwarding_MEM  <= MEM_Buffer_Out(251 downto 220); 

----------------------------------------------------------------------------------------------
-- For Load USE 


    Load_Op_MEM <= MEM_Buffer_Out(284);

----------------------------------------------------------------------------------------------

Memory_Stage : MemStage PORT MAP (

        MemtoReg_in      => Memtoreg_MEM_in,  
	    MemWrite_in      => MemWrite_MEM_in,  
	    SP               => SP_or_PC_MEM_in,
	    RegWrite_in      => RegWrite_MEM_in,  
	    LoadImm_in       => Load_Imm_MEM_in,
	    INPort_in        => IN_or_WB_MEM_in,
	    CCR              => CCR_flag_MEM_in, 
	    ALUout_in        => ALUout_in_MEM_in,
	    ReadData1_in     => ReadData1_MEM_in,
	    ReadData2_in     => ReadData2_MEM_in,
	    SignExtendOut_in => SignExtendOut_MEM_in,
	    MuxOut_in        => MuxOut_MEM_in, 
	    MemoryOut_in     => MemoryOut_MEM_in,
    
        MemtoReg_out      => Memtoreg_MEM_out,
        MemWrite_out      => MemWrite_MEM_out,
        SP_out            => SP_or_PC_MEM_out,
        RegWrite_out      => RegWrite_MEM_out,
        LoadImm_out       => Load_Imm_MEM_out,
        INPort_out        => IN_or_WB_MEM_out,
        CCR_out           => CCR_flag_MEM_out,
        ALUout_out        => ALUout_in_MEM_out,
        ReadData1_out     => ReadData1_MEM_out,
        ReadData2_out     => ReadData2_MEM_out,
        SignExtendOut_out => SignExtendOut_MEM_out,
        MuxOut_out        => MuxOut_MEM_out,
        MemoryOut_out     => MemoryOut_MEM_out  
    );

    --WB Stage

    WB_Buffer_In <= Src1_Forwarding_MEM & Src2_Forwarding_MEM & SP_or_PC_MEM_out & ReadData2_MEM_out & Swape_MEM & Rs1_MEM_in_signal & Rs2_MEM_in_signal & INport_MEM & Load_Imm_MEM_out & IN_or_WB_MEM_out & MuxOut_MEM_out & ALUout_in_MEM_out & MemoryOut_MEM_out & SignExtendOut_MEM_out & Memtoreg_MEM_out & RegWrite_MEM_out;

    WB_Buffer_en <= Buffers_Swape_En;

    Flush_WB <= '0';

    WB_Buffer    : Register_NB GENERIC MAP (245) PORT MAP (clk, rst, WB_Buffer_en, Flush_WB, WB_Buffer_In, WB_Buffer_Out);


    --WB Mapping

    MemtoReg_WB         <= WB_Buffer_Out(1);
    OUTControl_WB       <= Out_Control_Exec_in;
    RegWrite_in_WB      <= WB_Buffer_Out(0);
    In_or_Wb_WB_in      <= WB_Buffer_Out(103);
    MemoryOut_WB        <= WB_Buffer_Out( 65 downto 34);
    ALUOut_WB           <= WB_Buffer_Out( 97 downto 66);
    ReadData1_WB        <= ALUout_Exec_out;
    SignExtendOut_in_WB <= WB_Buffer_Out( 33 downto  2);
    MuxOut_in_WB        <= WB_Buffer_Out(102 downto 98);

    Load_Imm_WB         <= WB_Buffer_Out(104);

    INport_WB           <= WB_Buffer_Out (136 downto 105);

    -- For swape
    Rs1_WB_in_signal <= WB_Buffer_Out (146 downto 142) ; 
    Rs2_WB_in_signal <= WB_Buffer_Out (141 downto 137) ;
    Swape_WB         <= WB_Buffer_Out (147);
    ReadData2_WB     <= WB_Buffer_Out (179 downto 148);
    ------------------------------------------------------------
    -- For Forwarding 

    Src1_Forwarding_WB  <= WB_Buffer_Out (244 downto 213); 
    Src2_Forwarding_WB  <= WB_Buffer_Out (212 downto 181);

    ------------------------------------------------------------

    SP_or_PC_WB      <= WB_Buffer_Out (180);

    WB_Stage : WbStage PORT MAP (

        MemtoReg          => MemtoReg_WB,
        OUTControl        => OUTControl_WB,
        RegWrite_in       => RegWrite_in_WB,
        INPort_in         => In_or_Wb_WB_in,
        MemoryOut         => MemoryOut_WB,
        ALUOut            => ALUOut_WB,
        ReadData1         => ReadData1_WB,
        SignExtendOut_in  => SignExtendOut_in_WB,
        MuxOut_in         => MuxOut_in_WB,
                
        
        OutPort           => OUT_PORT,--
        RegWrite_out      => RegWrite_out_WB,--
        BigMuxOutput      => BigMuxOutput_WB, 
        INPort_out        => INPort_out_WB,
        SignExtendOut_out => SignExtendOut_out_WB,
        MuxOut_out        => MuxOut_out_WB  --           
    );

    MI_Unit : Multiple_Instructions_Unit PORT MAP (
        Swap_Op   => Swape_WB,
        clk       => clk, 
        rst       => rst,
        Call_Op   => Call_Control_MEM_in,
        INT_Op    => INT_Control_MEM_in,

        -- For Load Use Case 
        Load_Op     => Load_Op_MEM,
        RS1         => Rs1_Exec_in_signal,
        RS2         => Rs2_Exec_in_signal,
        RegDest_MEM => MuxOut_MEM_in,
        
        --buffers_En_Load => buffers_Load_En,
        
        ----------------------------------------------------------------------------------------

        buffers_en            => Buffers_Swape_En,
        pc_en_swape           => PC_Swape_En,  
        Dest_Data_Selector    => Dest_Data_Sel_Swape,
        MEM_Write_MI          => MEM_Write_MI_Signal,
        FlushRegisters        => Flush_Call,
        SP_Call               => SP_Call_signal 
    );


    WriteData_Reg_File <= SignExtendOut_out_WB when Load_Imm_WB ='1'
    else INport_WB when INPort_out_WB = '1'
    else BigMuxOutput_WB;

    --WB_Data <= WriteData_Reg_File;   
    --WB_RD   <= MuxOut_out_WB; 

    WB_Data <= WriteData_Reg_File when Dest_Data_Sel_Swape = '0' or SP_or_PC_WB = '1' 
    else    Src2_Forwarding_WB;

    WB_RD   <= MuxOut_out_WB when Dest_Data_Sel_Swape = '0'  or SP_or_PC_WB = '1'
    else    Rs1_WB_in_signal;


end architecture rtl; 