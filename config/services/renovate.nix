{
  pkgs,
  config,
  cargo2nix,
  system,
  ...
}: {
  services.renovate = {
    enable = true;
    schedule = "hourly";
    settings = {
      platform = "gitea";
      endpoint = "https://git.chir.rs";
      gitAuthor = "Renovate <gitea-bot@chir.rs>";
      autodiscover = true;
      autodiscoverTopics = ["managed-by-renovate"];
      nix.enabled = true;
      lockFileMaintenance.enabled = true;
      osvVulnerabilityAlerts = true;
      allowedPostUpgradeCommands = ["^cargo2nix -o$" "^alejandra \\.$"];
    };
    credentials = {
      RENOVATE_TOKEN = config.sops.secrets."services/renovate".path;
    };
    runtimePackages = with pkgs; [
      config.nix.package
      nodejs
      corepack
      cargo
      cargo2nix.packages.${system}.cargo2nix
      alejandra
    ];
  };

  sops.secrets."services/renovate" = {};
}
