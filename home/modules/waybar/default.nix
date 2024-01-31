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
        "spacing" = 1;
        "modules-left" = [ "sway/workspaces" "idle_inhibitor" "sway/mode" "sway/window" ];
        #"modules-center"= [""];
        "modules-right" = [ "wireplumber" "network" "battery" "backlight" "clock" "tray" ];
        "backlight" = {
          "device" = "intel_backlight";
          "on-scroll-up" = "light -A 5";
          "on-scroll-down" = "light -U 5";
          "format" = "{icon} {percent}%";
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
          "format-muted" = " Muted";
        };
      }
    ];
    style = builtins.readFile ./waybar.css;

  };
}
