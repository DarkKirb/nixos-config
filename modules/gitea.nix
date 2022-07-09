{
  config,
  lib,
  options,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.gitea;
  gitea = cfg.package;
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
        SystemCallFilter = mkForce "~@clock @cpu-emulation @debug @module @mount @obsolete @raw-io @reboot @resources @setuid @swap";
        ReadOnlyPaths = ["/var/lib/gitea/.gnupg"];
      };
      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistant at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
        oauth2JwtSecret = "${cfg.stateDir}/custom/conf/oauth2_jwt_secret";
        oldLfsJwtSecret = "${cfg.stateDir}/custom/conf/jwt_secret"; # old file for LFS_JWT_SECRET
        lfsJwtSecret = "${cfg.stateDir}/custom/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
        internalToken = "${cfg.stateDir}/custom/conf/internal_token";
      in ''
        # copy custom configuration and generate a random secret key if needed
        ${optionalString (!cfg.useWizard) ''
          function gitea_setup {
            cp -f ${configFile} ${runConfig}

            if [ ! -e ${secretKey} ]; then
                ${gitea}/bin/gitea generate secret SECRET_KEY > ${secretKey}
            fi

            # Migrate LFS_JWT_SECRET filename
            if [[ -e ${oldLfsJwtSecret} && ! -e ${lfsJwtSecret} ]]; then
                mv ${oldLfsJwtSecret} ${lfsJwtSecret}
            fi

            if [ ! -e ${oauth2JwtSecret} ]; then
                ${gitea}/bin/gitea generate secret JWT_SECRET > ${oauth2JwtSecret}
            fi

            if [ ! -e ${lfsJwtSecret} ]; then
                ${gitea}/bin/gitea generate secret LFS_JWT_SECRET > ${lfsJwtSecret}
            fi

            if [ ! -e ${internalToken} ]; then
                ${gitea}/bin/gitea generate secret INTERNAL_TOKEN > ${internalToken}
            fi

            SECRETKEY="$(head -n1 ${secretKey})"
            DBPASS="$(head -n1 ${cfg.database.passwordFile})"
            OAUTH2JWTSECRET="$(head -n1 ${oauth2JwtSecret})"
            LFSJWTSECRET="$(head -n1 ${lfsJwtSecret})"
            INTERNALTOKEN="$(head -n1 ${internalToken})"
            ${
            if (cfg.mailerPasswordFile == null)
            then ''
              MAILERPASSWORD="#mailerpass#"
            ''
            else ''
              MAILERPASSWORD="$(head -n1 ${cfg.mailerPasswordFile} || :)"
            ''
          }
            ${
            if (cfg.storageSecretFile == "")
            then ''
              STORAGESECRET="#storageSecret#"
            ''
            else ''
              STORAGESECRET="$(head -n1 ${cfg.storageSecretFile} || :)"
            ''
          }
            sed -e "s,#secretkey#,$SECRETKEY,g" \
                -e "s,#dbpass#,$DBPASS,g" \
                -e "s,#oauth2jwtsecret#,$OAUTH2JWTSECRET,g" \
                -e "s,#lfsjwtsecret#,$LFSJWTSECRET,g" \
                -e "s,#internaltoken#,$INTERNALTOKEN,g" \
                -e "s,#mailerpass#,$MAILERPASSWORD,g" \
                -e "s,#storageSecret#,$STORAGESECRET,g" \
                -i ${runConfig}
          }
          (umask 027; gitea_setup)
        ''}

        # run migrations/init the database
        ${gitea}/bin/gitea migrate

        # update all hooks' binary paths
        ${gitea}/bin/gitea admin regenerate hooks

        # update command option in authorized_keys
        if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
        then
          ${gitea}/bin/gitea admin regenerate keys
        fi
      '';
    };
  };
}
