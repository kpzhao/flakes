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
    ./rofi
    ./sway
    ./waybar
    ./xdg
    ./xray
  ];
}
