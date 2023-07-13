 { ... }:
 
 (final: prev: {
  sway = prev.sway.overrideAttrs (self:
    {
      patches = self.patches or [ ] ++ [
        ./7226.patch
      ];
    });
})
