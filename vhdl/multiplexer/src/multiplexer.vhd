library ieee;
use ieee.std_logic_1164.all;
-- Multiplexor with 4 inputs on 4 bits and 1 select on 2 bits
ENTITY multiplexer IS
  port (
    i_3,i_2,i_1,i_0 : in std_logic_vector(3 downto 0);  -- inputs on 4 bits
    s : in std_logic_vector(1 downto 0);  -- select input
    o : out std_logic_vector(3 downto 0)  -- output
    );
END multiplexer;

ARCHITECTURE dataflow OF multiplexer IS
BEGIN
  process (i_3,i_2,i_1,i_0,s)
    begin
      case s is
        when "00" => o<=i_0;
        when "01" => o<=i_1;
        when "10" => o<=i_2;
        when "11" => o<=i_3;
        when others => o<="ZZZZ";
      end case;
    end process;
END dataflow;
