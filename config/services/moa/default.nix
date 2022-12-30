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
      environment = {
        PYTHONPATH = toString ./.;
        MOA_CONFIG = "ProductionConfig";
      };
      serviceConfig = {
        Type = "oneshot";
        User = "moa";
        Group = "moa";
        ExecStart = "${pkgs.moa}/start-worker.sh";
      };
    };
  };
  systemd.timers.moa-worker = {
    description = "Moa worker";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    requires = ["moa-worker.service"];
    timerConfig = {
      OnUnitActiveSec = 300;
      RandomizedDelaySec = 60;
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
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig
      reverse_proxy http://localhost:5000 {
        header_up Host "moa.chir.rs"
      }
    '';
  };
  sops.secrets."services/moa/secret".owner = "moa";
  sops.secrets."services/moa/twitter_consumer_key".owner = "moa";
  sops.secrets."services/moa/twitter_consumer_secret".owner = "moa";
}
