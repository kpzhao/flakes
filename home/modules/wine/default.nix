{ config
, lib
, pkgs-unstable
, ...
}: {
  home = {
      packages = with pkgs-unstable; [
        # wine64
        # wineWowPackages.staging
        # winetricks
        wineWowPackages.waylandFull
      ];
  };
}
