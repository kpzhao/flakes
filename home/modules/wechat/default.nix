{ config
, lib
, pkgs-unstable
, ...
}: {
  home = {
      packages = with pkgs-unstable; [
        (callPackage ../../../pkgs/wechat-uos.nix {})
    #     (pkgs.alacritty.overrideAttrs (drv: rec {
    #       name = "alacritty-git";
    #       src = fetchFromGitHub {
    #         owner = "alacritty";
    #         repo = "alacritty";
    #         rev = "a6a47257a32f75ecd9b52ae27fc8c900e27f47ea";
    #         sha256 = "sha256-MaM/y8euVlVakRoShIwWoXJheINLTA8XF0rz/jKOr9Y=";
    #       };
    #       cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
    #         name = "alacritty-git-vendor.tar.gz";
    #         inherit src;
    #         outputHash = "sha256-VErosDrq7AwLADt7O7XztECQZ3yCfGFu2ZN0298HL+Q=";
    #       });
    #
    #       rpathLibs = [
    #         expat
    #         fontconfig
    #         freetype
    #       ] ++ lib.optionals stdenv.isLinux [
    #         libGL
    #         xorg.libX11
    #         xorg.libXcursor
    #         xorg.libXi
    #         xorg.libXrandr
    #         xorg.libXxf86vm
    #         xorg.libxcb
    #         libxkbcommon
    #         wayland
    #       ];
    #       postInstall = (
    #         if stdenv.isDarwin then ''
    #           mkdir $out/Applications
    #           cp -r extra/osx/Alacritty.app $out/Applications
    #           ln -s $out/bin $out/Applications/Alacritty.app/Contents/MacOS
    #         '' else ''
    #           install -D extra/linux/Alacritty.desktop -t $out/share/applications/
    #           install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
    #           install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
    #
    #           # patchelf generates an ELF that binutils' "strip" doesn't like:
    #           #    strip: not enough room for program headers, try linking with -N
    #           # As a workaround, strip manually before running patchelf.
    #           $STRIP -S $out/bin/alacritty
    #
    #           patchelf --add-rpath "${lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
    #         ''
    #       ) + ''
    #
    #   installShellCompletion --fish extra/completions/alacritty.fish
    #
    #
    #
    #   install -dm 755 "$terminfo/share/terminfo/a/"
    #   tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
    #   mkdir -p $out/nix-support
    #   echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    # '';
    #     }))
      ];
  };
}
