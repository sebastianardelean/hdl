entity full_adder_tb is
  
end full_adder_tb;
architecture behav of full_adder_tb is
  component full_adder
    port (
      a, b, cin : in  bit;                -- inputs
      s, cout : out bit);               -- outputs
  end component;
  for adder_0: full_adder use entity work.full_adder;
  signal a,b,cin,s,cout : bit;          -- signals
begin  -- behav
  adder_0 : full_adder port map (
    a    => a,
    b    => b,
    cin  => cin,
    s    => s,
    cout => cout);
  process
    type pattern_type is record
      a,b,cin:bit;
      s,cout:bit;
    end record;
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array := (('0','0','0','0','0'),
                                          ('0','0','1','1','0'),
                                          ('0','1','0','1','0'),
                                          ('0','1','1','0','1'),
                                          ('1','0','0','1','0'),
                                          ('1','0','1','0','1'),
                                          ('1','1','0','0','1'),
                                          ('1','1','1','1','1')
                                          );  -- constant pattern
    begin
      for i in patterns' range loop
        a<=patterns(i).a;
        b<=patterns(i).b;
        cin<=patterns(i).cin;

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
