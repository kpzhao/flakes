{ ... }:
{
  config.home.stateVersion = "24.05";
  config.home.extraOutputsToInstall = ["doc" "devdoc"];
  imports = [
    ./home.nix
    # inputs.hyprland.homeManagerModules.default
    # inputs.nur.nixosModules.nur
  ];
}
