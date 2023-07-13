 { ... }:

(final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./7226.patch
    ];
  });
})
