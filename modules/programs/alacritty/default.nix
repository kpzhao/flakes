{ config
, pkgs
, ...
}: {
  home = {
    packages = with pkgs; [
      lf
    ];
  };
  home.file.".config/alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "./alacritty.toml";
}
