{ config
, lib
, pkgs
, ...
}: {
  imports = [
    ./swayidle.nix
    ./swaybg.nix
  ];
  home = {
    packages = with pkgs; [
      foot
      swaybg
      swayidle
      swaylock-effects
      pamixer
      waybar
      alacritty
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
    # systemd = {
    #   enable = true;
    #   xdgAutostart = true;
    # };
    wrapperFeatures.gtk = true;
    config = {
      window.titlebar = false;

      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        # {command = "kitty";}
        { command = "firefox"; }
        { command = "mako"; }
        # {command = "xprop -root -format _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2";}
        # {command = "xrdb -merge <<< 'Xft.dpi: 192'";}
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
