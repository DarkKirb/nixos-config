inputs: system: self: prev: let
  inherit (inputs) nixpkgs element-web;
  common = with nixpkgs.legacyPackages.${system}; {
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
    emoji-volpeon-bunhd = self.callPackage ../packages/art/emoji/volpeon/bunhd.nix {};
    emoji-volpeon-drgn = self.callPackage ../packages/art/emoji/volpeon/drgn.nix {};
    emoji-volpeon-fox = self.callPackage ../packages/art/emoji/volpeon/fox.nix {};
    emoji-volpeon-gphn = self.callPackage ../packages/art/emoji/volpeon/gphn.nix {};
    emoji-volpeon-raccoon = self.callPackage ../packages/art/emoji/volpeon/raccoon.nix {};
    emoji-volpeon-vlpn = self.callPackage ../packages/art/emoji/volpeon/vlpn.nix {};
    emoji-volpeon-neofox = self.callPackage ../packages/art/emoji/volpeon/neofox.nix {};
    emoji-volpeon-neocat = self.callPackage ../packages/art/emoji/volpeon/neocat.nix {};
    emoji-volpeon-floof = self.callPackage ../packages/art/emoji/volpeon/floof.nix {};
    emoji-volpeon-wvrn = self.callPackage ../packages/art/emoji/volpeon/wvrn.nix {};
    emoji-rosaflags = self.callPackage ../packages/art/emoji/rosaflags.nix {};
    emoji-raccoon = self.callPackage ../packages/art/emoji/rosaflags.nix {};
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
    mautrix-slack = self.callPackage ../packages/matrix/mautrix-slack {};
    python-mautrix = self.python3Packages.callPackage ../packages/python/mautrix.nix {};
    python-tulir-telethon = self.python3Packages.callPackage ../packages/python/tulir-telethon.nix {};
    papermc = self.callPackage ../packages/minecraft/papermc {};
    miifox-net = self.python3Packages.callPackage ../packages/web/miifox-net.nix {};
    asar-asm = self.callPackage ../packages/compiler/asar {};
    bsnes-plus = self.libsForQt5.callPackage ../packages/emulator/bsnes-plus {};
    yiffstash = self.python3Packages.callPackage ../packages/python/yiffstash.nix {};
    mgba-dev = self.libsForQt5.callPackage ../packages/emulator/mgba-dev {};
  };
  perSystem = {
    aarch64-linux = {
      # linux-devterm = self.callPackage ../packages/linux/devterm/kernel.nix {};
    };
  };
in
  common // perSystem.${system} or {}
