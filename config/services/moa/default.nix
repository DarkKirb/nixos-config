{
  pkgs,
  lib,
  ...
}: {
  systemd.services = {
    moa-app = {
      description = "Moa web app";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PYTHONPATH = toString ./.;
        MOA_CONFIG = "ProductionConfig";
      };
      serviceConfig = {
        Type = "simple";
        User = "moa";
        Group = "moa";
        ExecStart = "${pkgs.moa}/start-app.sh";
        Restart = "always";
      };
    };
    moa-worker = {
      description = "Moa worker";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        PYTHONPATH = toString ./.;
        MOA_CONFIG = "ProductionConfig";
      };
      serviceConfig = {
        Type = "simple";
        User = "moa";
        Group = "moa";
        ExecStart = "${pkgs.moa}/start-worker.sh";
        Restart = "always";
      };
    };
  };
  users.users.moa = {
    description = "Moa";
    useDefaultShell = true;
    group = "moa";
    isSystemUser = true;
  };
  users.groups.moa = {};
  services.postgresql.ensureDatabases = [
    "moa"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "moa";
      ensurePermissions = {
        "DATABASE moa" = "ALL PRIVILEGES";
      };
    }
  ];
  services.caddy.virtualHosts."moa.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    extraConfig = ''
      import baseConfig
      reverse_proxy http://localhost:5000
    '';
  };
  sops.secrets."services/moa/secret".owner = "moa";
  sops.secrets."services/moa/twitter_consumer_key".owner = "moa";
  sops.secrets."services/moa/twitter_consumer_secret".owner = "moa";
}
