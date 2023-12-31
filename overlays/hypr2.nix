final: prev: rec {
  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./patches/xwayland/hidpi.patch
    ];
  });

  wlroots-hidpi =
    (prev.wlroots.overrideAttrs (old: {
      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "f5917f0247600b65edec1735234d00de57d577a8";
        sha256 = "sha256-9b+Zm7loehTAuqCm0qwcbPjXc1U51tplcPLCWqqstxQ=";
      };

      patches = [
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/18595000f3a21502fd60bf213122859cc348f9af.diff";
          sha256 = "sha256-jvfkAMh3gzkfuoRhB4E9T5X1Hu62wgUjj4tZkJm0mrI=";
          revert = true;
        })
        ./patches/wlroots/0001-xwayland-support-HiDPI-scale.patch
        ./patches/wlroots/0002-Fix-configure_notify-event.patch
        ./patches/wlroots/0003-Fix-size-hints-under-Xwayland-scaling.patch
      ];
      mesonFlags = [
        "-Dwerror=false"
        # "-Dexamples=false"
      ];
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
      buildInputs =
        (old.buildInputs or [ ])
        ++ [
          final.libdisplay-info
          final.libliftoff
        ];
    })).override { inherit xwayland; };

  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (oa: {
      src = prev.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "89f85312687b7fd1777c936e169e6400cee0a4b4";
        sha256 = "sha256-JK/qBwcIRPrjWsnIlpF6sNsO4GUkCsq1JNa/0XGi//o=";
      };
      patches =
        builtins.filter (p: p.name or "" != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") oa.patches ++ [
          ./patches/sway/7226.patch
        ];

      buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
    })).override { wlroots = wlroots-hidpi; };

  sway-test = prev.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };
}
