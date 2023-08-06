final: prev: rec {
  xwayland = prev.xwayland.overrideAttrs (_: {
    patches = [
      ./xwayland-hidpi.patch
    ];
  });

  wlroots_0_17 =
    (final.wlroots_0_16.overrideAttrs (old: {
      version = "unstable-2023-07-28";
      src = final.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = "c74f89d4f84bfed0284d3908aee5d207698c70c5";
        hash = "sha256-bYKYHmGGemaGpDMFRt3m8yi/t5hNlx43C5l+Dm4VJGY=";
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

  # sway-test =
  #   (prev.sway-unwrapped.overrideAttrs (old: {
  #     version = "scene-graph-2023-07-24";
  #     src = final.fetchFromGitHub {
  #       owner = "Nefsen402";
  #       repo = "sway";
  #       rev = "ba347c525a50a5aa9639ab33de93551fb8e296b7";
  #       hash = "sha256-8Omt2xfe2NY70Mt0MN2jIvhng3A1t0hD8XAIL3VGx64=";
  #     };
  #     patch = [
  #     ];
  #
  #     nativeBuildInputs = with final; (old.nativeBuildInputs or []) ++ [bash-completion fish];
  #
  #     # Our version of sway already has this patch upstream, so we filter it out.
  #       patches =
  #       builtins.filter (p: p.name or "" != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") old.patches ++ [
  #     # text_input: Implement input-method popups
  #    ./7226.patch 
  #   ];
  #     # patches =
  #     #   builtins.filter
  #     #   (p: !p ? name || p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch")
  #     #   (old.patches or []);
  #   }))
  #   .override {wlroots = final.wlroots_0_17;};
  #
  sway-test =
    (prev.sway-unwrapped.overrideAttrs (old: {
      version = "test";
      src = final.fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "bb91b7f5fa7fddb582b8dddf208cc335d39da9e7";
        sha256 = "";
      };

      # patch = [
      # ./7226.patch
      # ];

      nativeBuildInputs = with final; (old.nativeBuildInputs or []) ++ [];

      # Our version of sway already has this patch upstream, so we filter it out.
      patches =
        builtins.filter
        (p: !p ? name || (p.name != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch"))
        (old.patches or []);
    }))
    .override {wlroots = final.wlroots_0_17;};
}
