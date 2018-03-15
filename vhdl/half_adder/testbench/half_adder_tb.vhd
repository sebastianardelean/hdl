entity half_adder_tb is
end half_adder_tb;
architecture behav of half_adder_tb is
  component half_adder
    port (
      a, b : in  bit;                -- inputs
      s, cout : out bit);               -- outputs
  end component;
  for half_adder_0: half_adder use entity work.half_adder;
  signal a,b,s,cout : bit;          -- signals
begin  -- behav
 half_adder_0 : half_adder port map (
    a    => a,
    b    => b,
    s    => s,
    cout => cout);
  process
    type pattern_type is record
      a,b:bit;
      s,cout:bit;
    end record;
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array := (('0','0','0','0'),
                                          ('0','1','1','0'),
                                          ('1','0','1','0'),
                                          ('1','1','0','1')
                                          );  -- constant pattern
    begin
      for i in patterns' range loop
        a<=patterns(i).a;
        b<=patterns(i).b;
        wait for 1 ns ;

        assert s=patterns(i).s
          report "bad sum value" severity ERROR;
        assert cout=patterns(i).cout
          report "bad cout array out of value" severity error;
      end loop;
      assert false report "end of test" severity note;
      wait;
  end process;
end behav;
