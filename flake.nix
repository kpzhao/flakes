{
  description = "NixOS configuration";

  # nixConfig = {
  #     extra-experimental-features = [ "nix-command" "flakes" ];
  # };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    # theme
    base16.url = github:SenchoPens/base16.nix;

    base16-schemes = {
      url = github:base16-project/base16-schemes;
      flake = false;
    };
    base16-zathura = {
      url = github:haozeke/base16-zathura;
      flake = false;
    };
    base16-vim = {
      url = github:base16-project/base16-vim;
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    base16,
    nur,
    ...
  }: let
    user = "Tim";
    system = "x86_64-linux";
    overlay = ./overlays;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (import overlay)
      ];
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      test = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;

        modules = [
          #                 {
          #   nixpkgs.overlays = [
          #     (import ./overlays)
          #   ];
          # }
          ./host/configuration.nix
          ./host/hardware-configuration.nix
          ./persistence.nix

          inputs.impermanence.nixosModules.impermanence

          base16.nixosModule
          {scheme = "${inputs.base16-schemes}/nord.yaml";}
          ./theming.nix

          ({...}: {
            environment.systemPackages = [
            ];
            nix.settings.substituters = [
              "https://mirror.sjtu.edu.cn/nix-channels/store"
            ];
            nix.settings.trusted-public-keys = [
            ];
          })

          nur.nixosModules.nur

          ({config, ...}: {
            environment.systemPackages = [
              config.nur.repos.YisuiMilena.hyfetch
            ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.Tim = import ./home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
