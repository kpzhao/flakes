 { ... }:
 
 (final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (self:
    {
      patches = self.patches or [ ] ++ [
        ./7226.patch
      ];
    });
})
