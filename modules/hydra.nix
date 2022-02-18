{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.hydra;

  baseDir = "/var/lib/hydra";

  hydraConf = pkgs.writeScript "hydra.conf" cfg.extraConfig;
  localDB = "dbi:Pg:dbname=hydra;user=hydra;";
  haveLocalDB = cfg.dbi == localDB;
in

{
  ###### interface
  options = {

    services.hydra = {
      giteaTokenFile = mkOption {
        type = with types; str;
        default = "";
        description = ''
          Path to the gitea token secret
        '';
        example = literalExpression ''"/run/secrets/hydra/gitea-token"'';
      };
    };
  };


  config = mkIf cfg.enable {

    systemd.services.hydra-init =
      {
        preStart = lib.mkForce ''
          mkdir -p ${baseDir}
          chown hydra.hydra ${baseDir}
          chmod 0750 ${baseDir}

          cp ${hydraConf} ${baseDir}/hydra.conf
          ${if (cfg.giteaTokenFile == "") then ''
            GITEA_TOKEN="#gitea_token#"
          '' else ''
            GITEA_TOKEN="$(head -n 1 ${cfg.giteaTokenFile})"
          ''}

          sed -i -e "s|#gitea_token#|$GITEA_TOKEN|" ${baseDir}/hydra.conf

          mkdir -m 0700 -p ${baseDir}/www
          chown hydra-www.hydra ${baseDir}/www

          mkdir -m 0700 -p ${baseDir}/queue-runner
          mkdir -m 0750 -p ${baseDir}/build-logs
          chown hydra-queue-runner.hydra ${baseDir}/queue-runner ${baseDir}/build-logs

          ${optionalString haveLocalDB ''
            if ! [ -e ${baseDir}/.db-created ]; then
              ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createuser hydra
              ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createdb -O hydra hydra
              touch ${baseDir}/.db-created
            fi
            echo "create extension if not exists pg_trgm" | ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} -- ${config.services.postgresql.package}/bin/psql hydra
          ''}

          if [ ! -e ${cfg.gcRootsDir} ]; then

            # Move legacy roots directory.
            if [ -e /nix/var/nix/gcroots/per-user/hydra/hydra-roots ]; then
              mv /nix/var/nix/gcroots/per-user/hydra/hydra-roots ${cfg.gcRootsDir}
            fi

            mkdir -p ${cfg.gcRootsDir}
          fi

          # Move legacy hydra-www roots.
          if [ -e /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots ]; then
            find /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots/ -type f \
              | xargs -r mv -f -t ${cfg.gcRootsDir}/
            rmdir /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots
          fi

          chown hydra.hydra ${cfg.gcRootsDir}
          chmod 2775 ${cfg.gcRootsDir}
        '';
      };

  };

}
