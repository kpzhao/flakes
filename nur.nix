{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  nur-no-pkgs = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {};
in {
  imports = lib.attrValues nur-no-pkgs.repos.moredhel.hmModules.rawModules;
}
