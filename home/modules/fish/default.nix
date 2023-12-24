{ config, ... }:
{
  programs.fish = {
    enable = true;
    loginShellInit =
      if config.wayland.windowManager.hyprland.enable then ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec Hyprland
      ''
      else if config.wayland.windowManager.sway.enable then ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec sway
                	''
      else '''';
    interactiveShellInit = ''set fish_greeting ""'';

  };
  home.file = {
    ".config/fish/conf.d/nord.fish".text = import ./nord_theme.nix;
    ".config/fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
    ".config/fish/functions/xdg-get.fish".text = import ./functions/xdg-get.nix;
    ".config/fish/functions/xdg-set.fish".text = import ./functions/xdg-set.nix;
    ".config/fish/functions/owf.fish".text = import ./functions/owf.nix;
  };
}
