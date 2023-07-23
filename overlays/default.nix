# $ cat /tmp/overlay/local-packages.nix
final: prev: {
  # we create new 'ski' attribute here!
  sway-git = final.callPackage ./sway-git.nix {};
  wlroots-git = final.callPackage ./wlroots-git.nix {};

  # add more packages below:
  # ...
}
