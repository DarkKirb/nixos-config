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
      WOODPECKER_SERVER = "woodpecker.int.chir.rs:9000";
      WOODPECKER_BACKEND = "docker";
      DOCKER_HOST = "unix:///run/docker.sock";
    };
    environmentFile = [config.sops.secrets."services/woodpecker-runner".path];
    extraGroups = ["docker"];
  };
  sops.secrets."services/woodpecker-runner" = {};
}
