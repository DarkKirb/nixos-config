self: super: {
  art-lotte = self.callPackage ./art/lotte { };
  art-lotte-bgs-nsfw = self.callPackage ./art/lotte/bgs-nsfw.nix { };
  art-lotte-bgs-sfw = self.callPackage ./art/lotte/bgs-sfw.nix { };
  kodi-joyn = self.kodiPackages.callPackage ./kodi/joyn { };
  kodi-pydes = self.kodiPackages.callPackage ./kodi/pydes { };
  package-updater = self.callPackage ./updater.nix { };
}
