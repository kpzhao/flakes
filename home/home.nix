{ config
, pkgs
, ...
}: {
  imports = [
    ./modules
  ];
  home.username = "Tim";
  home.homeDirectory = "/home/Tim";

  gtk = {
    enable = true;
    # theme = {
    #   package = pkgs.materia-theme;
    #   name = "Materia";
    # };
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
  # qt = {
  #   enable = true;
  #   platformTheme = "gtk";
  # };

  home.packages = with pkgs; [
    age
    sops
    android-tools
    # (callPackage ./../pkgs/materia.nix {})
    # (callPackage ./../pkgs/alacritty-1/default.nix{})
    alacritty
    # (dwl-git.override ({ conf = ./pkgs/dwl-git/dwl-config.h; }))
    # (my-dwl.override({ conf = ./pkgs/my-dwl/dwl-config.h;}))
    # dwl-bar
    bat
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
    ffmpeg
    fzf
    imv
    intel-gpu-tools
    helix
    neofetch
    git
    nix-du
    slurp
    lf
    libnotify
    logseq
    wl-clipboard
    ripgrep
    mako
    mpd
    mpv
    ncmpcpp
    nil
    nodejs
    nvfetcher
    p7zip
    qq
    #rustdesk
    rclone
    spotify
    swappy
    telegram-desktop
    trash-cli
    unzip
    unar
    # vulkan-tools
    # vulkan-validation-layers
    wpsoffice
    # xdg-desktop-portal
    xfce.thunar
    xorg.xprop
    xorg.xrdb
    xorg.xeyes
    xray
    git-repo tree
    #bili_tui
    graphviz
    btop
  ];
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
