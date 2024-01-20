{ pkgs
, ...
}: {
  # terminal file manager
  programs.yazi = {
    enable = true;
    # Changing working directory when exiting Yazi
    enableFishIntegration = true;
  };

  # xdg.configFile."yazi/theme.toml".source = "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-yazi}/mocha.toml";
}
