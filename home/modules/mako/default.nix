{ config
, pkgs
, ...
}: {
  home = {
    packages = with pkgs; [
      mako
    ];
  };
  home.file.".config/mako/config".source = ./config;
}
