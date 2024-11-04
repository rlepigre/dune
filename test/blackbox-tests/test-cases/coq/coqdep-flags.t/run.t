By default the coqdep flags are empty, and missing files only lead to a simple
warning.

  $ cp theories/dune.noflags theories/dune
  $ dune build theories/.basic.theory.d
  Warning: in file bar.v, library baz is required
           from root basic and has not been found in the loadpath!
           [module-not-found,filesystem,default]

We define coqdep flags that turn all warnings into errors, which leads to the
above warning being turned into an error.

  $ mv dune.disabled dune
  $ dune build theories/.basic.theory.d
  File "theories/dune", lines 1-2, characters 0-26:
  1 | (coq.theory
  2 |  (name basic))
  *** Error: in file bar.v, library baz is required
             from root basic and has not been found in the loadpath!
             [module-not-found,filesystem,default]
  [1]

We then add the same flag (now duplicated) to the theory, which should not
change anything.

  $ rm -f theories/dune
  $ cp theories/dune.flags theories/dune
  $ dune build theories/.basic.theory.d
  File "theories/dune", lines 1-3, characters 0-62:
  1 | (coq.theory
  2 |  (name basic)
  3 |  (coqdep_flags (:standard -w +all)))
  *** Error: in file bar.v, library baz is required
             from root basic and has not been found in the loadpath!
             [module-not-found,filesystem,default]
  [1]

Finally we remove the toplevel dune file which sets the flags globally, but
keep the theory-local flags, so the behavior does not change.

  $ rm -f dune
  $ dune build theories/.basic.theory.d
  File "theories/dune", lines 1-3, characters 0-62:
  1 | (coq.theory
  2 |  (name basic)
  3 |  (coqdep_flags (:standard -w +all)))
  *** Error: in file bar.v, library baz is required
             from root basic and has not been found in the loadpath!
             [module-not-found,filesystem,default]
  [1]

Creating the missing file fixes the error.

  $ touch theories/baz.v
  $ dune build theories/.basic.theory.d
