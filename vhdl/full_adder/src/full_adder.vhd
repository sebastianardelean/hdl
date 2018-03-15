ENTITY full_adder IS
  port (
    a, b, cin:in bit;              -- input data
    s, cout:out bit);             -- output
END full_adder;
ARCHITECTURE dataflow OF full_adder IS
BEGIN
  s<=a xor b xor cin;
  cout<=(a and b) or (a and cin) or (b and cin);
END dataflow;

