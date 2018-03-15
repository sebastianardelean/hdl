library ieee;
use ieee.std_logic_1164.all;
ENTITY d_ff_tb IS
END d_ff_tb;

ARCHITECTURE dataflow OF d_ff_tb IS
signal T_data_in : std_logic;            -- input data =>d port
signal T_clock : std_logic;              -- input clock=>clk port
signal T_reset : std_logic;              -- input reset=>reset port
signal T_data_out : std_logic;           -- out data=>q port    
component d_ff
  port (
    d, clk, reset : in  std_logic;      -- inputs for d_ff
    q             : out std_logic);     -- output for d_ff
end component;
BEGIN
  DFF : d_ff port map (                 -- in form formal=>actual
    d     => T_data_in,
    clk   => T_clock,
    reset => T_reset,
    q     => T_data_out);

  --concurrent process to offer clock signal
  process
    begin
     T_clock<='0';
      wait for 5 ns;
      T_clock<='1';
      wait for 5 ns;
    end process;

  process
    variable error_counter : integer := 0;  -- error counter
    begin
      --case 1 reset=1 d!=0 =>q=0
      T_reset<='1';
      T_data_in<='1';
      wait for 5 ns;
      assert(T_data_out='0') report "Error on reset" severity error;
      if(T_data_out/='0') then
        error_counter:=error_counter+1;
      end if;

      --case 2 reset=0, d=1 =>q=0 if clk event
      T_data_in<='1';
      T_reset<='0';
      assert (T_data_out='0') report "Error on clock event for input 1" severity error;
      if (T_data_out/='0') then
        error_counter:=error_counter+1;
      end if;
      
      wait for 5 ns;

      --case 3 reset=0, d=1=>q=1 if no clk event
      T_data_in<='1';
      T_reset<='0';
      assert (T_data_out='1') report "Error output doesn't copy input if no clock event" severity error;
      if (T_data_out/='1') then
        error_counter:=error_counter+1;
      end if;
      wait for 5 ns;
      
      --end tests
      if(error_counter=0) then
        assert false report "Testbench completed succesfully" severity note;
      else
        assert true report "Some test failed" severity failure;
      end if;
      wait;
    end process;
          
END dataflow;
