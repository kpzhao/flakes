{ lib, pkgs, config, my, ... }:

let
  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";

  terminal = "${pkgs.alacritty}/bin/alacritty";

  sway = config.wayland.windowManager.sway.package;

  # app = cmd: "${lib.getExe my.pkgs.systemd-run-app} ${cmd}";

in
{
  home.packages = with pkgs; [
    # my.pkgs.systemd-run-app
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "Arc-Dark";
    extraConfig = { };
  };
}
