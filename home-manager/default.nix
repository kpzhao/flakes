rec {
        home-manager = { config, inputs, nix-colors, ... }: {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            verbose = true;
            extraSpecialArgs = {
              inherit inputs nix-colors; 
              super = config;
            };
          };
        };
}
