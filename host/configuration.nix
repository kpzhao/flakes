{ config, lib, pkgs, inputs, ... }: {

  imports = [
    ./hardware-configuration.nix
    ./persistence.nix
    ./network.nix
  ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "tcp_bbr" ];
    kernelParams = [
      "quiet"
      # "loglevel=3"
      "splash"
      "i915.enable_psr=0"
      "nowatchdog"
    ];
    kernel.sysctl = {
      ## TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing
      # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
      # both incoming and outgoing connections:
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    consoleLogLevel = 3;
    supportedFilesystems = [ "ntfs" ];
    # tmp.cleanOnBoot = true;
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };
    bluetooth.enable = true;
  };

  # compresses half the ram for use as swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # inputMethod = {
    #   enabled = "fcitx5";
    #   fcitx5.addons = with pkgs; [
    #     fcitx5-chinese-addons
    #     fcitx5-pinyin-zhwiki
    #   ];
    # };
  };
  # Font
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      font-awesome
      twemoji-color-font
      # jetbrains-mono
      # (nerdfonts.override { fonts = [ "JetBrainsMono" "RobotoMono" ]; })
    ];
    fontconfig.defaultFonts = pkgs.lib.mkForce {
      serif = [ "Noto Serif" "Noto Serif CJK SC" ];
      sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
      monospace = [
        # "JetBrains Mono" 
        # "Noto Color Emoji" 
      ];
      emoji = [
        "Twemoji"
        # "Noto Color Emoji" 
      ];
    };

  };

  # Secure core
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.sudo.enable = false;
  # Configure doas
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "Tim" ];
      keepEnv = true;
      persist = true;
    }];
  };
  security.pam.services.swaylock = { };

  # Services
  services = {
    dbus = {
      packages = with pkgs; [ dconf udisks2 gcr ];
      enable = true;
    };

    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    # enable openssh
    openssh.enable = true;
    # To mount drives with udiskctl command
    udisks2.enable = true;
    # gnome.at-spi2-core.enable = true;

    # tlp.enable = true;     # TLP and auto-cpufreq for power management
    auto-cpufreq.enable = true;

    # For Laptop, make lid close and power buttom click to suspend
    logind = {
      lidSwitch = "suspend";
      extraConfig = ''
        HandlePowerKey = suspend
      '';
    };

    atd.enable = true;
    fstrim.enable = true;
    # See if you want bluetooth setup
    blueman.enable = true;

    # For android file transfer via usb, or better check on KDE connect 
    gvfs.enable = true;

    # This makes the user '<<my-username>>' to autologin in all tty
    # Depends on you if you want login manager or prefer entering password manually
    getty.autologinUser = "Tim";

    # Pipewire setup, just these lines enought to make sane default for it
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
    };
  };

  # Systemd
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

    # Move TMPDIR to /var/cache/nix
    nix-daemon = {
      environment = {
        # 指定临时文件的位置
        TMPDIR = "/var/cache/nix";
      };
      serviceConfig = {
        # 在 Nix Daemon 启动时自动创建 /var/cache/nix
        CacheDirectory = "nix";
      };
    };
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
    command-not-found.enable = false;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    gitFull
    neovim
    xray
    dig
    vulkan-validation-layers
  ];

  # ENV
  environment = {
    variables = rec {
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      # WLR_RENDERER = "vulkan";
      DITOR = "nvim";
      BROWSER = "firefox";
      SDL_VIDEODRIVER = "wayland";

      # Not officially in the specification
      XDG_BIN_HOME = "$HOME/.local/bin";
      PATH = [
        "${XDG_BIN_HOME}"
      ];

      NIX_REMOTE = "daemon";
    };
  };

  nix.envVars.GOPROXY = "https://goproxy.cn,direct";

  # Users
  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$6$WSLqMj/csKrhFrgF$zHtpHPOepWr18G.mL1xcfmUAGLXnzdTxidFaeM9TLdlDGZ3JoHufH3ScROtfL35dgGo.tKNO2ypPqJ4aPVtxt/";
  };
  users.users.Tim = {
    initialHashedPassword = "$6$WSLqMj/csKrhFrgF$zHtpHPOepWr18G.mL1xcfmUAGLXnzdTxidFaeM9TLdlDGZ3JoHufH3ScROtfL35dgGo.tKNO2ypPqJ4aPVtxt/";
    shell = pkgs.fish;
    isNormalUser = true;
    description = "tim";
    extraGroups = [ "adbusers" "networkmanager" "wheel" "root" ];
    packages = with pkgs; [
      ripgrep
      firefox
      systemd-run-app
    ];
  };
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Nixpkgs
  # As name implies, allows Unfree packages. You can enable in case you wanna install non-free tools (eg: some fonts lol)
  nixpkgs = {
    config = {
      # keep a check and remove it asap
      permittedInsecurePackages = [
        # "openssl-1.1.1u"
        # "electron-24.8.6"
        "electron-25.9.0"
      ];
      allowUnfree = true;
      allowBroken = false;
    };
  };

  # faster rebuilding
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };

  # Nix
  # Collect garbage and delete generation every 6 day. Will help to get some storage space.
  # Better to atleast keep it for few days, as you do major update (unstable), if something breaks you can roll back.
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 6d";
    };

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels  
    # Making legacy nix commands consistent as well, awesome!  
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    # Free up to 1GiB whenever there is less than 100MiB left.
    # extraOptions = ''
    #   # experimental-features = nix-command flakes
    #   keep-outputs = true
    #   warn-dirty = false
    #   keep-derivations = true
    #   min-free = ${toString (100 * 1024 * 1024)}
    #   max-free = ${toString (1024 * 1024 * 1024)}
    # '';

    # substituters are cachix domain, where some package binaries are available (eg : Hyprland & Emacs 30)
    # NOTE : You should do a simple rebuild with these substituters line first,
    # and then install packages from there, as a rebuild will register these cachix into /etc/nix/nix.conf file.
    # If you continue without a rebuild, Emacs will start compiling.
    # So rebuild and make sure you see these substituters in /etc/nix/nix.conf and then add packages.
    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" "auto-allocate-uids" "cgroups" ];
      auto-optimise-store = true;
      builders-use-substitutes = true;
      trusted-users = [ "root" "@wheel" ];
      max-jobs = "auto";
      # use binary cache, its not gentoo
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      # Keys for the sustituters cachix
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  system.stateVersion = "23.11";
}
