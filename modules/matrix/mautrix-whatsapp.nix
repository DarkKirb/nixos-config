{ config, pkgs, lib, ... }:
with lib;
let
  dataDir = "/var/lib/mautrix-whatsapp";
  registrationFile = "${dataDir}/whatsapp-registration.yaml";
  cfg = config.services.mautrix-whatsapp;
  settingsFormat = pkgs.formats.yaml { };
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-telegram-whatsapp-unsubstituted.yaml" cfg.settings;
  settingsFile = "${dataDir}/config.yaml";
  mautrix-whatsapp = pkgs.callPackage ../../packages/matrix/mautrix-whatsapp.nix { };
in
{
  options = {
    services.mautrix-whatsapp = {
      enable = mkEnableOption "Mautrix-Whatsapp, a Matrix-Whatsapp hybrid puppeting/relaybot bridge";
      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          appservice = {
            address = "http://localhost:29318";
            hostname = "0.0.0.0";
            port = 29318;
            database = {
              type = "sqlite";
              uri = "sqlite:///${dataDir}/mautrix-telegram.db";
            };
            as_token = "$AS_TOKEN";
            hs_token = "$HS_TOKEN";
          };
          logging = {
            file_name_format = null;
          };
        };
      };
      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing environment variables to be passed to the mautrix-telegram service,
          in which secret tokens can be specified securely by defining values for
          <literal>MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN</literal>,
          <literal>MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN</literal>,
          <literal>MAUTRIX_TELEGRAM_TELEGRAM_API_ID</literal>,
          <literal>MAUTRIX_TELEGRAM_TELEGRAM_API_HASH</literal> and optionally
          <literal>MAUTRIX_TELEGRAM_TELEGRAM_BOT_TOKEN</literal>.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.mautrix-whatsapp-genregistration = {
      description = "Mautrix-Whatsapp Registration";

      wantedBy = [ "matrix-synapse.service" ];
      before = [ "matrix-synapse.service" ];
      script = ''
        # Not all secrets can be passed as environment variable (yet)
        # https://github.com/tulir/mautrix-telegram/issues/584
        [ -f ${settingsFile} ] && rm -f ${settingsFile}
        old_umask=$(umask)
        umask 0177
        export AS_TOKEN="This value is generated when generating the registration"
        export HS_TOKEN="This value is generated when generating the registration"
        ${pkgs.envsubst}/bin/envsubst \
          -o ${settingsFile} \
          -i ${settingsFileUnsubstituted}
        umask $old_umask

        [ -f ${registrationFile} ] && rm -f ${registrationFile}
        ${mautrix-whatsapp}/bin/mautrix-whatsapp --generate-registration --config ${settingsFile} --registration ${registrationFile}
        chmod 660 ${registrationFile}

        # Extract the tokens from the registration
        export AS_TOKEN=$(${pkgs.yq}/bin/yq -r '.as_token' ${registrationFile})
        export HS_TOKEN=$(${pkgs.yq}/bin/yq -r '.hs_token' ${registrationFile})
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o ${settingsFile} \
          -i ${settingsFileUnsubstituted}
        umask $old_umask
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        UMask = 0117;
        User = "mautrix-whatsapp";
        Group = "matrix-synapse";
        EnvironmentFile = cfg.environmentFile;
      };
      restartTriggers = [ settingsFileUnsubstituted cfg.environmentFile ];
    };
    systemd.services.mautrix-whatsapp = {
      description = "Mautrix-Whatsapp";
      wantedBy = [ "multi-user.target" ];
      wants = [ "matrix-synapse.service" "mautrix-whatsapp-genregistration.service" ];
      after = [ "matrix-synapse.service" "mautrix-whatsapp-genregistration.service" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        UMask = 0117;
        User = "mautrix-whatsapp";
        Group = "matrix-synapse";
        EnvironmentFile = cfg.environmentFile;
      };
      restartTriggers = [ cfg.environmentFile ];
    };
    users.users.mautrix-whatsapp = {
      description = "Mautrix Whatsapp bridge";
      home = "${dataDir}";
      useDefaultShell = true;
      group = "matrix-synapse";
      isSystemUser = true;
    };
    services.matrix-synapse.settings.app_service_config_files = [
      registrationFile
    ];
  };
}
