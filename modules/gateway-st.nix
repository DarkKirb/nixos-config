{ name, port ? 7777 }: { config, lib, options, pkgs, ... }:
with lib;
let
  gateway = pkgs.callPackage ../packages/gateway-st.nix { };
in
{
  systemd.services."storj-gateway@${name}" = {
    description = "storj gateway ${name}";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      cd $HOME
      mkdir -p ${name}
      echo -n "access: " > ${name}/config.yaml
      cat /run/secrets/services/storj/${name}/accessGrant >> ${name}/config.yaml
      echo "" >> ${name}/config.yaml
      echo -n "minio.access-key: " >> ${name}/config.yaml
      cat /run/secrets/services/storj/${name}/accessKey >> ${name}/config.yaml
      echo "" >> ${name}/config.yaml
      echo -n "minio.secret-key: " >> ${name}/config.yaml
      cat /run/secrets/services/storj/${name}/secretKey >> ${name}/config.yaml
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
  users.users.storj = {
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
  sops.secrets."services/storj/${name}/accessGrant".owner = "storj";
  sops.secrets."services/storj/${name}/accessKey".owner = "storj";
  sops.secrets."services/storj/${name}/secretKey".owner = "storj";
}
