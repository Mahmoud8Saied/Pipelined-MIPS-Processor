library ieee;
use ieee.std_logic_1164.all;

entity MUX4 is
    generic (n : integer := 32);
    port (

        s : in std_logic_vector(3 downto 0);
        data_in1 : in std_logic_vector(n - 1 downto 0);
        data_in2 : in std_logic_vector(n - 1 downto 0);
        data_in3 : in std_logic_vector(n - 1 downto 0);
        data_in4 : in std_logic_vector(n - 1 downto 0);
        data_in5 : in std_logic_vector(n - 1 downto 0);
        data_in6 : in std_logic_vector(n - 1 downto 0);
        data_in7 : in std_logic_vector(n - 1 downto 0);
        data_in8 : in std_logic_vector(n - 1 downto 0);
        data_in9 : in std_logic_vector(n - 1 downto 0); 
        data_out : out std_logic_vector(n - 1 downto 0));

end entity;

architecture mux4 of MUX4 is
begin
    data_out <= data_in1 when S(0) = '0' and S(1) = '0' and S(2) = '0'
        else
        data_in2 when S(0) = '1' and S(1) = '0' and S(2) = '0' and S(3) = '0'
        else
        data_in3 when S(0) = '0' and S(1) = '1' and S(2) = '0' and S(3) = '0'
        else
        data_in4 when S(0) = '1' and S(1) = '1' and S(2) = '0' and S(3) = '0'
        else
        data_in5 when S(0) = '1' and S(1) = '1' and S(2) = '1' and S(3) = '0'
        else
        data_in6 when S(0) = '0' and S(1) = '0' and S(2) = '1' and S(3) = '0'
        else
        data_in7 when S(0) = '1' and S(1) = '0' and S(2) = '1' and S(3) = '0'
        else
        data_in8 when S(0) = '0' and S(1) = '1' and S(2) = '1' and S(3) = '0'
        else
        data_in9 when S(0) = '1' and S(1) = '0' and S(2) = '0' and S(3) = '1'
        else 
        data_in1;
end architecture;
