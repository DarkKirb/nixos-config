inputs: system: self: prev: let
  inherit (inputs) nixpkgs element-web;
in
  with nixpkgs.legacyPackages.${system}; {
    fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
      patches =
        super.patches
        or []
        ++ [
          ../extra/fcitx-table-extra.patch
        ];
    });
    emoji-lotte = self.callPackage ../packages/art/emoji/lotte {};
    emoji-volpeon-blobfox = self.callPackage ../packages/art/emoji/volpeon/blobfox.nix {};
    emoji-volpeon-blobfox-flip = self.callPackage ../packages/art/emoji/volpeon/blobfox_flip.nix {};
    emoji-volpeon-bunhd = self.callPackage ../packages/art/emoji/volpeon/bunhd.nix {};
    emoji-volpeon-bunhd-flip = self.callPackage ../packages/art/emoji/volpeon/bunhd_flip.nix {};
    emoji-volpeon-drgn = self.callPackage ../packages/art/emoji/volpeon/drgn.nix {};
    emoji-volpeon-fox = self.callPackage ../packages/art/emoji/volpeon/fox.nix {};
    emoji-volpeon-gphn = self.callPackage ../packages/art/emoji/volpeon/gphn.nix {};
    emoji-volpeon-raccoon = self.callPackage ../packages/art/emoji/volpeon/raccoon.nix {};
    emoji-volpeon-vlpn = self.callPackage ../packages/art/emoji/volpeon/vlpn.nix {};
    emoji-volpeon-neofox = self.callPackage ../packages/art/emoji/volpeon/neofox.nix {};
    emoji-volpeon-neocat = self.callPackage ../packages/art/emoji/volpeon/neocat.nix {};
    emoji-volpeon-floof = self.callPackage ../packages/art/emoji/volpeon/floof.nix {};
    emoji-caro = self.callPackage ../packages/art/emoji/caro {};
    lotte-art = self.callPackage ../packages/art/lotte {};
    alco-sans = self.callPackage ../packages/fonts/kreative/alco-sans.nix {};
    constructium = self.callPackage ../packages/fonts/kreative/constructium.nix {};
    fairfax = self.callPackage ../packages/fonts/kreative/fairfax.nix {};
    fairfax-hd = self.callPackage ../packages/fonts/kreative/fairfax-hd.nix {};
    kreative-square = self.callPackage ../packages/fonts/kreative/kreative-square.nix {};
    nasin-nanpa = self.callPackage ../packages/fonts/nasin-nanpa {};
    matrix-media-repo = self.callPackage ../packages/matrix/matrix-media-repo {};
    mautrix-discord = self.callPackage ../packages/matrix/mautrix-discord {};
    mautrix-whatsapp = self.callPackage ../packages/matrix/mautrix-whatsapp {};
    mautrix-telegram = self.callPackage ../packages/matrix/mautrix-telegram {};
    python-mautrix = self.python3Packages.callPackage ../packages/python/mautrix.nix {};
    python-tulir-telethon = self.python3Packages.callPackage ../packages/python/tulir-telethon.nix {};
    papermc = self.callPackage ../packages/minecraft/papermc {};
    python-plover-stroke = self.python3Packages.callPackage ../packages/plover/plover-stroke.nix {};
    python-rtf-tokenize = self.python3Packages.callPackage ../packages/python/rtf-tokenize.nix {};
    plover = self.python3Packages.callPackage ../packages/plover/plover {};
    plover-plugins-manager = self.python3Packages.callPackage ../packages/plover/plover-plugins-manager.nix {};
    python-simplefuzzyset = self.python3Packages.callPackage ../packages/python/simplefuzzyset.nix {};
    plover-plugin-emoji = self.python3Packages.callPackage ../packages/plover/plover-emoji.nix {};
    plover-plugin-tapey-tape = self.python3Packages.callPackage ../packages/plover/plover-tapey-tape.nix {};
    plover-plugin-yaml-dictionary = self.python3Packages.callPackage ../packages/plover/plover-yaml-dictionary.nix {};
    plover-plugin-python-dictionary = self.python3Packages.callPackage ../packages/plover/plover-python-dictionary.nix {};
    plover-plugin-stenotype-extended = self.python3Packages.callPackage ../packages/plover/plover-stenotype-extended.nix {};
    plover-plugin-machine-hid = self.python3Packages.callPackage ../packages/plover/plover-machine-hid.nix {};
    plover-plugin-rkb1-hid = self.python3Packages.callPackage ../packages/plover/plover-rkb1-hid.nix {};
    plover-plugin-dotool-output = self.python3Packages.callPackage ../packages/plover/plover-dotool-output.nix {};
    plover-plugin-dict-commands = self.python3Packages.callPackage ../packages/plover/plover-dict-commands.nix {};
    plover-plugin-last-translation = self.python3Packages.callPackage ../packages/plover/plover-last-translation.nix {};
    plover-plugin-modal-dictionary = self.python3Packages.callPackage ../packages/plover/plover-modal-dictionary.nix {};
    plover-plugin-stitching = self.python3Packages.callPackage ../packages/plover/plover-stitching.nix {};
    plover-plugin-lapwing-aio = self.python3Packages.callPackage ../packages/plover/plover-lapwing-aio.nix {};
    plover-dict-didoesdigital = self.callPackage ../packages/plover/didoesdigital-dictionary.nix {};
    miifox-net = self.python3Packages.callPackage ../packages/web/miifox-net.nix {};
    old-homepage = self.callPackage ../packages/web/old-homepage.nix {};
    asar-asm = self.callPackage ../packages/compiler/asar {};
    bsnes-plus = self.libsForQt5.callPackage ../packages/emulator/bsnes-plus {};
    sliding-sync = self.callPackage ../packages/matrix/sliding-sync {};
    yiffstash = self.python3Packages.callPackage ../packages/python/yiffstash.nix {};
    rosaflags = self.callPackage ../packages/art/emoji/rosaflags.nix {};
    element-web = element-web.packages.${system}.element-web;
  }
