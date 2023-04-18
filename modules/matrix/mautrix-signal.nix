{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  dataDir = "/var/lib/mautrix-signal";
  registrationFile = config.secrets."services/imautrix/signal.yaml".path;
  cfg = config.services.mautrix-signal;
  settingsFormat = pkgs.formats.yaml {};
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-signal-config-unsubstituted.yaml" cfg.settings;
  settingsFile = "${dataDir}/config.yaml";
in {
  options = {
    services.mautrix-signal = {
      enable = mkEnableOption "Mautrix-signal, a mautrix-signal hybrid puppeting/relaybot bridge";
      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          appservice = {
            address = "http://localhost:29328";
            hostname = "0.0.0.0";
            port = 29328;
            database = "sqlite:///${dataDir}/mautrix-signal.db";
            as_token = "$AS_TOKEN";
            hs_token = "$HS_TOKEN";
          };
          logging = {
            version = 1;

            formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";

            handlers.console = {
              class = "logging.StreamHandler";
              formatter = "precise";
            };

            loggers = {
              mau.level = "INFO";
              telethon.level = "INFO";

              # prevent tokens from leaking in the logs:
              # https://github.com/tulir/mautrix-telegram/issues/351
              aiohttp.level = "WARNING";
            };

            # log to console/systemd instead of file
            root = {
              level = "INFO";
              handlers = ["console"];
            };
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
    systemd.services.mautrix-signal-genregistration = {
      description = "Mautrix-signal Registration";
      script = ''
        # Not all secrets can be passed as environment variable (yet)
        # https://github.com/tulir/mautrix-telegram/issues/584
        [ -f ${settingsFile} ] && rm -f ${settingsFile}
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
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        UMask = 0117;
        User = "mautrix-signal";
        Group = "mautrix-signal";
        EnvironmentFile = cfg.environmentFile;
      };
      restartTriggers = [settingsFileUnsubstituted cfg.environmentFile];
    };
    systemd.services.mautrix-signal = {
      description = "Mautrix-signal";
      wantedBy = ["multi-user.target"];
      wants = ["matrix-synapse.service" "mautrix-signal-genregistration.service" "signald.service"];
      after = ["matrix-synapse.service" "mautrix-signal-genregistration.service" "signald.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";

        WorkingDirectory = dataDir;
        User = "mautrix-signal";
        Group = "mautrix-signal";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = ''
          ${pkgs.mautrix-signal}/bin/mautrix-signal \
            --config='${settingsFile}'
        '';
      };
      restartTriggers = [cfg.environmentFile];
    };
    users.users.mautrix-signal = {
      description = "Mautrix signal bridge";
      home = "${dataDir}";
      useDefaultShell = true;
      group = "mautrix-signal";
      isSystemUser = true;
    };
    users.groups.mautrix-signal = {};
    services.signald = {
      user = "mautrix-signal";
      group = "mautrix-signal";
      enable = true;
    };
    sops.secrets."services/mautrix/signal.yaml".owner = "mautrix-signal";
  };
}
