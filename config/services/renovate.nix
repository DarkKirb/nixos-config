{
  pkgs,
  config,
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
      ossVulnerabilityAlerts = true;
      credentials = {
        RENOVATE_TOKEN = config.sops.secrets."services/renovate".path;
      };
    };
    runtimePackages = with pkgs; [
      config.nix.package
      nodejs
      corepack
      cargo
    ];
  };

  sops.secrets."services/renovate" = {};
}
