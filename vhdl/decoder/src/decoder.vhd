library ieee;
use ieee.std_logic_1164.all;
ENTITY decoder IS
port (
  I : in  std_logic_vector(1 downto 0);   -- input
  O : out std_logic_vector(3 downto 0));  -- output
END decoder;

ARCHITECTURE dataflow OF decoder IS

BEGIN
  DEC: process (I)
  begin  -- process I

    case I is
      when "00" =>O<="0001";
      when "01" =>O<="0010";
      when "10" =>O<="0100";
      when "11" =>O<="1000";        
      when others =>O<="ZZZZ";
    end case;
    
  end process DEC;
  

END dataflow;
