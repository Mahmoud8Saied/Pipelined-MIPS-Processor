library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity Multiple_Instructions_Unit is
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
end entity Multiple_Instructions_Unit;


architecture rtl of Multiple_Instructions_Unit is
    
    signal CurrentSwape_state, CurrentCall_state, state1_Swape, state2_Swape, NextSwape_state, NextCall_state, CurrentLoad_state, NextLoad_state : std_logic_vector(1 downto 0); 

begin

    state1_Swape <= "00";
    state2_Swape <= "01";

   -- States logic

   -- Swape

  proc_name: process(CurrentSwape_state, Swap_Op)
  begin
    case(CurrentSwape_state) is
    
        when "00" =>

            if Swap_Op = '1' then

                buffers_en         <= '0';
                pc_en_swape        <= '0';
                Dest_Data_Selector <= '0';

                NextSwape_state    <= state2_Swape;
            
            else
                buffers_en         <= '1'; 
                pc_en_swape        <= '1';
                Dest_Data_Selector <= '0';
    
                NextSwape_state    <= state1_Swape;
                
            end if ;

        when "01" => 
                    Dest_Data_Selector <= '1';
                    pc_en_swape        <= '1';
                    buffers_en         <= '1'; 
    
                    NextSwape_state    <= state1_Swape;

        when Others =>

                NextSwape_state    <= state1_Swape;
        
    
    end case ;
      
  end process proc_name;

  -- Call 

  proc_name2: process(CurrentCall_state, Call_Op, INT_Op)
  begin
    case(CurrentCall_state) is
    
        when "00" =>

            if Call_Op = '1' or INT_Op = '1' then

                buffers_en         <= '0';
                pc_en_swape        <= '0';
                MEM_Write_MI       <= '1';
                FlushRegisters     <= '0';
                SP_Call            <= '1';

                NextCall_state    <= state2_Swape;
            
            else
                buffers_en         <= '1';
                pc_en_swape        <= '1';
                MEM_Write_MI       <= '1';
                FlushRegisters     <= '0';
                SP_Call            <= '1';
    
                NextCall_state    <= state1_Swape;
                
            end if ;

        when "01" => 
                    buffers_en         <= '1';
                    pc_en_swape        <= '1';
                    MEM_Write_MI       <= '0';
                    FlushRegisters     <= '1';
                    SP_Call            <= '0';

                NextCall_state    <= state1_Swape;

        when Others =>

                NextCall_state    <= state1_Swape;
        
    end case ;
      
  end process proc_name2;

  --Load

--   proc_name4: process(CurrentLoad_state, Load_Op)
--   begin
--     case(CurrentLoad_state) is
    
--         when "00" =>

--             if Load_OP = '1' then

--                 if (RS1 = RegDest_MEM) or (RS2 = RegDest_MEM) then
--                     buffers_En_Load    <= '0';
--                     pc_en_swape        <= '0';
                    
--                     NextLoad_state    <= state2_Swape;
--                 end if ;

            
--             else
--                 buffers_En_Load         <= '1';
--                 pc_en_swape        <= '1';
--                 Dest_Data_Selector <= '0';
    
--                 NextLoad_state    <= state1_Swape;
                
--             end if ;

--         when "01" => 
--                     pc_en_swape        <= '1';
--                     buffers_En_Load         <= '1'; 
    
--                 NextLoad_state    <= state1_Swape;

--         when Others =>

--                 NextLoad_state    <= state1_Swape;
        
--     end case ;
      
--   end process proc_name4;

  --Next State Logic

  -- Swape

 proc_name1: process(clk, rst)
 begin
     if rst = '1' then

        CurrentSwape_state <= state1_Swape;
         
     elsif rising_edge(clk) then
         
        CurrentSwape_state <= NextSwape_state;
      
     end if;
 end process proc_name1;

  -- Call

  proc_name3: process(clk, rst)
 begin
     if rst = '1' then

        CurrentCall_state <= state1_Swape;
         
     elsif rising_edge(clk) then
         
        CurrentCall_state <= NextCall_state;
      
     end if;
 end process proc_name3;

 --Load 

-- proc_name5: process(clk, rst)
--  begin
--      if rst = '1' then

--         CurrentLoad_state <= state1_Swape;
         
--      elsif rising_edge(clk) then
         
--         CurrentLoad_state <= NextLoad_state;
      
--      end if;
--  end process proc_name5;
    
end architecture rtl;