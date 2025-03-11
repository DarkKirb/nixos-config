{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  dataDir = "/var/lib/mautrix-slack";
  registrationFile = config.sops.secrets."services/mautrix/slack.yaml".path;
  cfg = config.services.mautrix-slack;
  settingsFormat = pkgs.formats.yaml { };
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-slack-config-unsubstituted.yaml" cfg.settings;
  settingsFile = "${dataDir}/config.yaml";
  inherit (pkgs) mautrix-slack;
in
{
  options = {
    services.mautrix-slack = {
      enable = mkEnableOption "Mautrix-Whatsapp, a Matrix-Whatsapp hybrid puppeting/relaybot bridge";
      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          appservice = {
            address = "http://localhost:5216";
            hostname = "0.0.0.0";
            port = 5216;
            as_token = "$AS_TOKEN";
            hs_token = "$HS_TOKEN";
          };
          logging = {
            min_level = "debug";
            writers = [
              {
                type = "stdout";
                format = "pretty-colored";
              }
            ];
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
    systemd.services.mautrix-slack-genregistration = {
      description = "Mautrix-slack Registration";

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
        UMask = 117;
        User = "mautrix-slack";
        Group = "mautrix-slack";
        EnvironmentFile = cfg.environmentFile;
      };
      restartTriggers = [
        settingsFileUnsubstituted
        cfg.environmentFile
      ];
    };
    systemd.services.mautrix-slack = {
      description = "Mautrix-slack";
      path = with pkgs; [
        ffmpeg
        lottieconverter
      ];
      wantedBy = [ "multi-user.target" ];
      wants = [ "mautrix-slack-genregistration.service" ];
      after = [ "mautrix-slack-genregistration.service" ];
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
        UMask = 117;
        User = "mautrix-slack";
        Group = "mautrix-slack";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = ''
          ${mautrix-slack}/bin/mautrix-slack \
            --config='${settingsFile}'
        '';
      };
      restartTriggers = [ cfg.environmentFile ];
    };
    users.users.mautrix-slack = {
      description = "Mautrix Whatsapp bridge";
      home = "${dataDir}";
      useDefaultShell = true;
      group = "mautrix-slack";
      isSystemUser = true;
    };
    users.groups.mautrix-slack = { };
  };
}
