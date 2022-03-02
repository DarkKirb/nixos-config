{ config, lib, options, pkgs, ... }:
with lib;
let
  gateway = pkgs.callPackage ../packages/gateway-st.nix { };
  cfg = config.services.storj-gateway;
  opt = options.services.storj-gateway;
in
{
  options.services.storj-gateway = mkOption {
    default = { };
    description = "Storj gateway";
    type = types.attrsOf (types.submodule {
      options = {
        enable = mkOption {
          default = true;
          description = "Enable Storj gateway";
          type = types.bool;
        };
        accessGrantFile = mkOption {
          description = "File containing the access key";
          type = types.str;
        };
        accessKeyFile = mkOption {
          description = "File containing the access key";
          type = types.str;
        };
        secretKeyFile = mkOption {
          description = "File containing the secret key";
          type = types.str;
        };
        port = mkOption {
          default = 7777;
          description = "Port to listen on";
          type = types.ints.port;
        };
      };
    });
  };
  config = mkMerge (map
    (name: mkIf cfg.${name}.enable
      {
        systemd.services."storj-gateway@${name}" = {
          description = "storj gateway ${name}";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          preStart = let cfg = cfg.${name}; in
            ''
              cd $HOME
              mkdir -p ${name}
              echo -n "access: " > ${name}/config.yaml
              cat ${cfg.accessGrantFile} >> ${name}/config.yaml
              echo "" >> ${name}/config.yaml
              echo -n "minio.access-key: " >> ${name}/config.yaml
              cat ${cfg.accessKeyFile} >> ${name}/config.yaml
              echo "" >> ${name}/config.yaml
              echo -n "minio.secret-key: " >> ${name}/config.yaml
              cat ${cfg.secretKeyFile} >> ${name}/config.yaml
              echo "" >> ${name}/config.yaml
            '';
          serviceConfig = {
            Type = "simple";
            User = "storj";
            Group = "storj";
            WorkingDirectory = "/var/lib/storj";
            ExecStart = "${gateway}/bin/gateway run --config-dir /var/lib/storj/${name} --server.address 127.0.0.1:${cfg.port}";
            Restart = "always";
            RuntimeDirectory = "storj";
            RuntimeDirectoryMode = "0700";
            Umask = "0077";
            ReadWritePaths = [ "/var/lib/storj" ]; # Grant access to the state directory
          };
          environment = {
            USER = "storj";
            HOME = "/var/lib/storj";
          };
        };
        users.users.storj = mkDefault {
          description = "storj user";
          home = "/var/lib/storj";
          useDefaultShell = true;
          group = "storj";
          isSystemUser = true;
        };
        users.groups.storj = { };
        systemd.tmpfiles.rules = [
          "d '/var/lib/storj' 0700 storj storj - -"
        ];
      })
    (builtins.attrNames cfg));
}
