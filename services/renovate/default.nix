{
  pkgs,
  config,
  cargo2nix,
  system,
  ...
}:
{
  services.renovate = {
    enable = true;
    schedule = "hourly";
    settings = {
      platform = "gitea";
      endpoint = "https://git.chir.rs";
      gitAuthor = "Renovate <gitea-bot@chir.rs>";
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
      RENOVATE_TOKEN = config.sops.secrets."services/renovate/credentials/RENOVATE_TOKEN".path;
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
      elixir
      pipenv
    ];
  };

  sops.secrets."services/renovate/credentials/RENOVATE_TOKEN".sopsFile = ./secrets.yaml;
  sops.secrets."services/renovate/credentials/GITHUB_COM_TOKEN".sopsFile = ./secrets.yaml;
}
