{pkgs, ...}: {
  systemd.services.chirrs = {
    enable = true;
    description = "chir.rs";
    script = "${pkgs.chir-rs}/chir-rs-server";
    serviceConfig = {
      WorkingDirectory = pkgs.chir-rs;
      EnvironmentFile = "/run/secrets/services/chir.rs";
    };
    wantedBy = ["multi-user.target"];
  };
  services.caddy.virtualHosts."api.chir.rs" = {
    useACMEHost = "chir.rs";
    extraConfig = ''
      import baseConfig
      rewrite * /api.chir.rs/{path}
      reverse_proxy {
        to http://localhost:8621
      }
    '';
  };
  services.postgresql.ensureDatabases = ["homepage"];
  services.postgresql.ensureUsers = [
    {
      name = "homepage";
      ensurePermissions = {"DATABASE homepage" = "ALL PRIVILEGES";};
    }
  ];
  sops.secrets."services/chir.rs" = {};
}
