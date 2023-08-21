final: prev: rec {
  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./aur/hidpi.patch
      # ./hypr-patches/xwayland-vsync.patch
    ];
  });

  wlroots-hidpi =
    (prev.wlroots.overrideAttrs (old: {
      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "c74f89d4f84bfed0284d3908aee5d207698c70c5";
        sha256 = "sha256-LlxE3o3UzRY7APYVLGNKM30DBMcDifCRIQiMVSbYLIc=";
      };

      patches = [
        ./hypr-patches/wlroots-hidpi.patch
        # ./hypr-patches/wlroots-hidpi-2.patch
        (prev.fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/18595000f3a21502fd60bf213122859cc348f9af.diff";
          sha256 = "sha256-jvfkAMh3gzkfuoRhB4E9T5X1Hu62wgUjj4tZkJm0mrI=";
          revert = true;
        })
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
        rev = "bb91b7f5fa7fddb582b8dddf208cc335d39da9e7";
        sha256 = "sha256-bYKYHmGGemaGpDMFRt3m8yi/t5hNlx43C5l+Dm4VJGY=";
      };
      patches =
        builtins.filter (p: p.name or "" != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") oa.patches ++ [
          # ./7226.patch
        ];

      buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
    })).override { wlroots = wlroots-hidpi; };

  sway-test = prev.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };
}
