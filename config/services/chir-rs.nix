{
  lib,
  pkgs,
  config,
  chir-rs,
  system,
  ...
}: let
  staticDir = pkgs.stdenvNoCC.mkDerivation {
    name = "static";
    buildPhase = "true";
    src = pkgs.emptyDirectory;
    installPhase = ''
      mkdir $out
      for f in ${chir-rs.packages.${system}.chir-rs-fe}/*; do
        ln -sv $f $out
      done
      ln -sv ${chir-rs.packages.${system}.art-assets} $out/img
    '';
  };
  auxCfg = pkgs.writeText "config.dhall" ''
    ${./chir-rs.dhall} {
        staticDir = "${staticDir}",
        connectionString = "postgres://chir_rs:" ++ (${config.sops.secrets."services/chir-rs/database-password".path} as Text) ++ "@nixos-8gb-fsn1-1.int.chir.rs/chir_rs",
        signUpKey = ${config.sops.secrets."services/chir-rs/signup-secret".path} as Text,
        nodeName = "${config.networking.hostName}"
      }
  '';
in {
  systemd.services.chir-rs = {
    enable = true;
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      Restart = "always";
      PrivateTmp = true;
      WorkingDirectory = "/tmp";
      User = "chir-rs";
      CapabilityBoundingSet = [""];
      DeviceAllow = [""];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      UMask = "0077";
      ExecStart = ''
        ${chir-rs.packages.${system}.chir-rs}/bin/chir-rs
      '';
    };
    environment = {
      CHIR_RS_CONFIG = "${auxCfg}";
    };
  };
  sops.secrets."services/chir-rs/database-password".owner = "chir-rs";
  sops.secrets."services/chir-rs/signup-secret".owner = "chir-rs";
  services.postgresql.ensureDatabases = [
    "chir_rs"
  ];
  services.postgresql.ensureUsers = [
    {
      name = "chir_rs";
      ensurePermissions = {
        "DATABASE chir_rs" = "ALL PRIVILEGES";
      };
    }
  ];
  services.caddy.virtualHosts."lotte-test.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:62936 {
        trusted_proxies private_ranges
      }
    '';
  };
  users.users.chir-rs = {
    description = "Chir.rs domain server";
    isSystemUser = true;
    group = "chir-rs";
  };
  users.groups.chir-rs = {};
}
