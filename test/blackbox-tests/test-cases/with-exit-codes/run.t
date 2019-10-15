  $ cat > dune-project <<EOF
  > (lang dune 2.0)
  > EOF

  $ cat > dune <<EOF
  > (executable
  >  (name exit)
  >  (modules exit))
  > (rule (with-stdout-to exit.ml (echo "let () = exit (int_of_string Sys.argv.(1))")))
  > EOF

  $ cat >> dune <<EOF
  > (alias
  >  (name a)
  >  (action (with-accepted-exit-codes 0 (run ./exit.exe 1))))
  > EOF

  $ dune build --display=short --root . @a
      ocamldep .exit.eobjs/exit.ml.d
        ocamlc .exit.eobjs/byte/dune__exe__Exit.{cmi,cmo,cmt}
      ocamlopt .exit.eobjs/native/dune__exe__Exit.{cmx,o}
      ocamlopt exit.exe
          exit alias a (exit 1)
  (cd _build/default && ./exit.exe 1)
  [1]

  $ cat >> dune <<EOF
  > (alias
  >  (name b)
  >  (action (with-accepted-exit-codes (not 0) (run ./exit.exe 1))))
  > EOF

  $ dune build --display=short --root . @b
          exit alias b

  $ cat >> dune <<EOF
  > (alias
  >  (name c)
  >  (action (with-accepted-exit-codes (or 1 2 3) (run ./exit.exe 2))))
  > (alias
  >  (name d)
  >  (action (with-accepted-exit-codes (or 4 5 6) (run ./exit.exe 7))))
  > EOF

  $ dune build --display=short --root . @c
          exit alias c

  $ dune build --display=short --root . @d
          exit alias d (exit 7)
  (cd _build/default && ./exit.exe 7)
  [1]

  $ cat >> dune <<EOF
  > (alias
  >  (name e)
  >  (action (with-accepted-exit-codes (not 0) (dynamic-run ./exit.exe 1))))
  > EOF

  $ dune build --display=short --root . @e
  File "dune", line 19, characters 43-69:
  19 |  (action (with-accepted-exit-codes (not 0) (dynamic-run ./exit.exe 1))))
                                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^
  Error: with-accepted-exit-codes can only be used with "run", "bash" or
  "system"
  [1]
