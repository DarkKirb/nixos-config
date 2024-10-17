{
  buildGoApplication,
  olm,
  fetchFromGitHub,
  lib,
  writeScript,
  go_1_23,
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
    postPatch = ''
      substituteInPlace go.mod --replace 'go1.23.2' 'go${go.version}'
    '';
    go = go_1_23;
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
      for f in $(find vendor/go.mau.fi/webp/internal/ vendor/go.mau.fi/whatsmeow/proto/ -type l) vendor/go.mau.fi/util/variationselector/*.json vendor/golang.org/x/net/publicsuffix/data/* vendor/maunium.net/go/mautrix/crypto/sql_store_upgrade/*.sql vendor/maunium.net/go/mautrix/sqlstatestore/*.sql $(find vendor/go.mau.fi/whatsmeow/binary/ -type l) vendor/google.golang.org/protobuf/internal/editiondefaults/editions_defaults.binpb vendor/maunium.net/go/mautrix/bridgev2/database/upgrades/*.sql vendor/maunium.net/go/mautrix/bridgev2/matrix/mxmain/example-config.yaml; do
          cp -v --remove-destination -f `readlink $f` $f
      done
    '';
    /*
      passthru.updateScript = writeScript "update-mautrix-whatsapp" ''
      ${../../scripts/update-git.sh} "https://github.com/mautrix/whatsapp" matrix/mautrix-whatsapp/source.json
      if [ "$(git diff -- matrix/mautrix-whatsapp/source.json)" ]; then
        SRC_PATH=$(nix-build -E '(import ../.).packages.x86_64-linux.${pname}.src')
        ${../../scripts/update-go.sh} $SRC_PATH matrix/mautrix-whatsapp/
      fi
    '';
    */
  }
