{
      description = "Tim's NixOS configuration";
      input = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
        flake-utils.url = "github:numtide/flake-utils";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";
        impermanence.url = "github:nix-community/impermanence";
      };
      outputs = { self, nixpkgs, flake-utils, ... }@inputs: let
        inherit (nixpkgs) lib;
        nixosModules = {
            home-manager = { config, inputs, my, ... }: {
                imports = [ inputs.home-manager.nixosModules.home-manager ];
                home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    verbose = true;
                    extraSpecialArgs = {
                    inherit inputs my;
                    super = config;
                    };
                };
            };
        };
        mkSystem = name: system: nixpkgs: { extraModules ? [] }: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
                inputs = inputs // { inherit nixpkgs; };
                my = import ./my // {
                pkgs = self.packages.${system};
                };
            };
            modules = with nixosModules; [
                system-label
                { networking.hostName = lib.mkDefault name; }
                { nixpkgs.overlays = builtins.attrValues overlays; }
                ./host/configuration.nix
                ./persistence.nix
                 inputs.impermanence.nixosModules.impermanence
            ] ++ extraModules;
        };
      in {
        inherit overlays nixosModules;
        nixosConfigurations = {
            Tim = mkSystem "Tim" "x86_64-linux" inputs.nixpkgs {
                extraModules = with nixosModules; [ home-manager ];
            };
        };
      } // flake-utils.lib.eachDefaultSystem (system: rec {
            packages = import ./pkgs {
                inherit lib inputs;
                pkgs = nixpkgs.legacyPackages.${system};
            };

            checks = packages;

            devShells.default =
            with nixpkgs.legacyPackages.${system};
            mkShellNoCC {
                packages = [ nvfetcher packages.nixos-rebuild-shortcut ];
            };
        });
}
