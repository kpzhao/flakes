# $ cat /tmp/overlay/local-packages.nix
final: prev: {
  # we create new 'ski' attribute here!
  ski2 = final.callPackage ./ski {};

  # add more packages below:
  # ...
}
