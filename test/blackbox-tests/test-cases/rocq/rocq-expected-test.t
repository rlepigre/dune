Testing the expected test support.

  $ cat > dune-project <<EOF
  > (lang dune 3.21)
  > (using rocq 0.11)
  > EOF

  $ cat > dune <<EOF
  > (rocq.theory
  >  (name a))
  > EOF

  $ cat > foo.v <<EOF
  > Locate nat.
  > EOF

  $ dune build
  Inductive Corelib.Init.Datatypes.nat

  $ dune clean
  $ touch foo.expected
  $ dune build
  $ dune runtest
  File "foo.expected", line 1, characters 0-0:
  --- foo.expected
  +++ foo.output
  @@ -0,0 +1 @@
  +Inductive Corelib.Init.Datatypes.nat
  [1]

  $ dune promote
  Promoting _build/default/foo.output to foo.expected.
  $ cat foo.expected
  Inductive Corelib.Init.Datatypes.nat
  $ dune runtest
