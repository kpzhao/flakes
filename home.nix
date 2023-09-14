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
    # (callPackage ./pkgs/hello/default.nix {})
    # (callPackage ./pkgs/alacritty-1/default.nix{})
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
    swappy
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

  home.stateVersion = "23.11";
   systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
