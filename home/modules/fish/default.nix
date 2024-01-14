{ config, pkgs, ... }:
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
    shellAliases = with pkgs; {
      rebuild = "doas nix-store --verify; pushd ~/Documents/flakes && doas nixos-rebuild switch --flake .#Tim && notify-send \"Done\"&& bat cache --build; popd";
      fcd = "cd $(find -type d | fzf)";
      ls = "${lib.getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
      l = "ls -lF --time-style=long-iso --icons";
      la = "${lib.getExe eza} -lah --tree";
      tree = "${lib.getExe eza} --tree --icons --tree";
    };
  };
  home.file = {
    ".config/fish/conf.d/nord.fish".text = import ./nord_theme.nix;
    ".config/fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
    ".config/fish/functions/xdg-get.fish".text = import ./functions/xdg-get.nix;
    ".config/fish/functions/xdg-set.fish".text = import ./functions/xdg-set.nix;
    ".config/fish/functions/owf.fish".text = import ./functions/owf.nix;
  };
}
