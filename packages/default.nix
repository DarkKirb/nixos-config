inputs: final: prev: {
  github-updater = final.callPackage ./updaters/github.nix { };
  art-lotte = final.callPackage ./art/lotte { };
  inherit (final.kdePackages) fcitx5-configtool;
  fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
    patches = super.patches or [ ] ++ [
      ./i18n/fcitx-table-extra.patch
    ];
  });
  kodi-joyn = final.kodiPackages.callPackage ./kodi/joyn { };
  linux-devterm = final.callPackage ./linux/devterm { };
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
  yiffstash = final.python3Packages.callPackage ./art/yiffstash { };
  emoji-caro = final.callPackage ./art/emoji/caro { };
  emoji-lotte = final.callPackage ./art/emoji/lotte { };
  emoji-volpeon-blobfox = final.callPackage ./art/emoji/volpeon/blobfox.nix { };
  emoji-volpeon-bunhd = final.callPackage ./art/emoji/volpeon/bunhd.nix { };
  emoji-volpeon-drgn = final.callPackage ./art/emoji/volpeon/drgn.nix { };
  emoji-volpeon-floof = final.callPackage ./art/emoji/volpeon/floof.nix { };
  emoji-volpeon-fox = final.callPackage ./art/emoji/volpeon/fox.nix { };
  emoji-volpeon-gphn = final.callPackage ./art/emoji/volpeon/gphn.nix { };
  emoji-volpeon-neocat = final.callPackage ./art/emoji/volpeon/neocat.nix { };
  emoji-volpeon-neofox = final.callPackage ./art/emoji/volpeon/neofox.nix { };
  emoji-volpeon-raccoon = final.callPackage ./art/emoji/volpeon/raccoon.nix { };
  emoji-volpeon-vlpn = final.callPackage ./art/emoji/volpeon/vlpn.nix { };
  emoji-volpeon-wvrn = final.callPackage ./art/emoji/volpeon/wvrn.nix { };
  emoji-rosaflags = final.callPackage ./art/emoji/rosaflags.nix { };
  renovate = prev.renovate.overrideAttrs {
    dontCheckForBrokenSymlinks = true;
  };
}
