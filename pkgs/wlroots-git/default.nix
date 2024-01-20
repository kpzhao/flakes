{ source
, wlroots_0_16
, hwdata
, libdisplay-info
, fetchpatch
, fetchurl
, libdrm
, xwayland-xprop
, enableXWayland ? true
,
}:
let
  # NOTE: remove after https://github.com/NixOS/nixpkgs/pull/271096 reaches nixos-unstable
  # libdrm_2_4_118 = libdrm.overrideAttrs(old: rec {
  #   version = "2.4.118";
  #   src = fetchurl {
  #     url = "https://dri.freedesktop.org/${old.pname}/${old.pname}-${version}.tar.xz";
  #     hash = "sha256-p3e9hfK1/JxX+IbIIFgwBXgxfK/bx30Kdp1+mpVnq4g=";
  #   };
  # });
in
(wlroots_0_16.override {
  inherit enableXWayland;
  xwayland = xwayland-xprop;
}).overrideAttrs (old: {
  inherit (source) src;
  version = "git-${source.date}";
  patches = [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/18595000f3a21502fd60bf213122859cc348f9af.diff";
      sha256 = "sha256-jvfkAMh3gzkfuoRhB4E9T5X1Hu62wgUjj4tZkJm0mrI=";
      revert = true;
    })
    ./0001-xwayland-support-HiDPI-scale.patch
    ./0002-Fix-configure_notify-event.patch
    ./0003-Fix-size-hints-under-Xwayland-scaling.patch
  ];
  nativeBuildInputs = old.nativeBuildInputs or [ ] ++ [
    hwdata
    libdrm
  ];
  buildInputs = [
    #libdrm_2_4_118
  ] ++ old.buildInputs ++ [
    libdisplay-info
    hwdata
  ];
})
