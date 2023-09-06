{ config
, lib
, pkgs
, user
, # my,
  ...
}: {
  imports = [
    ./modules/programs
  ];
  home.username = "Tim";
  home.homeDirectory = "/home/Tim";

  home.packages = with pkgs; [
    at-spi2-core
    brightnessctl
    meson
    ninja
    pkg-config
    wayland
    wayland-protocols
    # fcitx5-pinyin-zhwiki
    imv
    intel-gpu-tools
    helix
    neofetch
    slurp
    lf
    logseq
    wl-clipboard
    ripgrep
    mako
    mpd
    mpv
    ncmpcpp
    nodejs
    # qq
    swappy
    # sway-contrib.grimshot
    telegram-desktop
    trash-cli
    unzip
    vulkan-tools
    vulkan-validation-layers
    wpsoffice
    xfce.thunar
    xorg.xprop
    xorg.xrdb
    xray
  ];
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
