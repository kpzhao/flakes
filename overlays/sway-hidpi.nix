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
      };

      patches = [
      ./0001-xwayland-support-HiDPI-scale.patch
      ./0002-Fix-configure_notify-event.patch
      ];
    })).override { inherit xwayland; };

  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (oa: {
      src = prev.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
      };

      buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
    })).override { wlroots = wlroots-hidpi; };

  sway-1 = prev.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };
})
];
}
