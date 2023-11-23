{
  lib,
  source,
  sway-unwrapped,
  wlroots-git,

  isNixOS ? false,
  enableXWayland ? true
}:
(sway-unwrapped.override {
  wlroots = wlroots-git;
  inherit isNixOS enableXWayland;
}).overrideAttrs (old: {
  inherit (source) src;
  version = "git-${source.date or "unknown"}";

  patches =
    lib.filter (p: p.name or "" != "LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch") old.patches ++ [
      # text_input: Implement input-method popups
      # https://github.com/swaywm/sway/pull/7226
      ./7226.patch
    ];
})
