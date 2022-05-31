LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FlagRegister IS
    GENERIC (n : INTEGER := 3);
    PORT (
        clk, rst : IN STD_LOGIC;
        d, enable, clear : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0); -- enable(0) -> Zero, enable(1) -> negative, enable(2) -> carry
        q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
END FlagRegister;

ARCHITECTURE FlagRegister1 OF FlagRegister IS
BEGIN
    PROCESS (clk, rst, enable, clear)
    BEGIN
        IF (Rst = '1') THEN
            q <= (OTHERS => '0');
        ELSIF rising_edge(Clk) THEN
            FOR i IN 0 TO n - 1 LOOP
            IF (clear(i) = '1') THEN
                q(i) <= '0';
            elsif (enable(i) = '1') Then
                q(i) <= d(i);
            END IF;
            END LOOP;
        END IF; 
    END PROCESS;
END FlagRegister1;

