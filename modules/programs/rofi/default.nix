{
  lib,
  config,
  pkgs,
  ...
}: 
let
  # app = cmd: "${lib.getExe my.pkgs.systemd-run-app} ${cmd}";

in
{
  # home = {
  #   packages = with pkgs; [
  #     rofi-wayland
  #   ];
  # };
  # # We will tangle config files from git repo to home dir (Let nix manage the magics)
  #
  # home.file.".config/rofi/config.rasi".source = ./config.rasi;
  # home.file.".config/rofi/catppuccin-frappe.rasi".source = ./catppuccin-frappe.rasi;
      programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "Arc-Dark";
    # terminal = app "${terminal}";
    extraConfig = {
      # modi = "drun,run,ssh";
      # run-command = app "{cmd}";
    };
  };

}
