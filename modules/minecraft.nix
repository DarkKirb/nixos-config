{ config, lib, options, pkgs, ... }:
with lib;
let
  papermc = pkgs.callPackage ../packages/minecraft/paper.nix { };
  cfg = config.services.minecraft;
  opt = options.services.minecraft;
  serverProperties = pkgs.writeText "server.properties" ''
    ${generators.toKeyValue {} cfg.properties.extraConfig}
  '';
  whitelistJson = pkgs.writeText "whitelist.json" ''
    ${builtins.toJSON cfg.whitelist}
  '';
  bukkitYaml = pkgs.writeText "bukkit.yml" ''
    ${generators.toYAML {} cfg.bukkit-yml}
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
      allow-flight = mkOption {
        default = false;
        type = types.bool;
        description = "Allow flight";
      };
      allow-nether = mkOption {
        default = true;
        type = types.bool;
        description = "Allow nether";
      };
      broadcast-console-to-ops = mkOption {
        default = true;
        type = types.bool;
        description = "Broadcast console to ops";
      };
      broadcast-rcon-to-ops = mkOption {
        default = true;
        type = types.bool;
        description = "Broadcast rcon to ops";
      };
      difficulty = mkOption {
        default = "normal";
        type = types.enum [ "peacful" "easy" "normal" "hard" ];
        description = "Difficulty";
      };
      enable-command-block = mkOption {
        default = false;
        type = types.bool;
        description = "Enable command block";
      };
      enable-jmx-monitoring = mkOption {
        default = false;
        type = types.bool;
        description = "Enable JMX monitoring";
      };
      enable-rcon = mkOption {
        default = false;
        type = types.bool;
        description = "Enable rcon";
      };
      sync-chunk-writes = mkOption {
        default = true;
        type = types.bool;
        description = "Sync chunk writes";
      };
      enable-status = mkOption {
        default = true;
        type = types.bool;
        description = "Enable status";
      };
      enable-query = mkOption {
        default = false;
        type = types.bool;
        description = "Enable query";
      };
      entity-broadcast-range-percentage = mkOption {
        default = 100;
        type = types.ints.between 10 1000;
        description = "Entity broadcast range percentage";
      };
      force-gamemode = mkOption {
        default = false;
        type = types.bool;
        description = "Force gamemode";
      };
      function-permission-level = mkOption {
        default = 2;
        type = types.ints.between 1 4;
        description = "Function permission level";
      };
      gamemode = mkOption {
        default = "survival";
        type = types.enum [ "survival" "creative" "adventure" "spectator" ];
        description = "Gamemode";
      };
      generate-structures = mkOption {
        default = true;
        type = types.bool;
        description = "Generate structures";
      };
      generator-settings = mkOption {
        default = "";
        type = types.oneOf [ types.str (types.attrsOf types.anything) ];
        description = "Generator settings";
        apply = val: if (builtins.isString val) then val else builtins.toJSON val;
      };
      hardcore = mkOption {
        default = false;
        type = types.bool;
        description = "Hardcore";
      };
      level-name = mkOption {
        default = "world";
        type = types.str;
        description = "Level name";
      };
      level-seed = mkOption {
        default = "";
        type = types.str;
        description = "Level seed";
      };
      level-type = mkOption {
        default = "default";
        type = types.enum [ "default" "flat" "largeBiomes" "amplified" ];
        description = "Level type";
      };
      max-players = mkOption {
        default = 20;
        type = types.ints.unsigned;
        description = "Max players";
      };
      max-tick-time = mkOption {
        default = 60000;
        type = types.int;
        description = "Max tick time";
      };
      world-size = mkOption {
        default = 29999984;
        type = types.ints.between 1 29999984;
        description = "World size";
      };
      motd = mkOption {
        default = "A Minecraft server";
        type = types.str;
        description = "Message of the day";
      };
      network-compression-threshold = mkOption {
        default = 256;
        type = types.int;
        description = "Network compression threshold";
      };
      online-mode = mkOption {
        default = true;
        type = types.bool;
        description = "Online mode";
      };
      permission-level = mkOption {
        default = 4;
        type = types.ints.between 0 4;
        description = "Permission level";
      };
      player-idle-timeout = mkOption {
        default = 0;
        type = types.ints.unsigned;
        description = "Player idle timeout";
      };
      prevent-proxy-connections = mkOption {
        default = false;
        type = types.bool;
        description = "Prevent proxy connections";
      };
      pvp = mkOption {
        default = true;
        type = types.bool;
        description = "PvP";
      };
      query-port = mkOption {
        default = 25565;
        type = types.port;
        description = "Query port";
      };
      rate-limit = mkOption {
        default = 0;
        type = types.ints.unsigned;
        description = "Rate limit";
      };
      rcon-password-file = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = "Rcon password file";
      };
      rcon-port = mkOption {
        default = 25575;
        type = types.port;
        description = "Rcon port";
      };
      resource-pack = mkOption {
        default = "";
        type = types.str;
        description = "Resource pack";
      };
      resource-pack-prompt = mkOption {
        default = "";
        type = types.str;
        description = "Resource pack prompt";
      };
      resource-pack-sha1 = mkOption {
        default = "";
        type = types.str;
        description = "Resource pack sha1";
      };
      require-resource-pack = mkOption {
        default = false;
        type = types.bool;
        description = "Require resource pack";
      };
      server-ip = mkOption {
        default = "";
        type = types.str;
        description = "Server ip";
      };
      server-port = mkOption {
        default = 25565;
        type = types.port;
        description = "Server port";
      };
      simulation-distance = mkOption {
        default = 10;
        type = types.ints.between 3 32;
        description = "Simulation distance";
      };
      snooper-enabled = mkOption {
        default = true;
        type = types.bool;
        description = "Snooper enabled";
      };
      spawn-animals = mkOption {
        default = true;
        type = types.bool;
        description = "Enable animals";
      };
      spawn-monsters = mkOption {
        default = true;
        type = types.bool;
        description = "Enable monsters";
      };
      spawn-npcs = mkOption {
        default = true;
        type = types.bool;
        description = "Enable npcs";
      };
      spawn-protection = mkOption {
        default = 16;
        type = types.ints.between 0 256;
        description = "Spawn protection";
      };
      use-native-transport = mkOption {
        default = true;
        type = types.bool;
        description = "Use native transport";
      };
      view-distance = mkOption {
        default = 10;
        type = types.ints.between 3 32;
        description = "View distance";
      };
      white-list = mkOption {
        default = cfg.whitelist != [ ];
        type = types.bool;
        description = "White list";
      };
      enforce-whitelist = mkOption {
        default = false;
        type = types.bool;
        description = "Enforce whitelist";
      };
      extraConfig = mkOption {
        default = { };
        type = types.attrsOf types.anything;
        description = "Extra configuration to be added to the minecraft server properties file";
      };
    };
    bukkit-yml = mkOption {
      description = "Bukkit configuration file";
      type = types.submodule {
        options = {
          settings = mkOption {
            descriptions = "General CraftBukkit settings";
            type = types.submodule {
              options = {
                allow-end = mkOption {
                  default = true;
                  type = types.bool;
                  description = "Allow end";
                };
                warn-on-overload = mkOption {
                  default = true;
                  type = types.bool;
                  description = "Warn on overload";
                };
                permissions-file = mkOption {
                  default = "permissions.yml";
                  type = types.str;
                  description = "Permissions file";
                };
                update-folder = mkOption {
                  default = "update";
                  type = types.str;
                  description = "Update folder";
                };
                ping-packet-limit = mkOption {
                  default = 100;
                  type = types.ints.between 0 1000;
                  description = "Ping packet limit";
                };
                use-exact-login-location = mkOption {
                  default = false;
                  type = types.bool;
                  description = "Use exact login location";
                };
                world-container = mkOption {
                  default = "world";
                  type = types.str;
                  description = "World container";
                };
                plugin-profiling = mkOption {
                  default = false;
                  type = types.bool;
                  description = "Plugin profiling";
                };
                connection-throttle = mkOption {
                  default = 0;
                  type = types.ints.unsigned;
                  description = "Connection throttle";
                };
                query-plugins = mkOption {
                  default = true;
                  type = types.bool;
                  description = "Query plugins";
                };
                deprecated-verbose = mkOption {
                  default = "default";
                  type = types.enum [ true false "default" ];
                  description = "Deprecated verbose";
                };
                shutdown-message = mkOption {
                  default = "Server closed";
                  type = types.str;
                  description = "Shutdown message";
                };
              };
            };
          };
          spawn-limits = mkOption {
            description = "Spawn limits";
            type = types.submodule {
              options = {
                monsters = mkOption {
                  default = 70;
                  type = types.ints.unsigned;
                  description = "Max monsters";
                };
                animals = mkOption {
                  default = 15;
                  type = types.ints.unsigned;
                  description = "Max animals";
                };
                water-animals = mkOption {
                  default = 5;
                  type = types.ints.unsigned;
                  description = "Max water animals";
                };
                ambient = mkOption {
                  default = 15;
                  type = types.ints.unsigned;
                  description = "Max ambient";
                };
              };
            };
          };
          chunk-gc = mkOption {
            description = "Chunk garbage collection";
            type = types.submodule {
              options = {
                period-in-ticks = mkOption {
                  default = 600;
                  type = types.ints.unsigned;
                  description = "Period in ticks";
                };
                load-threshold = mkOption {
                  default = 0;
                  type = types.ints.unsigned;
                  description = "Load threshold";
                };
              };
            };
          };
          ticks-per = mkOption {
            description = "Tick delays";
            type = types.submodule {
              options = {
                animal-spawns = mkOption {
                  default = 400;
                  type = types.ints.unsigned;
                  description = "Animal spawns";
                };
                monster-spawns = mkOption {
                  default = 1;
                  type = types.ints.unsigned;
                  description = "Monster spawns";
                };
                autosave = mkOption {
                  default = 6000;
                  type = types.ints.unsigned;
                  description = "Autosave";
                };
              };
            };
          };
        };
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
    services.minecraft.properties.extraConfig = with cfg.properties; lib.mkDefault {
      inherit allow-flight allow-nether broadcast-console-to-ops broadcast-rcon-to-ops;
      inherit difficulty enable-command-block enable-jmx-monitoring enable-rcon sync-chunk-writes;
      inherit enable-status enable-query entity-broadcast-range-percentage force-gamemode;
      inherit function-permission-level gamemode generate-structures generator-settings hardcore;
      inherit level-name level-seed level-type max-players max-tick-time motd;
      inherit network-compression-threshold online-mode permission-level player-idle-timeout;
      inherit prevent-proxy-connections pvp rate-limit resource-pack resource-pack-prompt;
      inherit resource-pack-sha1 require-resource-pack server-ip server-port;
      inherit simulation-distance snooper-enabled spawn-animals spawn-monsters spawn-npcs;
      inherit spawn-protection use-native-transport view-distance white-list enforce-whitelist;

      "query.port" = query-port;
      "rcon.port" = rcon-port;
    };
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
        cat ${serverProperties} > server.properties
        ${if cfg.rcon-password-file != "" then ''
          echo "rcon.password=$(cat ${cfg.rcon-password-file})" >> server.properties
        '' else "" }
        # Update the whitelist
        cat ${whitelistJson} > whitelist.json
        # Update the bukkit yml
        cat ${bukkitYaml} > bukkit.yml
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

