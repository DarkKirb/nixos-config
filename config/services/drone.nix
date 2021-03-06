{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit ((import ../../utils/getInternalIP.nix config)) listenIPs;
  listenStatements =
    lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs)
    + ''
      add_header Alt-Svc 'h3=":443"';
    '';
  split-system = pkgs.lib.strings.splitString "-" pkgs.system;
in {
  systemd.services.drone-server = {
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    environment = {
      DRONE_DATABASE_DATASOURCE = "postgres:///drone-server?sslmode=disable&host=/run/postgresql";
      DRONE_DATABASE_DRIVER = "postgres";
      DRONE_SERVER_HOST = "drone.chir.rs";
      DRONE_SERVER_PROTO = "https";
      DRONE_RUNNER_OS = builtins.elemAt split-system 1;
      DRONE_RUNNER_ARCH = builtins.replaceStrings ["x86_64"] ["amd64"] (builtins.elemAt split-system 0);
      DRONE_SERVER_PORT = ":47927";
    };
    serviceConfig = {
      Type = "simple";
      User = "drone-server";
      Group = "drone-server";
      ExecStart = "${pkgs.drone}/bin/drone-server";
      Restart = "always";
      EnvironmentFile = config.sops.secrets."services/drone".path;
    };
  };
  users.users.drone-server = {
    description = "Drone Server Service";
    home = "/run/drone";
    useDefaultShell = true;
    group = "drone-server";
    isSystemUser = true;
  };
  users.groups.drone-server = {};
  sops.secrets."services/drone" = {};
  services.postgresql.ensureDatabases = ["drone-server"];
  services.postgresql.ensureUsers = [
    {
      name = "drone-server";
      ensurePermissions = {"DATABASE \"drone-server\"" = "ALL PRIVILEGES";};
    }
  ];
  services.nginx.virtualHosts."drone.chir.rs" = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:47927";
      proxyWebsockets = true;
    };
    extraConfig = listenStatements;
  };
  services.nginx.virtualHosts."drone.int.chir.rs" = {
    listenAddresses = listenIPs;
    sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
    locations."/" = {
      proxyPass = "http://127.0.0.1:47927";
      proxyWebsockets = true;
    };
    extraConfig = listenStatements;
  };
}
