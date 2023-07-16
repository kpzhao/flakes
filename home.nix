{ config, lib, pkgs, user, impermanence, ... }:

{
  imports = [ 
        ./modules/programs
        # ./pkgs/fcitx5-pinyin-zhwiki
	    #./theming.nix
        #./modules/programs/sway
	#./modules/programs/waybar
	#./modules/programs/fcitx5
	#./modules/programs/rofi
	#./modules/programs/mpv
];
  home.username = "Tim";
  home.homeDirectory = "/home/Tim";

  home.packages = with pkgs;[

    at-spi2-core
    brightnessctl
    # fcitx5-pinyin-zhwiki
    imv
    intel-gpu-tools
    neofetch
    slurp
    lf
    wl-clipboard
    ripgrep
    mako
    mpd
    mpv
    ncmpcpp
    nodejs
    qq
    swappy
    sway-contrib.grimshot
    telegram-desktop
    trash-cli
    vulkan-tools
    vulkan-validation-layers
    wpsoffice
    xfce.thunar
    xorg.xprop
    xray
  ];
  services.udiskie = {
      enable = true ;
      automount = true;
      notify = true;
  };


  


    home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

