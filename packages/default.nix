inputs: final: prev: {
  github-updater = final.callPackage ./updaters/github.nix { };
  go-updater = final.callPackage ./updaters/go.nix { };
  art-lotte = final.callPackage ./art/lotte { };
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
  emoji-neopossum = final.callPackage ./art/emoji/neopossum.nix { };
  clscrobble = final.callPackage ./music/clscrobble { };
  tulir-telethon = final.python3Packages.callPackage ./matrix/tulir-telethon { };
  mautrix-python = final.python3Packages.callPackage ./matrix/mautrix-python { };
  mautrix-telegram = final.python3Packages.callPackage ./matrix/mautrix-telegram { };
  mautrix-discord = final.callPackage ./matrix/mautrix-discord { };
  mautrix-signal = final.callPackage ./matrix/mautrix-signal { };
  mautrix-slack = final.callPackage ./matrix/mautrix-slack { };
  mautrix-whatsapp = final.callPackage ./matrix/mautrix-whatsapp { };
}
