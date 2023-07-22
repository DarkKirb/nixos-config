{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.gitea;
  opt = options.services.gitea;
  exe = lib.getExe cfg.package;
  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";
  format = pkgs.formats.ini {};
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod
    ${generators.toINI {} cfg.settings}
    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
  '';
in {
  options = {
    services.gitea = {
      storageSecretFile = mkOption {
        type = with types; str;
        default = "";
        description = ''
          Storage secret to be inserted into the config at #STORAGE_SECRET#
        '';
        example = literalExpression ''"/run/secrets/gitea/storage-secret"'';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gitea = {
      path = [pkgs.gnupg];
      serviceConfig = {
        SystemCallFilter = mkForce "~@clock @cpu-emulation @debug @module @mount @obsolete @raw-io @reboot @setuid @swap";
        ReadWritePaths = ["/var/lib/gitea/.gnupg"];
        TimeoutSec = "infinity";
      };

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistent at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart = let
        runConfig = "${cfg.customDir}/conf/app.ini";
        secretKey = "${cfg.customDir}/conf/secret_key";
        oauth2JwtSecret = "${cfg.customDir}/conf/oauth2_jwt_secret";
        oldLfsJwtSecret = "${cfg.customDir}/conf/jwt_secret"; # old file for LFS_JWT_SECRET
        lfsJwtSecret = "${cfg.customDir}/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
        internalToken = "${cfg.customDir}/conf/internal_token";
        replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
      in
        lib.mkForce ''
          # copy custom configuration and generate random secrets if needed
          ${optionalString (!cfg.useWizard) ''
            function gitea_setup {
              cp -f '${configFile}' '${runConfig}'
              if [ ! -s '${secretKey}' ]; then
                  ${exe} generate secret SECRET_KEY > '${secretKey}'
              fi
              # Migrate LFS_JWT_SECRET filename
              if [[ -s '${oldLfsJwtSecret}' && ! -s '${lfsJwtSecret}' ]]; then
                  mv '${oldLfsJwtSecret}' '${lfsJwtSecret}'
              fi
              if [ ! -s '${oauth2JwtSecret}' ]; then
                  ${exe} generate secret JWT_SECRET > '${oauth2JwtSecret}'
              fi
              ${lib.optionalString cfg.lfs.enable ''
              if [ ! -s '${lfsJwtSecret}' ]; then
                  ${exe} generate secret LFS_JWT_SECRET > '${lfsJwtSecret}'
              fi
            ''}
              if [ ! -s '${internalToken}' ]; then
                  ${exe} generate secret INTERNAL_TOKEN > '${internalToken}'
              fi
              chmod u+w '${runConfig}'
              ${replaceSecretBin} '#secretkey#' '${secretKey}' '${runConfig}'
              ${replaceSecretBin} '#dbpass#' '${cfg.database.passwordFile}' '${runConfig}'
              ${replaceSecretBin} '#oauth2jwtsecret#' '${oauth2JwtSecret}' '${runConfig}'
              ${replaceSecretBin} '#internaltoken#' '${internalToken}' '${runConfig}'
              ${lib.optionalString cfg.lfs.enable ''
              ${replaceSecretBin} '#lfsjwtsecret#' '${lfsJwtSecret}' '${runConfig}'
            ''}
              ${lib.optionalString (cfg.mailerPasswordFile != null) ''
              ${replaceSecretBin} '#mailerpass#' '${cfg.mailerPasswordFile}' '${runConfig}'
            ''}
              ${lib.optionalString (cfg.storageSecretFile != null) ''
              ${replaceSecretBin} '#storageSecret#' '${cfg.storageSecretFile}' '${runConfig}'
            ''}
              chmod u-w '${runConfig}'
            }
            (umask 027; gitea_setup)
          ''}
          # run migrations/init the database
          ${exe} migrate
          # update all hooks' binary paths
          ${exe} admin regenerate hooks
          # update command option in authorized_keys
          if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
          then
            ${exe} admin regenerate keys
          fi
        '';
    };
  };
}
