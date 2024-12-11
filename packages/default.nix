inputs: final: prev: {
  art-lotte = final.callPackage ./art/lotte { };
  inherit (prev.inputs.element-web.packages.${prev.system}) element-web;
  inherit (final.kdePackages) fcitx5-configtool;
  fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      ./i18n/fcitx-table-extra.patch
    ];
  });
  fish = prev.fish.overrideAttrs {
    postPatch = ''
      substituteInPlace src/history.cpp --replace-fail 'vacuum = true' 'vacuum = false'
    '';
    doCheck = false;
  };
  kodi-joyn = final.kodiPackages.callPackage ./kodi/joyn { };
  package-updater = final.callPackage ./updater.nix { };
  palette-generator = final.callPackage "${inputs.stylix}/palette-generator" { };
  palettes = final.callPackage ./art/lotte/palettes.nix { };
}
