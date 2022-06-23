{
  config,
  pkgs,
  lib,
  nix-packages,
  system,
  ...
}: {
  systemd.services.drone-runner-docker = {
    wantedBy = ["multi-user.target"];
    after = ["docker.service"];
    environment = {
      DRONE_RPC_HOST = "drone.int.chir.rs";
      DRONE_RPC_PROTO = "https";
      DRONE_RUNNER_MAX_PROCS = toString config.nix.settings.cores;
      DRONE_RUNNER_NAME = "${config.networking.hostName}.int.chir.rs";
    };
    serviceConfig = {
      Type = "simple";
      User = "drone-runner-docker";
      Group = "docker";
      ExecStart = "${nix-packages.packages.${system}.drone-runner-docker}/bin/drone-runner-docker";
      Restart = "always";
      EnvironmentFile = config.sops.secrets."services/drone".path;
    };
  };
  users.users.drone-runner-docker = {
    description = "Drone Docker Runner Service";
    home = "/run/drone";
    useDefaultShell = true;
    group = "docker";
    isSystemUser = true;
  };
  sops.secrets."services/drone" = {};
}
