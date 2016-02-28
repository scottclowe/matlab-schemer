library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Comment about the Driver here
entity Driver is
port( x : in std_logic;
    F : out std_logic
);
end Driver;  

architecture gate_level of Driver is
begin
    if newx(x downto (x-3))="0000" then
        F <= '1';
    else
        F <= not(x(2) xor x(2));  --XNOR gate with 2 inputs
    end if;
end gate_level;
