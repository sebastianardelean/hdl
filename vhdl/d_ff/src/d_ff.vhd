library ieee;
use ieee.std_logic_1164.all;
ENTITY d_ff IS
port (
  d, clk, reset : in  std_logic;        -- D input,Clock,Reset
  q             : out std_logic);       -- output

END d_ff;
ARCHITECTURE dataflow OF d_ff IS
BEGIN
  -- purpose: implement the behaviour of D_FF
  -- type   : combinational
  -- inputs : reset,clk
  -- outputs: std_logic
  process (reset,clk)
  begin  -- process
    if (reset='1') then
      q<='0';
    elsif (clk' event and clk='1') then
      q<=d;
    end if;
  end process;
END dataflow;



