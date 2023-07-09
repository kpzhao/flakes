{ config, pkgs, ... }:
{
	home = {
		packages = with pkgs; [
			rofi-wayland
		];
	};
# We will tangle config files from git repo to home dir (Let nix manage the magics)

	home.file.".config/rofi/config.rasi".source = ./config.rasi;
	home.file.".config/rofi/catppuccin-frappe.rasi".source =  ./catppuccin-frappe.rasi;
}
