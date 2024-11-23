final: prev: {
  art-lotte = final.callPackage ./art/lotte { };
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
