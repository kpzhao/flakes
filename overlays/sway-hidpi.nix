{ config, pkgs, lib, ... }:

{
    nixpkgs.overlays = [
(final: prev: rec {
  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      # ./xwayland-vsync.patch
      # ./xwayland-hidpi.patch
      ./hidpi.patch
    ];
  });
  wlroots-hidpi =
    (prev.wlroots.overrideAttrs (_: {
      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "7791ffe0";
        sha256 = "sha256-3RTOlQabkNetQ4O4UzSf57JPco9VGVHhSU1ls5uKBeE=";
      };

      patches = [
      ./0001-xwayland-support-HiDPI-scale.patch
      ./0002-Fix-configure_notify-event.patch
      ];
    })).override { inherit xwayland; };

  sway-2 =
    (prev.sway-unwrapped.overrideAttrs (oa: {
      src = prev.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "a34d785a26c9180de62530593b6693ca4c0b3615";
        sha256 = "sha256-w9Aq+h1p2cssDTskXmNa3wGXSxDWthRm179II5U+gpg=";
      };

      # buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
    })).override { wlroots = wlroots-hidpi; };

  sway-1 = prev.sway.override {
    inherit sway-2;
    withGtkWrapper = true;
  };
})
];
}
