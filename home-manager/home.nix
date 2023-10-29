{ config
, pkgs
, inputs
, # my,
  ...
}: {
  imports = [
    ./modules/programs
  ];
  home.username = "Tim";
  home.homeDirectory = "/home/Tim";

  home.packages = with pkgs; [
    android-tools
    # (callPackage ./pkgs/hello/default.nix {})
    # (callPackage ./pkgs/alacritty-1/default.nix{})
    # (dwl-git.override ({ conf = ./pkgs/dwl-git/dwl-config.h; }))
    # (my-dwl.override({ conf = ./pkgs/my-dwl/dwl-config.h;}))
    # dwl-bar
    du-dust
    foot
    # (dwl-git.overrideAttrs (drv: rev {conf = ./pkgs/dwl-git/dwl-config.h};))
    at-spi2-core
    brightnessctl
    meson
    ninja
    pkg-config
    wayland
    wayland-protocols
    fcitx5-pinyin-zhwiki
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
    rustdesk
    spotify
    swappy
    telegram-desktop
    trash-cli
    unzip
    vulkan-tools
    vulkan-validation-layers
    wpsoffice
    xdg-desktop-portal
    xfce.thunar
    xorg.xprop
    xorg.xrdb
    xray
    git-repo
    tree
  ];
  # services.udiskie = {
  #   enable = true;
  #   automount = true;
  #   notify = true;
  # };
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      comment-nvim
      everforest
      luasnip
      vim-lastplace
      editorconfig-nvim
      lualine-nvim
      which-key-nvim
      lualine-lsp-progress
    ];
    extraConfig = ''
      :source ${./nvim.lua}
    '';
  };

  home.stateVersion = "24.05";
  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
