{ config
, lib
, pkgs
, user
, ...
}: {
  programs.waybar = {
    package = pkgs.waybar.override {
      hyprlandSupport = false;
    };
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    settings = [
      {
        #"spacing" = 4;
        "modules-left" = [ "sway/workspaces" "idle_inhibitor" "sway/mode" "sway/window" ];
        #"modules-center"= [""];
        "modules-right" = [ "wireplumber" "network" "battery" "backlight" "clock" "tray" ];
        "backlight" = {
          "format" = "{percent}% {icon}";
          "format-icons" = [ "" "" ];
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon} ";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-icons" = [ "" "" "" "" "" ];
        };
        "clock" = {
          "timezone" = "Asia/Shanghai";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "";
          "format-disconnected" = "⚠";
          "format-alt" = "{ifname}= {ipaddr}/{cidr}";
        };
        "sway/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
        };
        "sway/workspaces" = {
          "disable-scroll" = true;
          "all-outputs" = false;
          "format" = "{name}";
        };
        "sway/window" = {
          "format" = "{title}";
          "max-length" = 50;
          "rewrite" = {
            "(.*) - Mozilla Firefox" = "🌎 $1";
            "(.*) - vim" = " $1";
            "(.*) - zsh" = " [$1]";
          };
        };
        "tray" = {
          "icon-size" = 18;
          "spacing" = 4;
        };
        "wireplumber" = {
          "format" = "{volume}%";
          "format-muted" = "";
        };
      }
    ];

    # style = ''
    #               * {
    #   border: none;
    #           border-radius: 0;
    #           font-family: Noto Sans CJK SC;
    #           font-size: 13px;
    #           text-shadow: none;
    #           box-shadow:    none;
    #           transition-duration: 0s;
    #   color: #c0caf5;
    #               }
    #
    #           window {
    #               font-weight:    bold;
    #   color:          #D8DEE9;
    #   background:     #666666;
    #           }
    #
    #   #workspaces button {
    #   padding: 0 5px;
    #   background: #1a1b26;
    #   min-width: 0;
    #   }
    #
    #   #workspaces button.visible {
    #   background: #414868;
    #   }
    #
    #   #workspaces button.focused {
    #   background: #414868;
    #   }
    #
    #   #pulseaudio, #cpu, #network, #clock, #battery{
    #   padding: 0px 10px;
    #   }
    #
    #   #network{
    #   }
    #
    #   #network.disconnected {
    #   color: red;
    #   }
    #
    #   #battery {
    #   color: #c0caf5;
    #   }
    #
    #   #battery.critical {
    #   color: red;
    #   }
    #
    #   #battery.good {
    #   color: #c0caf5;
    #   }
    #
    #   #battery.charging {
    #   color: #c0caf5;
    #   }
    # '';
  };
}
