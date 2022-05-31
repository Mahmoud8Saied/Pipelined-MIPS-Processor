
--Memory Integration Stage
library ieee;
use ieee.std_logic_1164.all;

entity MemStage is
	PORT(
	--ZF,NF,CF : IN  std_logic
		
	--Numbers between brackets are the signal order in the design,
	-- but with repect to the order in the report document

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
end entity;

architecture top of MemStage is  
	--signal  selCCR      :std_logic; -- ~JmpCond
	begin

	MemtoReg_out      <= MemtoReg_in;   
	MemWrite_out      <= MemWrite_in; 
	SP_out            <= SP;  
	RegWrite_out      <= RegWrite_in; 
	LoadImm_out       <= LoadImm_in;  
	INPort_out        <= INPort_in;
	CCR_out           <= CCR;
	ALUout_out        <= ALUout_in;
	ReadData1_out     <= ReadData1_in;
	ReadData2_out     <= ReadData2_in;
	SignExtendOut_out <= SignExtendOut_in;
	MuxOut_out        <= MuxOut_in;
	MemoryOut_out     <= MemoryOut_in;      --- Need to be modified  
	
end architecture;