{
    description = "NixOS configuration";

# nixConfig = {
#     extra-experimental-features = [ "nix-command" "flakes" ];
# };

    inputs = {

        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nur.url = "github:nix-community/NUR";

# overlays
        nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

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

    outputs =
        inputs@{ self
            , nixpkgs
                ,home-manager
                ,base16
                ,nur
                , ...
        }: 
    let system = "x86_64-linux";
    nixpkgs.overlays = [
    (import /tmp/overlay/local-packages.nix)
    ];

    in {

        # devsShell = {
        #     default = pkgs.mkShell {
        #         nativeBuildInputs = with pkgs; [
        #             git
        #                 neovim
        #                 sbctl
        #                 wlroots
        #         ];
        #     };
        # };

        nixosConfigurations = {
            test = nixpkgs.lib.nixosSystem {
                inherit system;
                inherit pkgs;


                modules = [
                    ./host/configuration.nix
                        ./host/hardware-configuration.nix
                        ./persistence.nix

                        inputs.impermanence.nixosModules.impermanence

                        base16.nixosModule
                        { scheme = "${inputs.base16-schemes}/nord.yaml"; }
                ./theming.nix				

                    ({ ... }: {
                     environment.systemPackages =
                     [
                     # pkgs.xwayland
                     # pkgs.sway-1
                     # pkgs.wlroots-hidpi
                     ski

                     ];
                     nix.settings.substituters = [
                     "https://mirror.sjtu.edu.cn/nix-channels/store"
                     ];
                     nix.settings.trusted-public-keys = [
                     ];
                     })

                nur.nixosModules.nur

                    ({ config, ... }: {
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
    };
}
