
--Write Back Integration Stage:
library ieee;
use ieee.std_logic_1164.all;

entity WbStage is
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
		--fe a5er port sheeel el ";"
		);
end entity;

architecture top of WbStage is   

	component Mux2x1 IS
	PORT ( 
		in0,in1: IN  std_logic_vector(31 downto 0); 
		sel    : IN  std_logic;
		out0   : OUT std_logic_vector(31 downto 0)
	);
	end component;
	
	--signal  OutPort    :std_logic;	
	--signal  BigMuxOutput :std_logic;

	signal Z : std_logic_vector(31 downto 0);
	
	begin

	Z <= (Others => '0');
		
	Mux2x1_0 :Mux2x1 port map (Z,ReadData1,OUTControl,OutPort);
	Mux2x1_1 :Mux2x1 port map (ALUOut,MemoryOut,MemtoReg,BigMuxOutput);

	           
	RegWrite_out       <= RegWrite_in;    
	INPort_out         <= INPort_in;
	SignExtendOut_out  <= SignExtendOut_in;
	MuxOut_out         <= MuxOut_in;
	
end architecture;