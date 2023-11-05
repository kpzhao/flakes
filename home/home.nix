{ config
, pkgs
, inputs
, # my,
  ...
}: {
  imports = [
    ./modules
  ];
  home.username = "Tim";
  home.homeDirectory = "/home/Tim";

  gtk = {
    enable = true;
    theme = {
      package = pkgs.materia-theme;
      name = "Materia";
    };
    iconTheme = {
      package = pkgs.numix-icon-theme-circle;
      name = "Numix-Circle";
    };
    font = {
      package = pkgs.roboto;
      name = "Roboto";
      size = 11;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.packages = with pkgs; [
    android-tools
    # (callPackage ./../pkgs/hello/default.nix {})
    (callPackage ./../pkgs/alacritty-1/default.nix{})
    # (dwl-git.override ({ conf = ./pkgs/dwl-git/dwl-config.h; }))
    # (my-dwl.override({ conf = ./pkgs/my-dwl/dwl-config.h;}))
    # dwl-bar
    du-dust
    foot
    # (dwl-git.overrideAttrs (drv: rev {conf = ./pkgs/dwl-git/dwl-config.h};))
    at-spi2-core
    brightnessctl
    eza
    meson
    ninja
    pkg-config
    wayland
    wayland-protocols
    fcitx5-pinyin-zhwiki
    fzf
    imv
    intel-gpu-tools
    helix
    neofetch
    git
    nix-du
    slurp
    lf
    logseq
    wl-clipboard
    ripgrep
    mako
    mpd
    mpv
    ncmpcpp
    nil
    nodejs
    qq
    #rustdesk
    spotify
    swappy
    telegram-desktop
    trash-cli
    unzip
    vulkan-tools
    vulkan-validation-layers
   # wpsoffice
    xdg-desktop-portal
    xfce.thunar
    xorg.xprop
    xorg.xrdb
    xray
    git-repo tree
  ];
  # services.udiskie = {
  #   enable = true;
  #   automount = true;
  #   notify = true;
  # };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
