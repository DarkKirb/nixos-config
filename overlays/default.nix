inputs: system: self: prev: let
  inherit (inputs) nixpkgs nix-packages;
in
  with nixpkgs.legacyPackages.${system}; {
    nix = prev.nix.overrideAttrs (old: {
      postPatchPhase = ''
        sed 's/getBoolAttr."allowSubstitutes", true./true/' src/libstore/parsed-derivations.cc
      '';
      checkPhase = "true";
      installCheckPhase = "true";
    });
    rnix-lsp = with prev;
      rustPlatform.buildRustPackage {
        pname = "rnix-lsp";
        version = "0.3.0-alejandra";

        src = fetchFromGitHub {
          owner = "nix-community";
          repo = "rnix-lsp";
          # https://github.com/nix-community/rnix-lsp/pull/89
          rev = "9189b50b34285b2a9de36a439f6c990fd283c9c7";
          sha256 = "sha256-ZnUtvwkcz7QlAiqQxhI4qVUhtVR+thLhG3wQlle7oZg=";
        };

        cargoSha256 = "sha256-VhE+DspQ0IZKf7rNkERA/gD7iMzjW4TnRSnYy1gdV0s=";
        cargoBuildFlags = ["--no-default-features" "--features" "alejandra"];

        checkPhase = "true";

        meta = with lib; {
          description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
          license = licenses.mit;
          maintainers = with maintainers; [ma27];
        };
      };
    hydra-unstable = nix-packages.packages.${system}.hydra.overrideAttrs (super: {
      doCheck = false;
      checkPhase = "";
      installCheckPhase = "";
    });
    neomutt = prev.neomutt.overrideAttrs (super: {
      doCheck = false;
      doInstallCheck = false;
    });
    fcitx5-table-extra = prev.fcitx5-table-extra.overrideAttrs (super: {
      patches =
        super.patches
        or []
        ++ [
          ../extra/fcitx-table-extra.patch
        ];
    });
    bat = prev.bat.overrideAttrs (_: {
      doCheck = false;
      doInstallCheck = false;
    });
  }
