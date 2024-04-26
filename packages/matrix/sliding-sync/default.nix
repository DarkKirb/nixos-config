{
  buildGoApplication,
  olm,
  fetchFromGitHub,
  lib,
  writeScript,
  go,
}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  buildGoApplication rec {
    pname = "sliding-sync";
    version = source.date;
    src = fetchFromGitHub {
      owner = "matrix-org";
      repo = "sliding-sync";
      inherit (source) rev sha256;
    };
    modules = ./gomod2nix.toml;
    buildInputs = [
      olm
    ];
    CGO_ENABLED = "1";
    doCheck = false;
    meta = {
      description = "sliding sync proxy";
      license = lib.licenses.asl20;
      broken = builtins.compareVersions go.version "1.18" < 0;
    };
    passthru.updateScript = writeScript "update-sliding-sync" ''
      ${../../scripts/update-git.sh} "https://github.com/matrix-org/sliding-sync" matrix/sliding-sync/source.json
      if [ "$(git diff -- matrix/sliding-sync/source.json)" ]; then
        SRC_PATH=$(nix-build -E '(import ./. {}).${pname}.src')
        ${../../scripts/update-go.sh} $SRC_PATH matrix/sliding-sync/
      fi
    '';
  }
