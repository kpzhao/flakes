{ pkgs, ... }: {
  imports = [
    ./app-git
    ./aria2
    # ./fcitx5
    ./firefox
    ./lf
    ./mako
    ./mpd
    ./mpv
    # ./nvim-theme
    ./rofi
    ./sway
    ./theme
    ./waybar
    ./xdg
    ./xray
  ];
}
