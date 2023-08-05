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
      };
      outputs = { self, nixpkgs, ... }@inputs: let
        inherit (nixpkgs) lib;
        nixosModules = {
            # home-manager = { config, inputs, my, ... }: {
            #     imports = [ inputs.home-manager.nixosmodules.home-manager ];
            #     home-manager = {
            #         useGlobalPkgs = true;
            #         useUserPackages = true;
            #         verbose = true;
            #         extraSpecialArgs = {
            #         inherit inputs my;
            #         super = config;
            #         };
            #     };
            # };
        };
        mkSystem = name: system: nixpkgs: { extraModules ? [] }: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
                inputs = inputs // { inherit nixpkgs; };
                # my = import ./my // {
                # pkgs = self.packages.${system};
                # };
            };
            modules = with nixosModules; [
                ./host/configuration.nix
                ./persistence.nix
                 inputs.impermanence.nixosModules.impermanence
            ] ++ extraModules;
        };
      in {
        inherit nixosModules;
        nixosConfigurations = {
            Tim = mkSystem "Tim" "x86_64-linux" inputs.nixpkgs {
                extraModules = with nixosModules; [ /* home-manager */ ];
            };
        };
      };
}
