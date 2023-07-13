 { ... }:

(final: prev: {
  sway = prev.sway.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./7226.patch
    ];
  });
})
