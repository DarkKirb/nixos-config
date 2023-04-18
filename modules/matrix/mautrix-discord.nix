{
  nix-packages,
  system,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  dataDir = "/var/lib/mautrix-discord";
  registrationFile = config.secrets."services/mautrix/discord.yaml".path;
  cfg = config.services.mautrix-discord;
  settingsFormat = pkgs.formats.yaml {};
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-discord-config-unsubstituted.yaml" cfg.settings;
  settingsFile = "${dataDir}/config.yaml";
  inherit (nix-packages.packages.${system}) mautrix-discord;
in {
  options = {
    services.mautrix-discord = {
      enable = mkEnableOption "Mautrix-Whatsapp, a Matrix-Whatsapp hybrid puppeting/relaybot bridge";
      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          appservice = {
            address = "http://localhost:29320";
            hostname = "0.0.0.0";
            port = 29320;
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
    systemd.services.mautrix-discord-genregistration = {
      description = "Mautrix-Discord Registration";

      requiredBy = ["matrix-synapse.service"];
      before = ["matrix-synapse.service"];
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
        # Not all secrets can be passed as environment variable (yet)
        # https://github.com/tulir/mautrix-telegram/issues/584
        [ -f ${settingsFile} ] && rm -f ${settingsFile}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ReadWritePaths = baseNameOf dataDir;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        UMask = 0117;
        User = "mautrix-discord";
        Group = "mautrix-discord";
        EnvironmentFile = cfg.environmentFile;
      };
      restartTriggers = [settingsFileUnsubstituted cfg.environmentFile];
    };
    systemd.services.mautrix-discord = {
      description = "Mautrix-Discord";
      wantedBy = ["multi-user.target"];
      wants = ["matrix-synapse.service" "mautrix-discord-genregistration.service"];
      after = ["matrix-synapse.service" "mautrix-discord-genregistration.service"];
      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ReadWritePaths = baseNameOf dataDir;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        UMask = 0117;
        User = "mautrix-discord";
        Group = "mautrix-discord";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = ''
          ${mautrix-discord}/bin/mautrix-discord \
            --config='${settingsFile}'
        '';
      };
      restartTriggers = [cfg.environmentFile];
    };
    users.users.mautrix-discord = {
      description = "Mautrix Whatsapp bridge";
      home = "${dataDir}";
      useDefaultShell = true;
      group = "mautrix-discord";
      isSystemUser = true;
    };
    users.groups.mautrix-discord = {};
    sops.secrets."services/mautrix/discord.yaml".owner = "mautrix-discord";
  };
}
