# module-loader

Load haskell module dynamically.

## Demonstration

Compile a shared module:

```ShellSession
$ ghc --make -shared -dynamic Test.hs
[1 of 2] Compiling Test
[2 of 2] Linking a.out
$ nm a.out | grep maFonc
0000000000003080 D Test_maFonction_closure
00000000000013e0 T Test_maFonction_info
```

Load the module with ghci:

```ShellSession
$ cabal repl
Build profile: -w ghc-9.6.1 -O1
λ> (f :: String -> IO ()) <- ModuleLoader.loadModule "/srv/github.com/ButlerOS/module-loader/a.out" "Test_maFonction_closure"
λ> f "Haskell"
Hello Haskell
```

This also works in ghcid:

```ShellSession
$ ghcid --command "cabal repl module-loader-demo" --test main
Loading: /srv/github.com/ButlerOS/module-loader/a.out
Hello Haskell
```

But this does not worked compiled:

```ShellSession
$ cabal run
Build profile: -w ghc-9.6.1 -O1
In order, the following will be built (use -v for more details):
 - module-loader-0.1 (exe:module-loader-demo) (first run)
Preprocessing executable 'module-loader-demo' for module-loader-0.1..
Building executable 'module-loader-demo' for module-loader-0.1..
[1 of 1] Compiling Main
[2 of 2] Linking /srv/github.com/ButlerOS/module-loader/dist-newstyle/build/x86_64-linux/ghc-9.6.1/module-loader-0.1/x/module-loader-demo/build/module-loader-demo/module-loader-demo
Loading: /srv/github.com/ButlerOS/module-loader/a.out
module-loader-demo: /nix/store/1pr94zb2a4n0x7ybl3wmyf1nss5wirb1-ghc-9.6.1/lib/ghc-9.6.1/lib/../lib/x86_64-linux-ghc-9.6.1/libHSghc-prim-0.10.0-ghc9.6.1.so: undefined symbol: stg_gc_unpt_r1
CallStack (from HasCallStack):
  error, called at src/ModuleLoader.hs:16:17 in module-loader-0.1-inplace:ModuleLoader
```

Is this related to https://gitlab.haskell.org/ghc/ghc/-/issues/17157 ?
