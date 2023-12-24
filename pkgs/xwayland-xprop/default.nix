{
  xwayland,
}:
xwayland.overrideAttrs (old: {
  patches = [
  ./hidpi.patch
  ];
})
