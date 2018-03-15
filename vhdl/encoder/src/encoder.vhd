--src/encoder.vhd
library ieee;
use ieee.std_logic_1164.all;
ENTITY encoder IS
  port (
    I : in  std_logic_vector(3 downto 0);               -- input on 4 bits
    O : out std_logic_vector(1 downto 0));  -- output on 2 bits
  
END encoder;

ARCHITECTURE dataflow OF encoder IS
BEGIN
 -- purpose: encoder process
 -- type   : combinational
 -- inputs : I
 -- outputs: O
 ENC: process (I)
 begin  -- process ENC
   case I is
     when "0001" =>O<="00" ;
     when "0010" =>O<="01" ;
     when "0100" =>O<="10" ;
     when "1000" =>O<="11" ;
     when others => O<="ZZ";
   end case;
 end process ENC;

END dataflow;

