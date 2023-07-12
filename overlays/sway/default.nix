 { ... }:
 
 (final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (self:
    {
      patches = self.patches or [ ] ++ [
        ./7227.patch
      ];
    });
})
