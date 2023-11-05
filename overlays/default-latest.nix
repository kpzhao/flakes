final: prev: rec {

  wlroots_0_17 =
    (final.wlroots_0_16.overrideAttrs (old: {
      version = "unstable-2023-08-20";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "22b6581a18c7b3cf10fbbc8f94c01eeffd4293f7";
        hash = "sha256-8oLZpY0ma9ZlKs2aBTgVSdiVlMT2LcbPya3R/AMBdX8=";
      };
      patches = [
      ];

      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.hwdata ];
      buildInputs =
        (old.buildInputs or [ ])
        ++ [
          final.libdisplay-info
          final.libliftoff
        ];
    })).override { };

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

        ];

      buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
    })).override { wlroots = wlroots_0_17; };

  sway-test = prev.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };


}
