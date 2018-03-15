library ieee;
use ieee.std_logic_1164.all;
ENTITY multiplexer_tb IS
END multiplexer_tb;
ARCHITECTURE dataflow OF multiplexer_tb IS
  --declare signals and initialize signals with 0000
  signal T_I3:std_logic_vector(3 downto 0):="0000";
  signal T_I2:std_logic_vector(3 downto 0):="0000";
  signal T_I1:std_logic_vector(3 downto 0):="0000";
  signal T_I0:std_logic_vector(3 downto 0):="0000";
  signal T_O : std_logic_vector(3 downto 0);
  signal T_S:std_logic_vector(1 downto 0);

  component multiplexer
    port (
      i_3, i_2, i_1, i_0 : in  std_logic_vector(3 downto 0);  -- mux input ports
      s                  : in  std_logic_vector(1 downto 0);  -- select port
      o                  : out std_logic_vector(3 downto 0));  -- output port
  end component;
BEGIN
  UUT_MUX : multiplexer port map (
    i_3 => T_I3,
    i_2  => T_I2,
    i_1  => T_I1,
    i_0  => T_I0,
    s    => T_S,
    o    => T_O);

  process
    variable error_counter : integer := 0;  -- error counter
    begin
      T_I3<="0011";
      T_I2<="0010";
      T_I1<="0001";
      T_I0<="0000";

      --select equal 00
      T_S<="00";
      wait for 10 ns;
      assert(T_O="0000") report "Error wrong output for select equal 00! Expected port I_0" severity error;
      if(T_O/="0000") then
        error_counter:=error_counter+1;
      end if;
      
      --select equal 01
      T_S<="01";
      wait for 10 ns;
      assert (T_O="0001") report "Error wrong output for select equal 01! Expected port I_1" severity error;
      if (T_O/="0001") then
        error_counter:=error_counter+1;
      end if;

      --select equal 10
      T_S<="10";
      wait for 10 ns;
      assert (T_O="0010") report "Error wrong output for select equal 10! Expected port I_2" severity error;
      if (T_O/="0010") then
        error_counter:=error_counter+1;
      end if;

      --select equal 11
      T_S<="11";
      wait for 10 ns;
      assert (T_O="0011") report "Error wrong output for select equal 11! Expected port I_3" severity error;
      if (T_O/="0011") then
        error_counter:=error_counter+1;
      end if;

      --select greater that 011=>expected output ZZZZ, high impedance
      T_S<="ZZ";
      wait for 10 ns;
      assert (T_O="ZZZZ") report "Error wrong output for selec greater that ZZ,expected High Impedance" severity error;
      if (T_O/="ZZZZ") then
        error_counter:=error_counter+1;
      end if;

      if (error_counter=0) then
        assert (false) report "Testbench of MUX completed successfully!" severity note;
      else
        assert (true) report "Some tests failed!" severity failure;
      end if;

      wait;
    end process;
END dataflow;
