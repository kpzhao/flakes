{ pkgs, config, nix-colors, ... }:

let
  inherit (nix-colors.lib-contrib { inherit pkgs; }) vimThemeFromScheme;
in
{
  programs.neovim.plugins = [
    {
      plugin = vimThemeFromScheme { scheme = config.colorscheme; };
      config = "colorscheme nix-${config.colorscheme.slug}";
    }
  ];
}
