with import <nixpkgs> {};
  stdenv.mkDerivation {
    name = "hello-HEAD";
    src = ./.;
    installPhase = ''
      echo "Hello" > $out
    '';
  }
