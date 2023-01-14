{
  pkgs,
  system,
  chir-rs,
  config,
  ...
}: let
  d = "$";
  dhallConfig = ''
    let password = ${config.sops.secrets."services/chir-rs/auth/password".path} as Text
    let BaseConfig =
          { Type =
              { database_url : Text
              , listen_addr : Text
              , redis_url : Text
              }
            , default.listen_addr = "[::1]:5621"
          }

    in  BaseConfig::{
        , database_url = "postgres://auth_chir_rs:${d}{password}@nixos-8gb-fsn1-1.int.chir.rs"
        , listen_addr = "[::1]:7954"
        , redis_url = "redis://${d}{password}@nixos-8gb-fsn1-1.int.chir.rs:53538/0"
        }
  '';
in {
  systemd.services.auth-chir-rs = {
    description = "auth.chir.rs";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    script = ''
      export CONFIG_FILE=${pkgs.writeText "config.dhall" dhallConfig}
      exec ${chir-rs.packages.${system}.chir-rs-auth}/bin/chir-rs-auth
    '';
    serviceConfig = {
      Type = "simple";
      User = "auth-chir-rs";
      Group = "auth-chir-rs";
      Restart = "always";
    };
  };
  sops.secrets."services/chir-rs/auth/password".owner = "auth-chir-rs";
  users.users.auth-chir-rs = {
    description = "auth.chir.rs";
    home = "/var/empty";
    useDefaultShell = true;
    group = "auth-chir-rs";
    isSystemUser = true;
  };
  users.groups.auth-chir-rs = {};
  services.postgresql.ensureDatabases = [
    "auth_chir_rs"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "auth_chir_rs";
      ensurePermissions = {
        "DATABASE auth_chir_rs" = "ALL PRIVILEGES";
      };
    }
  ];
  services.redis.servers."auth_chir_rs" = {
    enable = config.networking.hostName == "nixos-8gb-fsn1-1";
    port = 53538;
    save = [];
    requirePassFile = config.sops.secrets."services/chir-rs/auth/password".path;
    user = "auth_chir_rs";
  };
  networking.firewall.interfaces."wg0".allowedTCPPorts = [53538];
}
