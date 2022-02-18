{ nixpkgs-soundtouch, nixpkgs-tdesktop, system, ... }:
{
  nixpkgs.overlays = [
    (self: prev: {
      coreutils = prev.coreutils.overrideAttrs (old: {
        checkPhase = "true";
      });
      soundtouch = nixpkgs-soundtouch.legacyPackages.${system}.soundtouch;
      tdesktop = nixpkgs-tdesktop.legacyPackages.${system}.tdesktop;
      hydra-unstable = prev.hydra-unstable.overrideAttrs (old: {
        patches = [
          ../../extra/hydra.patch
        ];
      });
    })
  ];
}
