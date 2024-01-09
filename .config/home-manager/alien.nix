{ ... }:

let
  nix-alien-pkgs = import (builtins.fetchTarball
    "https://github.com/thiagokokada/nix-alien/tarball/master") { };
in {
  # ...
  home.packages = with nix-alien-pkgs; [ nix-alien ];
}
