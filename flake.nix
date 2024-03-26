{
  description = "Tim's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs @ { self, home-manager, sops-nix, nixpkgs, nixpkgs-unstable, ... }:
    let
      # You might check on darwin for macos
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
                pkgs-unstable = import nixpkgs-unstable {
            # 这里递归引用了外部的 system 属性
            system = system;
            # 为了拉取 chrome 等软件包，
            # 这里我们需要允许安装非自由软件
            # config.allowUnfree = true;
                config = {
      # keep a check and remove it asap
      permittedInsecurePackages = [
        "openssl-1.1.1w"
        # "openssl-1.1.1u"
        # "electron-24.8.6"
        "electron-25.9.0"
        "freeimage-unstable-2021-11-01"
      ];
      allowUnfree = true;
      allowBroken = false;
    };

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
                inherit pkgs-unstable;
              };

              home-manager.users.Tim = ./home;
            }
          ];
          specialArgs = { 
            inherit inputs; 
            inherit pkgs-unstable;
          };
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}


