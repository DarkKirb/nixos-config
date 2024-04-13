{pkgs, ...}: {
  imports = [
    ../postgresql/default.nix
  ];

  containers.postgresql = {
    bindMounts.keycloak-db-password = {
      mountPoint = "/secrets/keycloak-db-password";
      hostPath = "/run/generated-secrets/keycloak-db-password";
    };
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      networking.firewall.extraCommands = ''
        ip6tables -A nixos-fw -p tcp -s keycloak -m tcp --dport 5432 -m comment --comment keycloak-db -j nixos-fw-accept
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
      };
      systemd.services.postgresql.postStart = lib.mkAfter ''
        $PSQL -c "ALTER USER keycloak PASSWORD '$(cat /secrets/keycloak-db-password)';"
      '';
    };
  };

  systemd.services.keycloak-db-password = {
    requiredBy = ["container@postgresql.service"];
    script = ''
      umask 077
      mkdir -pv /run/generated-secrets
      cat /dev/urandom | tr -dc A-za-z0-9 | head -c 16 > /run/generated-secrets/keycloak-db-password
    '';
  };
}
