{
  pkgs,
  config,
  ...
}: let
  config' = config;
  keycloakIP = config'.containers.keycloak.localAddress6;
in {
  imports = [
    ../postgresql/default.nix
  ];

  containers.postgresql = {
    bindMounts.keycloak-db-password = {
      mountPoint = "/secrets/keycloak-db-password-input";
      hostPath = "/run/generated-secrets/keycloak-db-password";
    };
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      networking.firewall.extraCommands = ''
        ip6tables -A nixos-fw -p tcp -s ${keycloakIP} -m tcp --dport 5432 -m comment --comment keycloak-db -j nixos-fw-accept
      '';
      services.postgresql = {
        ensureDatabases = [
          "keycloak"
        ];
        ensureUsers = [
          {
            name = "keycloak";
            ensureDBOwnership = true;
          }
        ];
        authentication = ''
          host keycloak keycloak ${keycloakIP}/128 scram-sha-256
        '';
      };
      systemd.services.postgresql.postStart = lib.mkAfter ''
        $PSQL -c "ALTER USER keycloak PASSWORD '$(cat /secrets/keycloak-db-password)';"
      '';
      systemd.tmpfiles.rules = [
        "C /secrets/keycloak-db-password - - - - /secrets/keycloak-db-password-input"
        "z /secrets/keycloak-db-password - postgres postgres - -"
      ];
    };
  };

  containers.keycloak = rec {
    autoStart = true;
    privateNetwork = true;
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::3";
    ephemeral = true;
    bindMounts = {
      keycloak-db-password = {
        mountPoint = "/secrets/keycloak-db-password";
        hostPath = "/run/generated-secrets/keycloak-db-password";
      };
    };
    config = {
      config,
      pkgs,
      ...
    }: {
      networking.interfaces.eth0.ipv6.routes = [
        {
          address = "fc00::";
          prefixLength = 64;
        }
      ];
      services.keycloak = {
        database = {
          host = config'.containers.postgresql.localAddress6;
          name = "keycloak";
          passwordFile = "/secrets/keycloak-db-password";
          username = "keycloak";
          useSSL = false;
        };
        enable = true;
        settings = {
          hostname = "keycloak.chir.rs";
          hostname-strict-backchannel = true;
          proxy = "edge";
          hostname-admin = "keycloak-admin.int.chir.rs";
          http-enabled = true;
          health-enabled = true;
          metrics-enabled = true;
        };
      };
      system.stateVersion = "24.05";
    };
  };

  systemd.services.keycloak-db-password = {
    requiredBy = [
      "container@postgresql.service"
      "container@keycloak.service"
    ];
    script = ''
      umask 077
      mkdir -pv /run/generated-secrets
      cat /dev/urandom | tr -dc A-za-z0-9 | head -c 16 > /run/generated-secrets/keycloak-db-password
    '';
  };

  systemd.services."container@keycloak.service".requires = [
    "container@postgresql.service"
  ];
  systemd.services."container@postgresql.service".partOf = [
    "container@keycloak.service"
  ];

  networking.bridges.keycloak.interfaces = [
    "ve-postgresql"
    "ve-keycloak"
  ];
}
