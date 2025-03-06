{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      kodi = prev.kodi.override {
        curl = final.curl.overrideAttrs (super: {
          patches = super.patches or [ ] ++ [
            ./curl.patch
          ];
        });
      };
    })
  ];
}
