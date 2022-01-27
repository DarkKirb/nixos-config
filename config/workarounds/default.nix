{ ... }: {
  nixpkgs.overlays = [
    (self: prev: {
      git = prev.git.overrideAttrs (oldAttrs: {
        checkPhase = "true";
        installCheckPhase = "true";
      }); # Git’s check phase is broken on zfs with normalization enabled
      bat = prev.bat.overrideAttrs (oldAttrs: {
        checkPhase = "true";
      }); # Bat’s check phase is broken with mandatory utf-8 file names
    })
  ];
}
