{
  pkgs,
  config,
  ...
}: {
  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances.default = {
      enable = true;
      name = config.networking.hostName;
      url = "https://git.chir.rs";
      # Obtaining the path to the runner token file may differ
      tokenFile = config.sops.secrets."services/forgejo-runner".path;
      labels = [];
    };
  };
  sops.secrets."services/forgejo-runner" = {};
}
