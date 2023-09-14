{ pkgs, config, nix-colors, ... }:
let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme vimThemeFromScheme;
in
{
  imports = [
    nix-colors.homeManagerModules.default
  ];
  colorScheme = nix-colors.colorSchemes.nord;

  gtk ={
  enable =true;
  theme = {
    name = "${config.colorscheme.slug}";
    package = gtkThemeFromScheme {
      scheme = config.colorscheme;
    };
  };
  };

  programs.neovim.plugins = [
    {
      plugin = vimThemeFromScheme { scheme = config.colorscheme; };
      config = "colorscheme nix-${config.colorscheme.slug}";
    }
  ];

  programs = {
    alacritty = {
      enable = true;
      package = (pkgs.callPackage ../../../pkgs/alacritty-1/default.nix { });
      settings = {
        colors.primary.foreground = "#${config.colorScheme.colors.base05}";
        colors.primary.background = "#${config.colorScheme.colors.base00}";
        # ...
      };
    };
  };
    programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "FiraCode Nerd Font 15";
    theme = toString (pkgs.substituteAll (
      { src = ./theme.rasi; } // config.colorScheme.colors
    ));
  };
}
