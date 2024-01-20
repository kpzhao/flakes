{ ... }:
{
  config.home.stateVersion = "23.11";
  config.programs.home-manager.enable = true;
  config.home.extraOutputsToInstall = [ "doc" "devdoc" ];
  imports = [
    ./home.nix
    # inputs.hyprland.homeManagerModules.default
    # inputs.nur.nixosModules.nur
  ];
}
