inputs: final: prev: {
  github-updater = final.callPackage ./updaters/github.nix { };
  art-lotte = final.callPackage ./art/lotte { };
  #inherit (prev.inputs.element-web.packages.${prev.system}) element-web;
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
  plover = final.python3Packages.callPackage ./stenography/plover { };
  plover_dict_commands = final.python3Packages.callPackage ./stenography/plover_dict_commands { };
  plover-env = final.callPackage ./stenography/plover-env.nix { };
  plover_lapwing_aio = final.python3Packages.callPackage ./stenography/plover_lapwing_aio { };
  plover_last_translation =
    final.python3Packages.callPackage ./stenography/plover_last_translation
      { };
  plover_modal_dictionary =
    final.python3Packages.callPackage ./stenography/plover_modal_dictionary
      { };
  plover_plugins_manager = final.python3Packages.callPackage ./stenography/plover_plugins_manager { };
  plover_python_dictionary =
    final.python3Packages.callPackage ./stenography/plover_python_dictionary
      { };
  plover_stitching = final.python3Packages.callPackage ./stenography/plover_stitching { };
  plover_stroke = final.python3Packages.callPackage ./stenography/plover_stroke { };
  plover_uinput = final.python3Packages.callPackage ./stenography/plover_uinput { };
  rtf_tokenize = final.python3Packages.callPackage ./stenography/rtf_tokenize { };
}
