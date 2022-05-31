LIBRARY ieee;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_1164.ALL;

ENTITY ForwardingUnit IS
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
END ENTITY ForwardingUnit;

ARCHITECTURE ForwardingUnit1 OF ForwardingUnit IS
BEGIN
    PROCESS (IdEx_Rs, IdEx_Rd, ExMem_Rd, MemWB_Rd, ExMem_WB, MemWB_WB)
    BEGIN
        R1_signal <= "0000";
        R2_signal <= "0000";
        IF (MemWB_WB = '1') THEN --If the instruction before the last writes to memory
            IF (IdEx_Rs = MemWB_Rd) THEN --If the first input for ALU should be forwarded
                if IN_or_WB = '1'  then
                    R1_signal <= "0011";
                
                elsif LoadImm_WB = '1' then
                    R1_signal <= "0110";

                else 
                    R1_signal <= "0010";

                end if ;
            END IF;
            IF (IdEx_Rd = MemWB_Rd) THEN --If the second input for the ALU should be forwarded
                if IN_or_WB = '1'  then
                    R2_signal <= "0011";
                
                elsif LoadImm_WB = '1' then
                    R2_signal <= "0110";

                else 
                    R2_signal <= "0010";

                end if ;
            END IF;

            if (IdEx_Rs = Swap_Dst_Forwarding) then
                if Swape_WB_Forwarding = '1' then
                    R1_signal <= "0111";
                end if ;
            end if ;

            if (IdEx_Rd = Swap_Dst_Forwarding) then

                if Swape_WB_Forwarding = '1' then
                    R2_signal <= "0111";
                end if ;
                
            end if ;

        END IF;

        IF (ExMem_WB = '1') THEN --If the previous operation writes to the memory 
            IF (IdEx_Rs = ExMem_Rd) THEN --If the first input for ALU should be forwarded
                if IN_or_WB_MEM = '1'  then
                    R1_signal <= "0101";
                
                elsif LoadImm_MEM = '1' then
                    R1_signal <= "1001";

                else 
                    R1_signal <= "0001";

                end if ;
            END IF;
            IF (IdEx_Rd = ExMem_Rd) THEN --If the second input for the ALU should be forwarded
                if IN_or_WB_MEM = '1'  then
                    R2_signal <= "0101";
                
                elsif LoadImm_MEM = '1' then
                    R2_signal <= "1001";

                else 
                    R2_signal <= "0001";

                end if ;
            END IF;

            if (IdEx_Rs = Swap_Dst_MEM_Forwarding) then
                if Swape_MEM_Forwarding = '1' then
                    R1_signal <= "0100";
                end if ;
            end if ;

            if (IdEx_Rd = Swap_Dst_MEM_Forwarding) then

                if Swape_MEM_Forwarding = '1' then
                    R2_signal <= "0100";
                end if ;
                
            end if ;
            
        END IF;
    END PROCESS; -- 
END ForwardingUnit1;
