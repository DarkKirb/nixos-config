{
  system,
  pkgs,
  nixpkgs,
  nixpkgs-noto-variable,
  nix-packages,
  ...
}:
with pkgs; let
  noto-variable = import nixpkgs-noto-variable {inherit system;};
in {
  nixpkgs.overlays = [
    (self: prev: {
      hydra-unstable = nix-packages.packages.${system}.hydra;
      mosh = prev.mosh.overrideAttrs (old: {
        patches = [
          ./mosh/ssh_path.patch
          ./mosh/mosh-client_path.patch
          ./mosh/utempter_path.patch
          ./mosh/bash_completion_datadir.patch
        ];
        postPatch = ''
          substituteInPlace scripts/mosh.pl \
            --subst-var-by ssh "${openssh}/bin/ssh" \
            --subst-var-by mosh-client "$out/bin/mosh-client"
        '';
        version = "2022-02-04";
        src = pkgs.fetchFromGitHub {
          owner = "mobile-shell";
          repo = "mosh";
          rev = "dbe419d0e069df3fedc212d456449f64d0280c76";
          sha256 = "09mvk9zxclkf4wrkkfzg0p2hx1f74gpymr0a0l3pckmk6za2n3d1";
        };
      });
      inherit (noto-variable) noto-fonts-cjk;
      inherit (nix-packages.packages.${system}) plover plover-plugins-manager plover-emoji plover-tapey-tape plover-yaml-dictionary lotte-art plover-machine-hid mautrix-telegram mautrix-signal;
      kitty = prev.kitty.overrideAttrs (old: {
        patches =
          old.patches
          ++ [
            ../../extra/kitty.patch
          ];
        installCheckPhase = "true";
      });
      nix = prev.nix.overrideAttrs (old: rec {
        postPatchPhase = ''
          sed 's/getBoolAttr."allowSubstitutes", true./true/' src/libstore/parsed-derivations.cc
        '';
      });
      rnix-lsp = with prev;
        rustPlatform.buildRustPackage rec {
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
      dovecot = prev.dovcot.overrideAttrs (old: rec {
        checkPhase = "true";
        installCheckPhase = "true";
      });
    })
  ];
}
