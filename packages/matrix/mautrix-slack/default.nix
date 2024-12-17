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
    pname = "mautrix-slack";
    version = source.date;
    src = fetchFromGitHub {
      owner = "mautrix";
      repo = "slack";
      inherit (source) rev sha256;
    };
    modules = ./gomod2nix.toml;
    buildInputs = [
      olm
    ];
    CGO_ENABLED = "1";
    go = go_1_23;
    postPatch = ''
      substituteInPlace go.mod --replace 'go1.23.4' 'go${go.version}'
    '';
    meta = {
      description = "slack-Matrix double-puppeting bridge";
      broken = builtins.compareVersions go.version "1.18" < 0;
    };
    postConfigure = ''
      chmod -R +w vendor/
      for f in vendor/golang.org/x/net/publicsuffix/data/* $(find vendor -name '*.sql') vendor/maunium.net/go/mautrix/bridgev2/matrix/mxmain/example-config.yaml; do
          cp -v --remove-destination -f `readlink $f` $f
      done
    '';
    passthru.updateScript = writeScript "update-matrix-media-repo" ''
      ${../../scripts/update-git.sh} "https://github.com/mautrix/slack" matrix/mautrix-slack/source.json
      if [ "$(git diff -- matrix/mautrix-slack/source.json)" ]; then
        SRC_PATH=$(nix-build -E '(import ../.).packages.x86_64-linux.${pname}.src')
        ${../../scripts/update-go.sh} $SRC_PATH matrix/mautrix-slack/
      fi
    '';
  }
