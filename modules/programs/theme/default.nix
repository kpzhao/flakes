{ pkgs, config, inputs, nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.nord;

  # packages = [ pkgs.sytemd-run-app pkgs.alacritty-1  ];
  #
  programs = {
    # alacritty = {
    #   enable = true;
    #   # package = pkgs.alacritty-1;
    #   settings = {
    #     foreground = "#${config.colorScheme.colors.base05}";
    #     background = "#${config.colorScheme.colors.base00}";
    #     # ...
    #   };
    # };
  };
}
