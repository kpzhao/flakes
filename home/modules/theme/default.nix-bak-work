{ pkgs, config, inputs, nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModules.default
  ];

  colorScheme = nix-colors.colorSchemes.nord;

  # packages = [ pkgs.sytemd-run-app pkgs.alacritty-1  ];
  #
  programs = {
    alacritty = {
      enable = true;
      package = (pkgs.callPackage ../../../pkgs/alacritty-1/default.nix {});
      settings = {
        colors.primary.foreground = "#${config.colorScheme.colors.base05}";
        colors.primary.background = "#${config.colorScheme.colors.base00}";
        # ...
      };
    };
  };
}
