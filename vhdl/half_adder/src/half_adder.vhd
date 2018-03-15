ENTITY half_adder IS
  port (
    a, b  : in  bit;                   -- inputs
    cout, s : out bit);
END half_adder;
ARCHITECTURE dataflow OF half_adder IS
BEGIN
  s<=a xor b;
  cout<=a and b;
END dataflow;
