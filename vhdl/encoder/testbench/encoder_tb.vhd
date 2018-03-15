library ieee;
use ieee.std_logic_1164.all;
ENTITY encoder_tb IS
END encoder_tb;

ARCHITECTURE dataflow OF encoder_tb IS
  signal T_I : std_logic_vector(3 downto 0) := "0000";  -- input
  signal T_O : std_logic_vector(1 downto 0);  -- output

  component encoder
    port (
      I : in  std_logic_vector(3 downto 0);    -- input
      O : out std_logic_vector(1 downto 0));   -- output
  end component;
  
BEGIN
  ENC : encoder port map (
    I => T_I,
    O => T_O);
  process
    variable error_counter : integer := 0;  -- error counter
    begin
      --case T_I=0001=>T_O=00
      T_i<="0001";
      wait for 10 ns;
      assert (T_O="00") report "Expected output 00 for input 0001" severity error;
      if(T_O/="00") then
        error_counter:=error_counter+1;
      end if;

      --case T_I=0010=>T_O=01
      T_i<="0010";
      wait for 10 ns;
      assert (T_O="01") report "Expected output 01 for input 0010" severity error;
      if(T_O/="01") then
        error_counter:=error_counter+1;
      end if;

      --case T_I=0100=>T_O=10
      T_i<="0100";
      wait for 10 ns;
      assert (T_O="10") report "Expected output 10 for input 0100" severity error;
      if(T_O/="10") then
        error_counter:=error_counter+1;
      end if;
      
      --case T_I=1000=>T_O=11
      T_i<="1000";
      wait for 10 ns;
      assert (T_O="11") report "Expected output 11 for input 1000" severity error;
      if(T_O/="11") then
        error_counter:=error_counter+1;
      end if;
      
      --case T_I=0000=>T_O=ZZ
      T_i<="0000";
      wait for 10 ns;
      assert (T_O="ZZ") report "Expected output ZZ for input 0000" severity error;
      if(T_O/="ZZ") then
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

