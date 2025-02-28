{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      kodi-wayland = prev.kodi-wayland.override {
        curl = final.curl.overrideAttrs (super: {
          patches = super.patches or [ ] ++ [
            ./curl.patch
          ];
        });
      };
    })
  ];
}
