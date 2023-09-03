{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./swayidle.nix
    ./swaybg.nix
  ];
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      foot
      swaybg
      swayidle
      swaylock-effects
      pamixer
      waybar
      # alacritty
  #       (pkgs.alacritty.overrideAttrs (drv: rec {
  #   name = "alacritty-git";
  #   src =  fetchFromGitHub {
  #       owner = "alacritty";
  #       repo = "alacritty";
  #       rev = "a6a47257a32f75ecd9b52ae27fc8c900e27f47ea";
  #       sha256 = "sha256-MaM/y8euVlVakRoShIwWoXJheINLTA8XF0rz/jKOr9Y=";
  #     };
  #   cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
  #       name = "alacritty-git-vendor.tar.gz";
  #       inherit src;
  #       outputHash = "sha256-VErosDrq7AwLADt7O7XztECQZ3yCfGFu2ZN0298HL+Q=";
  #   });
  #
  #     rpathLibs = [
  #   expat
  #   fontconfig
  #   freetype
  # ] ++ lib.optionals stdenv.isLinux [
  #   libGL
  #   xorg.libX11
  #   xorg.libXcursor
  #   xorg.libXi
  #   xorg.libXrandr
  #   xorg.libXxf86vm
  #   xorg.libxcb
  #   libxkbcommon
  #   wayland
  # ];
  #     postInstall = (
  #   if stdenv.isDarwin then ''
  #     mkdir $out/Applications
  #     cp -r extra/osx/Alacritty.app $out/Applications
  #     ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS
  #   '' else ''
  #     install -D extra/linux/Alacritty.desktop -t $out/share/applications/
  #     install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
  #     install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
  #
  #     # patchelf generates an ELF that binutils' "strip" doesn't like:
  #     #    strip: not enough room for program headers, try linking with -N
  #     # As a workaround, strip manually before running patchelf.
  #     $STRIP -S $out/bin/alacritty
  #
  #     patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  #   ''
  # ) + ''
  #
  #   installShellCompletion --zsh extra/completions/_alacritty
  #   installShellCompletion --bash extra/completions/alacritty.bash
  #   installShellCompletion --fish extra/completions/alacritty.fish
  #
  #
  #
  #   install -dm 755 "$terminfo/share/terminfo/a/"
  #   tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
  #   mkdir -p $out/nix-support
  #   echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  # '';
  # }))
      rofi-wayland
      xfce.thunar
    ];
  };

  systemd.user = {
    targets.sway-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    # package = pkgs.sway-git;
    # package = pkgs.sway-unwrapped;
    package = pkgs.sway-test;
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
    wrapperFeatures.gtk = true;
    config = {
      window.titlebar = false;

      modifier = "Mod4";
      terminal = "foot";
      startup = [
        # {command = "kitty";}
        { command = "firefox"; }
        { command = "mako"; }
        { command = "xprop -root -format _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2"; }
        { command = "xrdb -merge <<< 'Xft.dpi: 192'"; }
      ];
      assigns = {
        "1" = [{ app_id = "firefox"; }];
        "2" = [{ app_id = "Alacritty"; }];
      };
      gaps = {
        inner = 5;
        outer = 5;
        smartGaps = true;
      };
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
          # volume
          volume_raise = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
          volume_lower = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0";
          # audio
          audio_mute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          audio_mic_mute = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          audio_play = "exec playerctl play-pause";
          audio_next = "exec playerctl next";
          audio_prev = "exec playerctl previous";
          # bright
          bright_down = "exec brightnessctl set 5%-";
          bright_up = "exec brightnessctl set +5%";
        in
        lib.mkOptionDefault {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+s" = "layout stacking";
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          # "${modifier}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show run -run-command '{cmd}'";
          "${modifier}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show run -run-command 'systemd-run-app {cmd}'";

          "${modifier}+Shift+l" = "exec loginctl lock-session";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";

          # volume
          "XF86AudioRaiseVolume" = "${volume_raise}";
          "XF86AudioLowerVolume" = "${volume_lower}";
          "XF86AudioMute" = "${audio_mute}";
          "XF86AudioMicMute" = "${audio_mic_mute}";
          "XF86MonBrightnessDown" = "${bright_down}";
          "XF86MonBrightnessUp" = "${bright_up}";
          "XF86AudioPlay" = "${audio_play}";
          "XF86AudioNext" = "${audio_next}";
          "XF86AudioPrev" = "${audio_prev}";

          #Screenshots:
          # select area
          "Ctrl+Print" = "exec grimshot copy area";
          "Ctrl+Shift+Print" = "exec grimshot save area - |swappy -f -";
          # current output
          "Print" = "exec grimshot copy output";
          "Shift+Print" = "exec grimshot save output - |swappy -f -";
          # select window
          "Ctrl+${modifier}+Print" = "exec grimshot copy window";
          "Ctrl+${modifier}+Shift+Print" = "exec grimshot save window - |swappy -f -";
          # current window
          "${modifier}+Print" = "exec grimshot copy active";
          "${modifier}+Shift+Print" = "exec grimshot save active - |swappy -f -";

          # OCR
          "${modifier}+o" = "exec grim -g slurp - | tesseract stdin stdout -l eng+chi_sim+jpn -c preserve_interword_spaces=1 | tee >(wl-copy)";
        };
      input = {
        "1118:2496:Microsoft_Surface_Type_Cover_Touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      output = {
        eDP-1 = {
          pos = "0 0";
          res = "2736x1824";
          scale = "2";
        };
      };
      bars = [ ];
    };
  };
}
