library ieee;
use ieee.std_logic_1164.all;
ENTITY decoder_tb IS
END decoder_tb;


ARCHITECTURE dataflow OF decoder_tb IS
  signal T_I : std_logic_vector(1 downto 0) := "00";  -- input signal
  signal T_O : std_logic_vector(3 downto 0);  -- output signal

  component decoder
    port (
      I : in  std_logic_vector(1 downto 0);   -- input for decoder
      O : out std_logic_vector(3 downto 0));  -- output for decoder
  end component;
  
BEGIN
  DEC : decoder port map (
    I => T_I,
    O => T_O);

  process
    variable error_counter : integer := 0;  -- error counter
    begin

      --case T_I=00=> TO=0001
     
      T_I<="00";
      wait for 10 ns;
      assert (T_O="0001") report "Expected output 0001 for input 00" severity error;
      if (T_O/="0001") then
        error_counter:=error_counter+1;
      end if;

      --case T_I=01=> TO=0010
     -- wait for 10 ns;
      T_I<="01";
      wait for 10 ns;
      assert (T_O="0010") report "Expected output 0010 for input 01" severity error;
      if (T_O/="0010") then
        error_counter:=error_counter+1;
      end if;

      --case T_I=10=> TO=0100
--      wait for 10 ns;
      T_I<="10";
      wait for 10 ns;
      assert (T_O="0100") report "Expected output 0100 for input 10" severity error;
      if (T_O/="0100") then
        error_counter:=error_counter+1;
      end if;


      --case T_I=11=> TO=1000
--      wait for 10 ns;
      T_I<="11";
      wait for 10 ns;
      assert (T_O="1000") report "Expected output 1000 for input 11" severity error;
      if (T_O/="1000") then
        error_counter:=error_counter+1;
      end if;

      --case T_I=ZZ=> TO=ZZZZ
--      wait for 10 ns;
      T_I<="ZZ";
      wait for 10 ns;
      assert (T_O="ZZZZ") report "Expected output ZZZZ for input ZZ" severity error;
      if (T_O/="ZZZZ") then
        error_counter:=error_counter+1;
      end if;

      if (error_counter=0) then
        assert false report "All test ran successfully" severity note;
      else
        assert true report "Some test failed" severity failure;
      end if;

      wait;
  end process;
END dataflow;
