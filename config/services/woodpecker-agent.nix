{
  config,
  pkgs,
  lib,
  nix-packages,
  system,
  ...
}: {
  imports = [./docker.nix];
  services.woodpecker-agents.agents.main = {
    enable = true;
    environment = {
      WOODPECKER_SERVER = "https://woodpecker.int.chir.rs/";
      WOODPECKER_BACKEND = "docker";
      DOCKER_HOST = "unix:///run/docker.sock";
    };
    environmentFile = [config.sops.secrets."services/woodpecker-runner".path];
  };
  sops.secrets."services/woodpecker-runner" = {};
}
