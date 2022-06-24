{
  system,
  pkgs,
  nixpkgs,
  hydra,
  nixpkgs-noto-variable,
  nixpkgs-go116,
  nix-packages,
  ...
}:
with pkgs; let
  hydra-pkg = hydra.defaultPackage.${system};
  rtf-tokenize = with python3Packages;
    buildPythonPackage rec {
      pname = "rtf_tokenize";
      version = "1.0.0";
      src = fetchFromGitHub {
        owner = "benoit-pierre";
        repo = pname;
        rev = version;
        sha256 = "1l5pfrggil9knk58r2r84i9msm7mdhddl87hkfk54qqk2sqzc06g";
      };
    };
  noto-variable = import nixpkgs-noto-variable {inherit system;};
  go116 = import nixpkgs-go116 {inherit system;};
in {
  nixpkgs.overlays = [
    (self: prev: {
      hydra-unstable = hydra-pkg.overrideAttrs (old: {
        postPatch = ''
          sed -i 's/totalNarSize > maxOutputSize/false/g' src/hydra-queue-runner/build-remote.cc
        '';
        checkPhase = "true";
        patches = [
          ../../extra/hydra.patch
        ];
      });
      #plover.dev = plover;
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
      /*
       gtk3 = prev.gtk3.overrideAttrs (old: {
       postPatch = old.postPatch + ''
       sed -i 's/gtk_compose_table_save_cache (compose_table);//' gtk/gtkcomposetable.c
       '';
       });
       */
      inherit (noto-variable) noto-fonts-cjk;
      inherit (go116) buildGo116Module;
      inherit (nix-packages.packages.${system}) plover plover-plugins-manager regenpfeifer plover-regenpfeifer lotte-art copilot-lua copilot-cmp;
      kitty = prev.kitty.overrideAttrs (old: {
        patches =
          old.patches
          ++ [
            ../../extra/kitty.patch
          ];
      });
      fcitx5-table-other = prev.fcitx5-table-other.overrideAttrs (old: {
        src = prev.fetchFromGitHub {
          owner = "pontaoski";
          repo = "fcitx5-table-other";
          rev = "254c0aed99fd105120521629d177636ea043bf59";
          sha256 = "sha256-iYFBlrHTFyesHNEOeI98DbmXSbRHVd+avmtN7Un0eok=";
        };
      });
    })
  ];
}
