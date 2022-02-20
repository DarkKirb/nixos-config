{ config, lib, options, pkgs, ... }:
with lib;
let
  papermc = pkgs.callPackage ../packages/minecraft/paper.nix { };
  cfg = config.services.minecraft;
  opt = options.services.minecraft;
  serverProperties = pkgs.writeText "server.properties" ''
    ${cfg.properties.extraConfig}
  '';
  whitelistJson = pkgs.writeText "whitelist.json" ''
    ${builtins.toJSON cfg.whitelist}
  '';
in
{
  options.services.minecraft = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable minecraft server";
    };
    stateDir = mkOption {
      default = "/var/lib/minecraft";
      type = types.str;
      description = "Path to the minecraft server state directory";
    };
    properties = {
      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = "Extra configuration to be added to the minecraft server properties file";
      };
    };
    whitelist = mkOption {
      default = [ ];
      type = types.listOf (types.submodule {
        options = {
          uuid = mkOption {
            type = types.str;
            description = "UUID of the whitelist entry";
          };
          name = mkOption {
            type = types.str;
            description = "Name of the whitelist entry";
          };
        };
      });
    };
  };
  config = mkIf cfg.enable {
    systemd.services.minecraft = {
      description = "Minecraft Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ papermc ];
      preStart = ''
        cd $HOME
        # Agree to the EULA
        echo "eula=true" > eula.txt
        # Update the server properties
        cp ${serverProperties} server.properties
        # Update the whitelist
        cp ${whitelistJson} whitelist.json
      '';
      serviceConfig = {
        Type = "simple";
        User = "minecraft";
        Group = "minecraft";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${papermc}/bin/minecraft-server";
        Restart = "always";
        RuntimeDirectory = "minecraft";
        RuntimeDirectoryMode = "0755";
        UMask = "0027";
        ReadWritePaths = [ cfg.stateDir ]; # Grant access to the state directory
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
      };
      environment = {
        USER = "minecraft";
        HOME = cfg.stateDir;
      };
    };
    users.users.minecraft = {
      description = "Minecraft Server";
      home = cfg.stateDir;
      useDefaultShell = true;
      group = "minecraft";
      isSystemUser = true;
    };
    users.groups.minecraft = { };
    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' 0750 minecraft minecraft - -"
    ];
  };
}
