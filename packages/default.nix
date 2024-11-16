final: prev: {
  art-lotte = final.callPackage ./art/lotte { };
  art-lotte-bgs-nsfw = final.callPackage ./art/lotte/bgs-nsfw.nix { };
  art-lotte-bgs-sfw = final.callPackage ./art/lotte/bgs-sfw.nix { };
  kodi-joyn = final.kodiPackages.callPackage ./kodi/joyn { };
  package-updater = final.callPackage ./updater.nix { };
}
