{ lib, pkgs, config, my, ... }:
let
  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";

  terminal = "${pkgs.alacritty}/bin/alacritty";

  sway = config.wayland.windowManager.sway.package;

  app = cmd: "${lib.getExe my.pkgs.systemd-run-app} ${cmd}";

in
{
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        # theme = "Arc-Dark";
        terminal = app "${terminal}";
        extraConfig = {
            modi = "drun,run,ssh";
            run-command = app "{cmd}";
        };
    };
}
