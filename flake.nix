{
  description = "Tim's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:kpzhao/home-manager/alacritty-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";
  };
  outputs = { self, nixpkgs, nix-colors,  ... }@inputs:
    let
      this = import ./pkgs;
      overlay-sway = import ./overlays;
      pkgs = import nixpkgs { };
      nixosModules = import ./home-manager;
      mkSystem = name: system: nixpkgs: { extraModules ? [ ] }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inputs = inputs;
          # inputs = inputs // { inherit nixpkgs; };
          inherit nix-colors;
        };
        modules = with nixosModules; [
          {
            nixpkgs.overlays = [
              this.overlay
              overlay-sway
            ];
          }
          ./host/configuration.nix
          inputs.impermanence.nixosModules.impermanence
        ] ++ extraModules;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        Tim = mkSystem "Tim" "x86_64-linux" inputs.nixpkgs {
          extraModules = with nixosModules; [ home-manager ];
        };
      };
    };
}
