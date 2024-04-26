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
    pname = "mautrix-whatsapp";
    version = source.date;
    src = fetchFromGitHub {
      owner = "mautrix";
      repo = "whatsapp";
      inherit (source) rev sha256;
    };
    modules = ./gomod2nix.toml;
    buildInputs = [
      olm
    ];
    CGO_ENABLED = "1";
    meta = {
      description = "Whatsapp-Matrix double-puppeting bridge";
      broken = builtins.compareVersions go.version "1.18" < 0;
    };
    postConfigure = ''
      chmod -R +w vendor/
      for f in $(find vendor/go.mau.fi/webp/internal/ -type l) vendor/go.mau.fi/util/variationselector/*.json vendor/golang.org/x/net/publicsuffix/data/* vendor/maunium.net/go/mautrix/crypto/sql_store_upgrade/*.sql vendor/maunium.net/go/mautrix/sqlstatestore/*.sql $(find vendor/go.mau.fi/whatsmeow/binary/ -type l) vendor/google.golang.org/protobuf/internal/editiondefaults/editions_defaults.binpb; do
          cp -v --remove-destination -f `readlink $f` $f
      done
    '';
    passthru.updateScript = writeScript "update-mautrix-whatsapp" ''
      ${../../scripts/update-git.sh} "https://github.com/mautrix/whatsapp" matrix/mautrix-whatsapp/source.json
      if [ "$(git diff -- matrix/mautrix-whatsapp/source.json)" ]; then
        SRC_PATH=$(nix-build -E '(import ./. {}).${pname}.src')
        ${../../scripts/update-go.sh} $SRC_PATH matrix/mautrix-whatsapp/
      fi
    '';
  }
