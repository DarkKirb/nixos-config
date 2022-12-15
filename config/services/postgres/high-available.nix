{
  config,
  pkgs,
  lib,
  hapsql,
  ...
}: let
  internalIP = (import ../../../utils/getInternalIP.nix config).listenIP;
  haNodes = ["[fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49]" "[fd0d:a262:1fa6:e621:746d:4523:5c04:1453]"];
in {
  imports = [
    hapsql.nixosModule
  ];
  services.hapsql = {
    enable = true;
    nodeName = config.networking.hostName;
    nodeAddress = internalIP;
    cluster = {
      scope = "chirrs";
      nodes = builtins.filter (a: a != internalIP) haNodes;
      ports = {
        raft = 49921;
        postgres = 2428;
        restApi = 56708;
      };
    };
    postgresqlPackage = pkgs.postgresql_15.withPackages (ps: with ps; [rum]);
    prometheus = {
      enable-postgres-exporter = true;
    };
  };
  services.patroni2 = {
    postgresql.data_dir = "/var/lib/postgresql/15";
    bootstrap = {
      pg_hba = [
        "host replication replicator fd0d:a262:1fa6:e621:b4e1:08ff:e658:6f49/128 md5"
        "host replication replicator fd0d:a262:1fa6:e621:746d:4523:5c04:1453/128 md5"
        "host all all 0.0.0.0/0 md5"
        "host all all ::/0 md5"
      ];
    };
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [
    49921
    2428
    56708
  ];
  users.users.postgres.home = lib.mkForce "/var/lib/postgresql";
}
