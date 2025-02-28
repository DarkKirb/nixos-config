{
  pkgs,
  config,
  cargo2nix,
  system,
  lib,
  ...
}:
{
  services.renovate = {
    enable = true;
    schedule = "hourly";
    settings = {
      platform = "github";
      autodiscover = true;
      autodiscoverTopics = [ "managed-by-renovate" ];
      nix.enabled = true;
      lockFileMaintenance.enabled = true;
      osvVulnerabilityAlerts = true;
      allowedPostUpgradeCommands = [
        "^cargo2nix -o$"
        "^alejandra \\.$"
        "^./update.sh$"
        "^treefmt$"
        "^updater$"
        "^mix2nix > mix.nix$"
        "^yarn2nix > yarn.nix$"
      ];
      allowCustomCrateRegistries = true;
    };
    credentials = {
      GITHUB_PEM = config.sops.secrets."services/renovate/credentials/privkey.pem".path;
      GITHUB_COM_TOKEN = config.sops.secrets."services/renovate/credentials/GITHUB_COM_TOKEN".path;
    };
    runtimePackages = with pkgs; [
      config.nix.package
      nodejs
      corepack
      cargo
      cargo2nix.packages.${system}.cargo2nix
      alejandra
      git-lfs
      treefmt
      nixfmt-rfc-style
      package-updater
      rustfmt
      mix2nix
      yarn2nix
    ];
  };

  systemd.services.renovate.script = lib.mkBefore ''
    #!${lib.getExe pkgs.bash}
    set -euo pipefail
    client_id=Iv23li2EB7v4XJseLlto
    pem="$(${lib.getExe' pkgs.systemd "systemd-creds"} cat 'SECRET-GITHUB_PEM')"
    now=$(${lib.getExe' pkgs.coreutils "date"} +%s)
    iat=$((''${now} - 60)) # Issues 60 seconds in the past
    exp=$((''${now} + 600)) # Expires 10 minutes in the future
    b64enc() { ${lib.getExe pkgs.openssl} base64 | ${lib.getExe' pkgs.coreutils "tr"} -d '=' | ${lib.getExe' pkgs.coreutils "tr"} '/+' '_-' | ${lib.getExe' pkgs.coreutils "tr"} -d '\n'; }
    header_json='{
        "typ":"JWT",
        "alg":"RS256"
    }'
    # Header encode
    header=$( echo -n "''${header_json}" | b64enc )

    payload_json="{
        \"iat\":''${iat},
        \"exp\":''${exp},
        \"iss\":\"''${client_id}\"
    }"
    # Payload encode
    payload=$( echo -n "''${payload_json}" | b64enc )

    # Signature
    header_payload="''${header}"."''${payload}"
    signature=$(
        ${lib.getExe pkgs.openssl} dgst -sha256 -sign <(echo -n "''${pem}") \
        <(echo -n "''${header_payload}") | b64enc
    )

    # Create JWT
    JWT="''${header_payload}"."''${signature}"

    RENOVATE_TOKEN=$(${lib.getExe pkgs.curl} --request POST \
       --url "https://api.github.com/app/installations/61371765/access_tokens" \
       --header "Accept: application/vnd.github+json" \
       --header "Authorization: Bearer ''${JWT}" \
       --header "X-GitHub-Api-Version: 2022-11-28" | ${lib.getExe pkgs.jq} -r '.token')

    export RENOVATE_TOKEN
  '';

  sops.secrets."services/renovate/credentials/privkey.pem".sopsFile = ./secrets.yaml;
  sops.secrets."services/renovate/credentials/GITHUB_COM_TOKEN".sopsFile = ./secrets.yaml;
}
