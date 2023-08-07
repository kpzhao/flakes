{
  description = "Tim's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";

  };
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      this = import ./pkgs;
      overlay-sway = ./overlays;
      overlays.default = this.overlay;
      inherit (nixpkgs) lib;
      pkgs = import nixpkgs { };
      nixosModules = {
        home-manager = { config, inputs, ... }: {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            verbose = true;
            extraSpecialArgs = {
              inherit inputs;
              super = config;
            };
          };
        };
      };
      mkSystem = name: system: nixpkgs: { extraModules ? [ ] }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inputs = inputs // { inherit nixpkgs; };
        };
        modules = with nixosModules; [
          {
            nixpkgs.overlays = [
              this.overlay
              # (import overlay-sway)
            ];
          }
          ./host/configuration.nix
          ./persistence.nix
          inputs.impermanence.nixosModules.impermanence
        ] ++ extraModules;
      };
    in
    {
      inherit nixosModules;
      nixosConfigurations = {
        Tim = mkSystem "Tim" "x86_64-linux" inputs.nixpkgs {
          extraModules = with nixosModules; [ home-manager ];
        };
      };
    } // flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              this.overlay
            ];
          };
        in
        {
          formatter = pkgs.nixpkgs-fmt;
          packages = this.packages pkgs;
          legacyPackages = pkgs;
        }
      );
}
