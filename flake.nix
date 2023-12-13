{
  description = "Tim's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    # For Adblocking and making internet usable
    hosts.url = "github:StevenBlack/hosts";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ { self, hosts, home-manager, nix-colors, sops-nix, nixpkgs, ... }:
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
    {

      nixosConfigurations = {

        Tim = lib.nixosSystem {
          inherit system;
          modules = [

            ./host/configuration.nix
            inputs.impermanence.nixosModules.impermanence
            # ./home-manager/default.nix
            sops-nix.nixosModules.sops

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


