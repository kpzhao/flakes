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
      cleanup = "doas nix-collect-garbage --delete-older-than 7d";
      fcd = "cd $(find -type d | fzf)";
      ls = "${lib.getExe eza} -h --git --icons --color=auto --group-directories-first -s extension";
      l = "ls -lF --time-style=long-iso --icons";
      la = "${lib.getExe eza} -lah --tree";
      tree = "${lib.getExe eza} --tree --icons --tree";
      ps = lib.getExe procs;
    };

    functions = {
      lfcd = ''
        cd "$(command lf -print-last-dir $argv)"
      '';
      f = ''
        FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git' FZF_DEFAULT_OPTS="--color=bg+:#4C566A,bg:#424A5B,spinner:#F8BD96,hl:#F28FAD  --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96  --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD --preview 'bat --style=numbers --color=always --line-range :500 {}'" fzf --height 60% --layout reverse --info inline --border --color 'border:#b48ead'
      '';
    };
  };
  home.file = {
    ".config/fish/conf.d/nord.fish".text = import ./nord_theme.nix;
    ".config/fish/functions/fish_prompt.fish".source = ./functions/fish_prompt.fish;
    ".config/fish/functions/xdg-get.fish".text = import ./functions/xdg-get.nix;
    ".config/fish/functions/xdg-set.fish".text = import ./functions/xdg-set.nix;
    ".config/fish/functions/owf.fish".text = import ./functions/owf.nix;
    ".config/fish/functions/nuwa.fish".text = import ./functions/scrcpy.nix;
  };
}
