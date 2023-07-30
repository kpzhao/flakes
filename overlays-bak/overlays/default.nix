final: prev: rec {
  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./hidpi.patch
    ];
  });

  wlroots_0_17 =
    (final.wlroots_0_16.overrideAttrs (old: {
      version = "unstable-2023-06-03";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "71b57b8d27e2817ebcaa6471e22251203c370554";
        hash = "sha256-yYFlQsHD/TU0l6pS0t9tSHh7w+LFAUclJMpSyiA+Wnw=";
      };

      patches = [
        ./0001-xwayland-support-HiDPI-scale.patch
        ./0002-Fix-configure_notify-event.patch
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

  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (old: {
      version = "test";
      src = final.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "68d620a";
        hash = "sha256-gRAkreCYLwvCNPM1HCx0iKoFlUsxXL/XkN7RNUMTIXM=";
      };

      nativeBuildInputs = with final; (old.nativeBuildInputs or []) ++ [bash-completion fish];

      # Our version of sway already has this patch upstream, so we filter it out.
      patches =
        builtins.filter
        (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
        (old.patches or []);
    }))
    .override {wlroots = final.wlroots_0_17;};
}
