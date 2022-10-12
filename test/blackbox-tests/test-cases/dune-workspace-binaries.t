  $ cat >dune-workspace <<EOF
  > (lang dune 3.4)
  > 
  > (env
  >  (dev
  >   (binaries (test.sh as test))
  >   (flags :standard)))
  > EOF

  $ cat >dune-project <<EOF
  > (lang dune 3.4)
  > (name dune_bug)
  > EOF

  $ cat >dune <<EOF
  > (rule
  >  (target message.txt)
  >  (action (with-stdout-to %{target} (run test))))
  > EOF

  $ cat >test.sh <<EOF
  > #!/bin/bash
  > 
  > echo "This is only a test."
  > EOF

  $ chmod +x test.sh
  $ dune build
