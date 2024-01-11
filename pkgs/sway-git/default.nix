{ lib
, source
, sway-unwrapped
, wlroots-git
, fetchpatch
, isNixOS ? false
, enableXWayland ? true
}:
(sway-unwrapped.override {
  wlroots_0_16 = wlroots-git;
  inherit isNixOS enableXWayland;
}).overrideAttrs (old: {
  inherit (source) src;
  version = "git-${source.date or "unknown"}";

  patches =
    lib.filter (p: p.name or "" != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") old.patches ++ [
      # text_input: Implement input-method popups
      # https://github.com/swaywm/sway/pull/7226
      (fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/7226.patch?h=sway-im-git";
        sha256 = "sha256-RaPfLdea0CAVFWKGjweLq4N5Io7qVPUykj6oiNfh7kY=";
      })

    ];
})
