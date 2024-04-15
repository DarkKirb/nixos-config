{
  lib,
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
    hostBridge = "containers";
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
          proxy-headers = "xforwarded";
          hostname-admin = "keycloak-admin.int.chir.rs";
          http-enabled = true;
          health-enabled = true;
          metrics-enabled = true;
          http-port = 8080;
          https-port = 8443;
          hostname-strict = false;
        };
      };
      system.stateVersion = "24.05";
      networking.firewall.extraCommands = ''
        ip6tables -A nixos-fw -p tcp -s fc00::1 -m tcp --dport 8080 -m comment --comment caddy -j nixos-fw-accept
      '';
    };
  };

  systemd.services.keycloak-db-password = {
    script = ''
      umask 077
      mkdir -pv /run/generated-secrets
      cat /dev/urandom | tr -dc A-za-z0-9 | head -c 16 > /run/generated-secrets/keycloak-db-password
    '';
  };

  systemd.services."container@keycloak".requires = [
    "container@postgresql.service"
    "keycloak-db-password.service"
  ];
  systemd.services."container@keycloak".after = [
    "container@postgresql.service"
    "keycloak-db-password.service"
  ];
  systemd.services."container@postgresql".partOf = [
    "container@keycloak.service"
  ];
  systemd.services."container@postgresql".requires = [
    "keycloak-db-password.service"
  ];

  services.caddy.virtualHosts = {
    "keycloak-admin.int.chir.rs" = {
      useACMEHost = "int.chir.rs";
      logFormat = lib.mkForce "";
      extraConfig = ''
        import baseConfig

        reverse_proxy http://keycloak:8080
      '';
    };
    "keycloak.int.chir.rs" = {
      useACMEHost = "int.chir.rs";
      logFormat = lib.mkForce "";
      extraConfig = ''
        import baseConfig

        @public path /js/* /realms/* /resources/* /robots.txt

        reverse_proxy @public http://keycloak:8080
      '';
    };
  };
}
