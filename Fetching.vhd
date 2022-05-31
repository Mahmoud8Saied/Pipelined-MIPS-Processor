library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Fetching is
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
        from_ccr: in std_logic_vector(31 downto 0);  -- ! IT CAN BE 3 bit only

        -- for swape: 

        PC_Swape_En : in std_logic;

        ----------------------------------------------------------------------

        --mem_data_in: in std_logic_vector(31 downto 0);

        -- to be connected to the first buffer
        mem_data_out: out std_logic_vector(31 downto 0);
        pc_inc: out std_logic_vector(31 downto 0);
        buffer_en_out: out std_logic
    
    );
end entity Fetching;

architecture FetchingArch of Fetching is
    component ProgramCounter is
        port (
            clk, rst, en : IN std_logic;
        
            call_control: in std_logic;
            branch_control: in std_logic;
            --hlt_control: in std_logic;
            int_control: in std_logic;
            ret_operation: in std_logic;
    
    
            from_mem_out: in std_logic_vector(31 downto 0);
            offset_address: in std_logic_vector(31 downto 0);
    
            -- pc_in       : IN  std_logic_vector(31 downto 0);
            pc_out      : OUT std_logic_vector(31 downto 0);
            pc_inc      : out std_logic_vector(31 downto 0)
    
        );
    end component ProgramCounter;

    component AddressSelector is
        port (
    
            clk: in std_logic;
            sp_or_pc_control: in std_logic;
            struct_hazard_control: in std_logic;
            int_control: in std_logic;
    
            from_alu_out: in std_logic_vector(31 downto 0);
            from_adder_out: in std_logic_vector(31 downto 0);
            from_pc_out: in std_logic_vector(31 downto 0);
            from_sp_out: in std_logic_vector(31 downto 0);
    
            mem_address: out std_logic_vector(31 downto 0)
        );
    end component AddressSelector;

    component Memory is
        PORT(
            clk : in std_logic;
            mem_write  : in std_logic;
    
            mem_address : in  std_logic_vector(31 downto 0);
            mem_datain  : in  std_logic_vector(31 downto 0);
    
            mem_dataout : out std_logic_vector(31 downto 0)
        );
    
    end component Memory;

    component StackPointer is
        port (
            clk, rst, en : IN std_logic;
    
            mem_write_control: IN std_logic;
            sp_or_pc_control: in std_logic;
    
            -- sp_in       : IN  std_logic_vector(31 downto 0);
            sp_out      : OUT std_logic_vector(31 downto 0)
    
        );
    end component StackPointer;

    component DataSelector is
        port (
            mem_write_control: in std_logic;
            sp_or_pc_control: in std_logic;
            call_control: in std_logic;
            int_control: in std_logic;
    
            from_reg1_out: in std_logic_vector(31 downto 0);
            from_reg2_out: in std_logic_vector(31 downto 0);
            from_pc_inc: in std_logic_vector(31 downto 0);
            from_ccr: in std_logic_vector(31 downto 0);
    
            mem_data: out std_logic_vector(31 downto 0)
        );
    end component DataSelector;
    

    component Hazard_Unit_Fetch is
        port (
            MemWrite, MEM_to_Reg, hlt_control_H, SP_or_PC : In std_logic;
            Buffer_En, PC_En, Mem_Add_Sel, SP_En          : Out std_logic
        );
    end component Hazard_Unit_Fetch;

    signal mem_out_sig: std_logic_vector(31 downto 0);
    signal pc_out_sig: std_logic_vector(31 downto 0);
    signal pc_inc_sig: std_logic_vector(31 downto 0);
    signal sp_out_sig: std_logic_vector(31 downto 0);
    signal mem_address_sig: std_logic_vector(31 downto 0);
    signal mem_data_in_sig: std_logic_vector(31 downto 0);
    signal haz_control_sig: std_logic;
    signal hazard_control_pc_en_sig: std_logic;

    signal PC_en_Final : std_logic;
    signal SP_En_Fetch : std_logic;

begin


    hazard_detector_label: Hazard_Unit_Fetch port map(
        MemWrite => mem_write,
        MEM_to_Reg => mem_to_reg_control, 
        hlt_control_H => hlt_Control,
        SP_or_PC      => sp_or_pc_control,        

        Buffer_En => buffer_en_out,
        PC_En => hazard_control_pc_en_sig,
        Mem_Add_Sel => haz_control_sig, 
        SP_En       => SP_En_Fetch 

    );

    PC_en_Final <= hazard_control_pc_en_sig and PC_Swape_En;

    pc_label: ProgramCounter port map(
        clk => clk,
        rst => rst,
        en  => PC_en_Final,

        call_control => call_control,
        branch_control => branch_control, 
        --hlt_control => hlt_control,
        int_control => int_control,
        ret_operation => ret_operation,

        from_mem_out => mem_out_sig,
        offset_address => offset_address,

        pc_out => pc_out_sig,
        pc_inc => pc_inc_sig
    );

    memory_label: Memory port map(
        clk => clk,
        
        mem_write => mem_write,

        mem_address => mem_address_sig,
        mem_datain => mem_data_in_sig,

        mem_dataout => mem_out_sig
    );

    address_selector_label: AddressSelector port map(
        clk => clk,
        sp_or_pc_control => sp_or_pc_control,
        struct_hazard_control => haz_control_sig,
        int_control => int_control,
    
        from_alu_out => from_alu_out,
        from_adder_out => from_adder_out, 
        from_pc_out => pc_out_sig,
        from_sp_out => sp_out_sig,
    
        mem_address => mem_address_sig
    );

    sp_label: StackPointer port map(
        clk => clk,
        rst => rst,
        en => SP_En_Fetch,
    
        mem_write_control => mem_write,
        sp_or_pc_control  => sp_or_pc_control,
    
        sp_out => sp_out_sig

    );

    data_selector_label: DataSelector port map(
        
        mem_write_control => mem_write,
        sp_or_pc_control => sp_or_pc_control,
        call_control => call_control,
        int_control => int_control,
    
        from_reg1_out => from_reg1_out,
        from_reg2_out => from_reg2_out,
        from_pc_inc => from_pc_inc,
        from_ccr => from_ccr,
    
        mem_data => mem_data_in_sig

    );

    -- to be connected to the first buffer
    pc_inc <= pc_inc_sig;
    mem_data_out <= mem_out_sig;
    
end architecture FetchingArch;