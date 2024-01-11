{
  xwayland,
  fetchpatch,
}:
xwayland.overrideAttrs (old: {
  patches = [
    (fetchpatch {
      url ="https://aur.archlinux.org/cgit/aur.git/plain/hidpi.patch?h=xorg-xwayland-hidpi-xprop";
      sha256 = "sha256-caRAJPTfi9FKfmVnxYjYCpkgN5p4BXyomtxao9b3omc=";
    })
  ];
})
