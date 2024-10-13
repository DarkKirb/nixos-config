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
      labels = ["docker"];
    };
    instances.darkkirb = {
      enable = true;
      name = config.networking.hostName;
      url = "https://git.chir.rs";
      # Obtaining the path to the runner token file may differ
      tokenFile = config.sops.secrets."services/forgejo-runner-darkkirb".path;
      labels = [
        "ubuntu-latest:docker://node:16-bullseye"
        "ubuntu-22.04:docker://node:16-bullseye"
        "ubuntu-20.04:docker://node:16-bullseye"
        "ubuntu-18.04:docker://node:16-buster"
        "docker"
      ];
    };
  };
  sops.secrets."services/forgejo-runner" = {};
  sops.secrets."services/forgejo-runner-darkkirb" = {};
}
