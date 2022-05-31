LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity Memory is
	PORT(
		clk : in std_logic;
		mem_write  : in std_logic;

		mem_address : in  std_logic_vector(31 downto 0);
		mem_datain  : in  std_logic_vector(31 downto 0);

		mem_dataout : out std_logic_vector(31 downto 0)
    );

end entity Memory;

architecture MemoryArch OF Memory is

	type MemoryType is ARRAY(0 TO 2**20-1) OF std_logic_vector(31 downto 0);
	signal mem_temp: MemoryType;
	
	begin
		process(clk) is
			begin
				if rising_edge(clk) then  
					if mem_write = '1' then
                        mem_temp(to_integer(unsigned(mem_address))) <= mem_datain;
					end if;
				end if;
		end process;
		mem_dataout <= mem_temp(to_integer(unsigned(mem_address)));
end MemoryArch;
