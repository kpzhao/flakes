final: prev: rec {
  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./xwayland-hidpi.patch
    ];
  });

  wlroots_0_17 =
    (final.wlroots_0_16.overrideAttrs (old: {
      version = "unstable-2023-06-03";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "d40bcfe2c18f057f4bc324a81230f6ba2267db44"; # 20230729
        hash = "sha256-6MEVZCCwmNjKgMGDBIF2J2748vJEcEOaifLycXamvz0="; #20230729
      };

      patches = [
        ./wlroots-0001-xwayland-support-HiDPI-scale.patch
        ./wlroots-0002-Fix-configure_notify-event.patch
      ];

      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.hwdata];
      buildInputs =
        (old.buildInputs or [])
        ++ [
          final.libdisplay-info
          final.libliftoff
        ];
    }))
    .override {};

  sway-test =
    (prev.sway-unwrapped.overrideAttrs (old: {
      version = "test";
      src = final.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "c3e6390073167bae8245d7fac9b455f9f06a5333";
        sha256 = "sha256-QQOVim0U8uiAstPy9HMRBAl4McyvAdXoO44jCRlzVIQ=";
      };

      patch = [
      ];

      nativeBuildInputs = with final; (old.nativeBuildInputs or []) ++ [];

      # Our version of sway already has this patch upstream, so we filter it out.
      patches =
        builtins.filter
        (p: !p ? name || (p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch"))
        (old.patches or []);
    }))
    .override {wlroots = final.wlroots_0_17;};
}
