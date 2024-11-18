final: prev: {
  art-lotte = final.callPackage ./art/lotte { };
  art-lotte-bgs-nsfw = final.callPackage ./art/lotte/bgs-nsfw.nix { };
  art-lotte-bgs-sfw = final.callPackage ./art/lotte/bgs-sfw.nix { };
  inherit (prev.inputs.element-web.packages.${prev.system}) element-web;
  fish = prev.fish.overrideAttrs {
    postPatch = ''
      substituteInPlace src/history.cpp --replace-fail 'vacuum = true' 'vacuum = false'
    '';
    doCheck = false;
  };
  kodi-joyn = final.kodiPackages.callPackage ./kodi/joyn { };
  package-updater = final.callPackage ./updater.nix { };
}
