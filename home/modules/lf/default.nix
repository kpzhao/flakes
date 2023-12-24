{ config
, pkgs
, ...
}: {
  home = {
    packages = with pkgs; [
      lf
    ];
  };
  home.file.".config/lf/lfrc".source = ./lfrc;
}
