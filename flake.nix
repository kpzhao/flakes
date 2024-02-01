{
  description = "Tim's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ { self, home-manager, sops-nix, nixpkgs, ... }:
    let
      # You might check on darwin for macos
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
      this = import ./pkgs;
    in
    rec {
      nixosModules = (import ./modules { inherit lib; });
      nixosConfigurations = {

        Tim = lib.nixosSystem {
          inherit system;
          modules = [

            ./host/configuration.nix
            inputs.impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            nixosModules.xray

            {
              nixpkgs.overlays = [
                this.overlay
              ];
            }

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit self;
              };

              home-manager.users.Tim = ./home;
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}


