final: prev: rec {

  wlroots_0_17 =
    (final.wlroots_0_16.overrideAttrs (old: {
      version = "unstable-2023-07-28";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "bdc34401ba8e4a59b3464c17fa5acf43ca417e57";
        hash = "";
      };
      patches = [
      ];

      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.hwdata];
      buildInputs =
        (old.buildInputs or [])
        ++ [
          final.libdisplay-info
          final.libliftoff
        ];
    })).override {};

  sway-unwrapped =
    (prev.sway-unwrapped.overrideAttrs (oa: {
      src = prev.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "bb91b7f5fa7fddb582b8dddf208cc335d39da9e7";
        sha256 = "";
      };
      patches =
        builtins.filter (p: p.name or "" != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") oa.patches ++ [
          
        ];

      buildInputs = oa.buildInputs ++ [ prev.pcre2 prev.xorg.xcbutilwm ];
    })).override { wlroots = wlroots-hidpi; };

  sway-test = prev.sway.override {
    inherit sway-unwrapped;
    withGtkWrapper = true;
  };


}
