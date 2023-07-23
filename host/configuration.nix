# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, helix, ... } @ args:

{
    nix.settings.experimental-features = [ "nix-command" "flakes" "ca-derivations" "auto-allocate-uids" "cgroups" ];

    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        # ../overlays/sway-hidpi.nix
# ../pkgs/fcitx5-pinyin-zhwiki
        ];

    # nixpkgs.overlays = import ../overlays args;
    # nixpkgs.overlays = import ../overlays/sway;

# Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
# do not need to keep too much generations
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelParams = [ "i915.enable_psr=0" ];

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
# networking.proxy.default = "http://user:password@proxy:port/";
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



# Enable the X11 windowing system.
# services.xserver.enable = true;

    users.defaultUserShell = pkgs.fish;

# Enable sound.
# hardware.pulseaudio.enable = true;
# Remove sound.enable or turn it off if you had it set previously, it seems to cause conflicts with pipewire
#sound.enable = false;

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

    users.users.root.initialPassword = "zhao";
    users.users.Tim.initialPassword = "zhao";
    users.users.Tim = {
        isNormalUser = true;
        description = "tim";
        extraGroups = [ "adbusers" "networkmanager" "wheel" "root" ];
        packages = with pkgs; [
            firefox
        ];
        shell = pkgs.fish;
    };
    programs.fish.enable = true;

    environment.sessionVariables = rec {
        MOZ_ENABLE_WAYLAND = "1";
        GLFW_IM_MODULE = "fcitx";
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
        INPUT_METHOD = "fcitx";
        IMSETTINGS_MODULE = "fcitx";



# Not officially in the specification
        XDG_BIN_HOME    = "$HOME/.local/bin";
        PATH = [ 
            "${XDG_BIN_HOME}"
        ];
    };

# Define a user account. Don't forget to set a password with ‘passwd’.
# users.users.alice = {
#   isNormalUser = true;
#   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
#   packages = with pkgs; [
#     firefox
#     tree
#   ];
# };

    programs.adb.enable = true;
# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [
        cmake
        hwdata
        neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
            git
            neofetch
            element-desktop
            firefox
            gcc
            llvmPackages_16.libllvm
            gnumake
            p7zip
            # sway-1

    ];

    security.polkit.enable = true;
    security.sudo.extraRules = [ 
    { users = [ "Tim" "database" ]; groups = [ 1006 ];
        commands = [ { command = "/home/root/secret.sh"; options = [ "SETENV" "NOPASSWD" ]; } ]; }
    ];
    security.pam.services.swaylock = { };
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    };
    programs ={
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
            wantedBy = ["multi-user.target"];
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

