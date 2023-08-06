{ config
, pkgs
, # user,
  # my,
  ...
} @ args: {
  nix.settings.experimental-features = [ "nix-command" "flakes" "ca-derivations" "auto-allocate-uids" "cgroups" ];

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelParams = [
      "quiet"
      # "splash"
      "i915.enable_psr=0"
    ];
    # consoleLogLevel = 0;
    # initrd.verbose = false;
  };

  networking.hostName = "nixos";

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
  };
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "socks5://127.0.0.1:10808/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    font-awesome
    sarasa-gothic
  ];

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.defaultUserShell = pkgs.fish;
  users.users.root = {
    initialHashedPassword = "$6$WSLqMj/csKrhFrgF$zHtpHPOepWr18G.mL1xcfmUAGLXnzdTxidFaeM9TLdlDGZ3JoHufH3ScROtfL35dgGo.tKNO2ypPqJ4aPVtxt/";
  };
  programs.fish.enable = true;
  users.users.Tim = {
    initialHashedPassword = "$6$WSLqMj/csKrhFrgF$zHtpHPOepWr18G.mL1xcfmUAGLXnzdTxidFaeM9TLdlDGZ3JoHufH3ScROtfL35dgGo.tKNO2ypPqJ4aPVtxt/";
    shell = pkgs.fish;
    isNormalUser = true;
    description = "tim";
    extraGroups = [ "adbusers" "networkmanager" "wheel" "root" ];
    packages = with pkgs; [
      ripgrep
      kitty
      firefox
      systemd-run-app
    ];
  };
  home-manager.users."Tim" = import ../home.nix;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
    ];
  };

  environment.sessionVariables = rec {
    MOZ_ENABLE_WAYLAND = "1";
    # GLFW_IM_MODULE = "fcitx";
    # GTK_IM_MODULE = "fcitx";
    # QT_IM_MODULE = "fcitx";
    # XMODIFIERS = "@im=fcitx";
    # INPUT_METHOD = "fcitx";
    # IMSETTINGS_MODULE = "fcitx";
    NIXOS_OZONE_WL = "1";
    # WLR_RENDERER = "vulkan";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  programs.adb.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    neofetch
    telegram-desktop
    element-desktop
    firefox
    gcc
    llvmPackages_16.libllvm
    gnumake
    p7zip
  ];

  security.polkit.enable = true;
  security.sudo = {
    enable = true;
    extraConfig = ''
      Tim ALL=(ALL) NOPASSWD:ALL
    '';
  };
  security.pam.services.swaylock = { };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };
  programs = {
    dconf.enable = true;
  };

  systemd.services = {
    # For wayland users
    seatd = {
      enable = true;
      description = "Seat management daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  services.gvfs.enable = true;
  services.v2raya.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05";
}
