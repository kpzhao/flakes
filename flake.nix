{
  description = "Tim's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    # For Adblocking and making internet usable
    hosts.url = "github:StevenBlack/hosts";
  };

  outputs = inputs @ { self, hosts, home-manager, nix-colors, nixpkgs, ... }:
    let
      # You might check on darwin for macos
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      this = import ./pkgs;
      overlay-sway = import ./overlays;
    in
    {

      nixosConfigurations = {

        Tim = lib.nixosSystem {
          inherit system;
          modules = [

            ./host/configuration.nix
            inputs.impermanence.nixosModules.impermanence
            # ./home-manager/default.nix

            {
              nixpkgs.overlays = [
                this.overlay
                # overlay-sway
              ];
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit self;
                inherit nix-colors;
              };

              home-manager.users.Tim = ./home;
            }
            hosts.nixosModule
          ];
          specialArgs = { inherit inputs; };
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}


