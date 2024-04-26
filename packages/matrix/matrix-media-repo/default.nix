{
  buildGoApplication,
  git,
  fetchFromGitHub,
  lib,
  writeScript,
  libde265,
  libheif,
  pkg-config,
  cmake,
}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
  libheif' = libheif.overrideAttrs (super: rec {
    version = "1.17.1";
    src = fetchFromGitHub {
      owner = "strukturag";
      repo = "libheif";
      rev = "v${version}";
      sha256 = "sha256-PI55VdNsJUpomdFlVOzD9ha1b+0MoxOPnM0KASRH2rI=";
    };
    nativeBuildInputs = [cmake pkg-config];
  });
in
  buildGoApplication rec {
    pname = "matrix-media-repo";
    version = source.date;
    src = fetchFromGitHub {
      owner = "turt2live";
      repo = "matrix-media-repo";
      inherit (source) rev sha256;
    };
    modules = ./gomod2nix.toml;
    nativeBuildInputs = [
      git
      pkg-config
    ];
    buildInputs = [
      libde265
      libheif'
    ];
    CGO_ENABLED = "1";
    buildPhase = ''
      GOBIN=$PWD/bin go install -v ./cmd/utilities/compile_assets
      $PWD/bin/compile_assets
      GOBIN=$PWD/bin go install -ldflags "-X github.com/turt2live/matrix-media-repo/common/version.GitCommit=$(git rev-list -1 HEAD) -X github.com/turt2live/matrix-media-repo/common/version.Version=${version}" -v ./cmd/...
    '';
    installPhase = ''
      mkdir $out
      cp -rv bin $out
    '';
    meta = {
      description = "Matrix media repository with multi-domain in mind.";
      license = lib.licenses.mit;
    };
    postConfigure = ''
      chmod -R +w vendor/
      for f in vendor/golang.org/x/net/publicsuffix/data/* vendor/google.golang.org/protobuf/internal/editiondefaults/editions_defaults.binpb; do
          cp -v --remove-destination -f `readlink $f` $f
      done
    '';
    passthru.updateScript = writeScript "update-matrix-media-repo" ''
      ${../../scripts/update-git.sh} "https://github.com/turt2live/matrix-media-repo" matrix/matrix-media-repo/source.json
      if [ "$(git diff -- matrix/matrix-media-repo/source.json)" ]; then
        SRC_PATH=$(nix-build -E '(import ./. {}).${pname}.src')
        ${../../scripts/update-go.sh} $SRC_PATH matrix/matrix-media-repo/
      fi
    '';
  }
