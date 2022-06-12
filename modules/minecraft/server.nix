{ nix-packages, system, config, lib, options, pkgs, ... }:
with lib;
let
  papermc = nix-packages.packages.${system}.papermc;
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
  spigotYaml = pkgs.writeText "spigot.yml" ''
    ${generators.toYAML {} cfg.spigot-yml}
  '';
  paperYaml = pkgs.writeText "paper.yml" ''
    ${generators.toYAML {} cfg.paper-yml}
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
    bukkit-yml = {
      settings = {
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
      spawn-limits = {
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
      chunk-gc = {
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
      ticks-per = {
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
    spigot-yml = {
      settings = {
        debug = mkOption {
          default = false;
          type = types.bool;
          description = "Debug";
        };
        bungeecord = mkOption {
          default = false;
          type = types.bool;
          description = "Bungeecord";
        };
        timout-time = mkOption {
          default = 60;
          type = types.ints.unsigned;
          description = "Timeout time";
        };
        restart-on-crash = mkOption {
          default = true;
          type = types.bool;
          description = "Restart on crash";
        };
        restart-script = mkOption {
          default = "./start.sh";
          type = types.str;
          description = "Restart script";
        };
        netty-threads = mkOption {
          default = 4;
          type = types.ints.unsigned;
          description = "Netty threads";
        };
        log-villager-deaths = mkOption {
          default = false;
          type = types.bool;
          description = "Log villager deaths";
        };
        log-named-deaths = mkOption {
          default = false;
          type = types.bool;
          description = "Log named deaths";
        };
        sample-count = mkOption {
          default = 12;
          type = types.ints.unsigned;
          description = "Sample count";
        };
        player-shuffle = mkOption {
          default = 0;
          type = types.ints.unsigned;
          description = "Player shuffle";
        };
        user-cache-size = mkOption {
          default = 1000;
          type = types.ints.unsigned;
          description = "User cache size";
        };
        save-user-cache-on-stop-only = mkOption {
          default = false;
          type = types.bool;
          description = "Save user cache on stop only";
        };
        moved-wrongly-threshold = mkOption {
          default = 0.0625;
          type = types.float;
          description = "Moved wrongly threshold";
        };
        moved-too-quickly-multiplier = mkOption {
          default = 10.0;
          type = types.float;
          description = "Moved too quickly multiplier";
        };
      };
      messages = {
        whitelist = mkOption {
          default = "You are not whitelisted on this server!";
          type = types.str;
          description = "Whitelist message";
        };
        unknown-command = mkOption {
          default = "Unknown command. Type \"/help\" for help.";
          type = types.str;
          description = "Unknown command message";
        };
        server-full = mkOption {
          default = "The server is full!";
          type = types.str;
          description = "Server full message";
        };
        outdated-client = mkOption {
          default = "Outdated client! Please use {0}";
          type = types.str;
          description = "Outdated client message";
        };
        outdated-server = mkOption {
          default = "Outdated server! I'm still on {0}";
          type = types.str;
          description = "Outdated server message";
        };
        restart = mkOption {
          default = "Server is restarting";
          type = types.str;
          description = "Restart message";
        };
      };
      advancements = {
        disable-saving = mkOption {
          default = false;
          type = types.bool;
          description = "Disable saving";
        };
        disabled = mkOption {
          default = [ ];
          type = types.listOf types.str;
          description = "Disabled Advancements";
        };
      };
      config-version = mkOption {
        default = 12;
        type = types.ints.unsigned;
        description = "Config version";
      };
      stats = {
        disable-saving = mkOption {
          default = false;
          type = types.bool;
          description = "Disable saving";
        };
      };
      commands = {
        replace-commands = mkOption {
          default = [ "setblock" "summon" "testforblock" "tellraw" ];
          type = types.listOf types.str;
          description = "Replace commands";
        };
        spam-exclusions = mkOption {
          default = [ "/skill" ];
          type = types.listOf types.str;
          description = "Spam exclusions";
        };
        silent-commandblock-console = mkOption {
          default = false;
          type = types.bool;
          description = "Silent commandblock console";
        };
        log = mkOption {
          default = true;
          type = types.bool;
          description = "Log";
        };
        tab-complete = mkOption {
          default = 0;
          type = types.int;
          description = "Tab complete";
        };
        send-namespaced = mkOption {
          default = true;
          type = types.bool;
          description = "Send namespaced";
        };
      };
      players = {
        disable-saving = mkOption {
          default = false;
          type = types.bool;
          description = "Disable saving";
        };
      };
      world-settings = mkOption {
        default = { };
        type = types.attrsOf (types.submodule {
          options = {
            below-zero-generation-in-existing-chunks = mkOption {
              default = true;
              type = types.bool;
              description = "Below zero generation in existing chunks";
            };
            verbose = mkOption {
              default = false;
              type = types.bool;
              description = "Verbose";
            };
            enable-zombie-pigmen-portal-spawns = mkOption {
              default = true;
              type = types.bool;
              description = "Enable zombie pigmen portal spawns";
            };
            merge-radius.item = mkOption {
              default = 2.5;
              type = types.float;
              description = "Merge radius.item";
            };
            merge-radius.exp = mkOption {
              default = 3.0;
              type = types.float;
              description = "Merge radius.exp";
            };
            item-despawn-rate = mkOption {
              default = 3000;
              type = types.int;
              description = "Item despawn rate";
            };
            view-distance = mkOption {
              default = "default";
              type = type.oneOf [ types.int types.str ];
              description = "View distance";
            };
            simulation-distance = mkOption {
              default = "default";
              type = type.oneOf [ types.int types.str ];
              description = "Simulation distance";
            };
            thunder-chance = mkOption {
              default = 100000;
              type = types.int;
              description = "Thunder chance";
            };
            wither-spawn-sound-radius = mkOption {
              default = 0;
              type = types.int;
              description = "Wither spawn sound radius";
            };
            arrow-despawn-rate = mkOption {
              default = 1200;
              type = types.int;
              description = "Arrow despawn rate";
            };
            trident-despawn-rate = mkOption {
              default = 1200;
              type = types.int;
              description = "Trident despawn rate";
            };
            hanging-tick-frequency = mkOption {
              default = 100;
              type = types.int;
              description = "Hanging tick frequency";
            };
            zombie-aggressive-towards-villager = mkOption {
              default = true;
              type = types.bool;
              description = "Zombie aggressive towards villager";
            };
            nerf-spawner-mobs = mkOption {
              default = false;
              type = types.bool;
              description = "Nerf spawner mobs";
            };
            mob-spawn-range = mkOption {
              default = 8;
              type = types.int;
              description = "Mob spawn range";
            };
            end-portal-sound-radius = mkOption {
              default = 0;
              type = types.int;
              description = "End portal sound radius";
            };
            entity-activation-range = {
              animals = mkOption {
                default = 32;
                type = types.int;
                description = "Entity activation range.animals";
              };
              monsters = mkOption {
                default = 32;
                type = types.int;
                description = "Entity activation range.monsters";
              };
              raiders = mkOption {
                default = 48;
                type = types.int;
                description = "Entity activation range.raiders";
              };
              misc = mkOption {
                default = 16;
                type = types.int;
                description = "Entity activation range.misc";
              };
              water = mkOption {
                default = 16;
                type = types.int;
                description = "Entity activation range.water";
              };
              villagers = mkOption {
                default = 32;
                type = types.int;
                description = "Entity activation range.villagers";
              };
              flying-monsters = mkOption {
                default = 32;
                type = types.int;
                description = "Entity activation range.flying-monsters";
              };
              wake-up-inactive = {
                animals-max-per-tick = mkOption {
                  default = 4;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.animals-max-per-tick";
                };
                animals-every = mkOption {
                  default = 1200;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.animals-every";
                };
                animals-for = mkOption {
                  default = 100;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.animals-for";
                };
                monsters-max-per-tick = mkOption {
                  default = 8;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.monsters-max-per-tick";
                };
                monsters-every = mkOption {
                  default = 400;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.monsters-every";
                };
                monsters-for = mkOption {
                  default = 100;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.monsters-for";
                };
                villagers-max-per-tick = mkOption {
                  default = 4;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.villagers-max-per-tick";
                };
                villagers-every = mkOption {
                  default = 600;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.villagers-every";
                };
                villagers-for = mkOption {
                  default = 100;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.villagers-for";
                };
                flying-monsters-max-per-tick = mkOption {
                  default = 8;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.flying-monsters-max-per-tick";
                };
                flying-monsters-every = mkOption {
                  default = 200;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.flying-monsters-every";
                };
                flying-monsters-for = mkOption {
                  default = 100;
                  type = types.int;
                  description = "Entity activation range.wake-up-inactive.flying-monsters-for";
                };
              };
              villagers-work-immunity-after = mkOption {
                default = 100;
                type = types.int;
                description = "Entity activation range.villagers-work-immunity-after";
              };
              villagers-work-immunity-for = mkOption {
                default = 20;
                type = types.int;
                description = "Entity activation range.villagers-work-immunity-for";
              };
              villagers-active-for-panic = mkOption {
                default = true;
                type = types.bool;
                description = "Entity activation range.villagers-active-for-panic";
              };
              tick-inactive-villagers = mkOption {
                default = true;
                type = types.bool;
                description = "Entity activation range.tick-inactive-villagers";
              };
              ignore-spectators = mkOption {
                default = false;
                type = types.bool;
                description = "Entity activation range.ignore-spectators";
              };
            };
            entity-tracking-range = {
              players = mkOption {
                default = 48;
                type = types.int;
                description = "Entity tracking range.players";
              };
              animals = mkOption {
                default = 48;
                type = types.int;
                description = "Entity tracking range.animals";
              };
              monsters = mkOption {
                default = 48;
                type = types.int;
                description = "Entity tracking range.monsters";
              };
              misc = mkOption {
                default = 32;
                type = types.int;
                description = "Entity tracking range.misc";
              };
              other = mkOption {
                default = 64;
                type = types.int;
                description = "Entity tracking range.other";
              };
            };
            ticks-per.hopper-transfer = mkOption {
              default = 8;
              type = types.int;
              description = "Ticks per.hopper-transfer";
            };
            ticks-per.hopper-check = mkOption {
              default = 1;
              type = types.int;
              description = "Ticks per.hopper-check";
            };
            hopper-amount = mkOption {
              default = 1;
              type = types.int;
              description = "Hopper amount";
            };
            dragon-death-sound-radius = mkOption {
              default = 0;
              type = types.int;
              description = "Dragon death sound radius";
            };
            seed-village = mkOption {
              default = 10387312;
              type = types.int;
              description = "Seed village";
            };
            seed-desert = mkOption {
              default = 14357617;
              type = types.int;
              description = "Seed desert";
            };
            seed-igloo = mkOption {
              default = 14357618;
              type = types.int;
              description = "Seed igloo";
            };
            seed-jungle = mkOption {
              default = 14357619;
              type = types.int;
              description = "Seed jungle";
            };
            seed-swamp = mkOption {
              default = 14357620;
              type = types.int;
              description = "Seed swamp";
            };
            seed-monument = mkOption {
              default = 10387313;
              type = types.int;
              description = "Seed monument";
            };
            seed-shipwreck = mkOption {
              default = 165745295;
              type = types.int;
              description = "Seed shipwreck";
            };
            seed-ocean = mkOption {
              default = 14357621;
              type = types.int;
              description = "Seed ocean";
            };
            seed-outpost = mkOption {
              default = 165745296;
              type = types.int;
              description = "Seed outpost";
            };
            seed-endcity = mkOption {
              default = 10387313;
              type = types.int;
              description = "Seed endcity";
            };
            seed-slime = mkOption {
              default = 987234911;
              type = types.int;
              description = "Seed slime";
            };
            seed-bastion = mkOption {
              default = 30084232;
              type = types.int;
              description = "Seed bastion";
            };
            seed-fortress = mkOption {
              default = 30084232;
              type = types.int;
              description = "Seed fortress";
            };
            seed-mansion = mkOption {
              default = 10387319;
              type = types.int;
              description = "Seed mansion";
            };
            seed-fossil = mkOption {
              default = 14357921;
              type = types.int;
              description = "Seed fossil";
            };
            seed-portal = mkOption {
              default = 34222645;
              type = types.int;
              description = "Seed portal";
            };
            seed-stronghold = mkOption {
              default = "default";
              type = types.oneOf [ types.int types.str ];
              description = "Seed stronghold";
            };
            hunger = {
              jump-walk-exhaustion = mkOption {
                default = 0.05;
                type = types.float;
                description = "Hunger.jump-walk-exhaustion";
              };
              jump-sprint-exhaustion = mkOption {
                default = 0.20;
                type = types.float;
                description = "Hunger.jump-sprint-exhaustion";
              };
              combat-exhaustion = mkOption {
                default = 0.1;
                type = types.float;
                description = "Hunger.combat-exhaustion";
              };
              regen-exhaustion = mkOption {
                default = 6.0;
                type = types.float;
                description = "Hunger.regen-exhaustion";
              };
              swim-multiplier = mkOption {
                default = 0.01;
                type = types.float;
                description = "Hunger.swim-multiplier";
              };
              sprint-multiplier = mkOption {
                default = 0.1;
                type = types.float;
                description = "Hunger.sprint-multiplier";
              };
              other-multiplier = mkOption {
                default = 0.0;
                type = types.float;
                description = "Hunger.other-multiplier";
              };
            };
            max-tnt-per-tick = mkOption {
              default = 100;
              type = types.int;
              description = "Max tnt per tick";
            };
            max-tick-time = {
              tile = mkOption {
                default = 50;
                type = types.int;
                description = "Max tick time.tile";
              };
              entity = mkOption {
                default = 50;
                type = types.int;
                description = "Max tick time.entity";
              };
            };
            growth = {
              cactus-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.cactus-modifier";
              };
              cane-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.cane-modifier";
              };
              melon-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.melon-modifier";
              };
              mushroom-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.mushroom-modifier";
              };
              pumpkin-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.pumpkin-modifier";
              };
              sapling-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.sapling-modifier";
              };
              beetroot-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.beetroot-modifier";
              };
              carrot-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.carrot-modifier";
              };
              potato-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.potato-modifier";
              };
              wheat-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.wheat-modifier";
              };
              netherwart-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.netherwart-modifier";
              };
              vine-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.vine-modifier";
              };
              cocoa-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.cocoa-modifier";
              };
              bamboo-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.bamboo-modifier";
              };
              sweetberry-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.sweetberry-modifier";
              };
              kelp-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.kelp-modifier";
              };
              twistingvines-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.twistingvines-modifier";
              };
              weepingvines-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.weepingvines-modifier";
              };
              cavevines-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.cavevines-modifier";
              };
              glowberry-modifier = mkOption {
                default = 100;
                type = types.int;
                description = "Growth.glowberry-modifier";
              };
            };
          };
        });
      };
    };
    paper-yml = {
      verbose = mkOption {
        default = false;
        type = types.bool;
        description = "Verbose";
      };
      messages = {
        kick = {
          authentication-servers-shut-down = mkOption {
            default = "";
            type = types.str;
            description = "Kick.authentication-servers-shut-down";
          };
          connection-throttle = mkOption {
            default = "Connection throttled! Please wait before reconnecting.";
            type = types.str;
            description = "Kick.connection-throttle";
          };
          flying-player = mkOption {
            default = "Flying is not enabled on this server.";
            type = types.str;
            description = "Kick.flying-player";
          };
          flying-vehicle = mkOption {
            default = "Flying is not enabled on this server.";
            type = types.str;
            description = "Kick.flying-vehicle";
          };
        };
        no-permission = mkOption {
          default = "&cI'm sorry, but you do not have permission to perform this command.\nPlease contact the server administrators if you believe this is in error.";
          type = types.str;
          description = "No-permission";
        };
      };
      timings = {
        enabled = mkOption {
          default = true;
          type = types.bool;
          description = "Enabled";
        };
        verbose = mkOption {
          default = true;
          type = types.bool;
          description = "Verbose";
        };
        url = mkOption {
          default = "https://timings.aikar.co/";
          type = types.str;
          description = "Url";
        };
        server-name-privacy = mkOption {
          default = false;
          type = types.bool;
          description = "Server-name-privacy";
        };
        hidden-config-entries = mkOption {
          default = [ "database" "settings.bungeecord-addresses" "setitngs.velocity-support.secret" ];
          type = types.listOf types.str;
          description = "Hidden-config-entries";
        };
        history-interval = mkOption {
          default = 300;
          type = types.int;
          description = "History-interval";
        };
        history-length = mkOption {
          default = 3600;
          type = types.int;
          description = "History-length";
        };
        server-name = mkOption {
          default = "Unknown Server";
          type = types.str;
          description = "Server-name";
        };
      };
      config-version = mkOption {
        default = 25;
        type = types.int;
        description = "Config-version";
      };
      settings = {
        use-display-name-in-quit-message = mkOption {
          default = false;
          type = types.bool;
          description = "Settings.use-display-name-in-quit-message";
        };
        load-permissions-yml-before-plugins = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.load-permissions-yml-before-plugins";
        };
        region-file-cache-size = mkOption {
          default = 256;
          type = types.int;
          description = "Settings.region-file-cache-size";
        };
        enable-player-collisions = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.enable-player-collisions";
        };
        save-empty-scoreboard-teams = mkOption {
          default = false;
          type = types.bool;
          description = "Settings.save-empty-scoreboard-teams";
        };
        bungee-online-mode = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.bungee-online-mode";
        };
        incoming-packet-spam-threshold = mkOption {
          default = 300;
          type = types.int;
          description = "Settings.incoming-packet-spam-threshold";
        };
        use-alternative-luck-formula = mkOption {
          default = false;
          type = types.bool;
          description = "Settings.use-alternative-luck-formula";
        };
        velocity-support = {
          enabled = mkOption {
            default = false;
            type = types.bool;
            description = "Velocity-support.enabled";
          };
          online-mode = mkOption {
            default = false;
            type = types.bool;
            description = "Velocity-support.online-mode";
          };
          secret = mkOption {
            default = "";
            type = types.str;
            description = "Velocity-support.secret";
          };
        };
        console-has-all-permissions = mkOption {
          default = false;
          type = types.bool;
          description = "Settings.console-has-all-permissions";
        };
        player-auto-save-rate = mkOption {
          default = -1;
          type = types.int;
          description = "Settings.player-auto-save-rate";
        };
        max-player-auto-save-per-tick = mkOption {
          default = -1;
          type = types.int;
          description = "Settings.max-player-auto-save-per-tick";
        };
        fix-target-selector-tag-completion = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.fix-target-selector-tag-completion";
        };
        lag-compensate-block-breaking = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.lag-compensate-block-breaking";
        };
        send-full-pos-for-hard-colliding-entities = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.send-full-pos-for-hard-colliding-entities";
        };
        time-command-affects-all-worlds = mkOption {
          default = false;
          type = types.bool;
          description = "Settings.time-command-affects-all-worlds";
        };
        max-joins-per-tick = mkOption {
          default = 3;
          type = types.int;
          description = "Settings.max-joins-per-tick";
        };
        track-plugin-scoreboards = mkOption {
          default = false;
          type = types.bool;
          description = "Settings.track-plugin-scoreboards";
        };
        fix-entity-position-desync = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.fix-entity-position-desync";
        };
        log-player-ip-addresses = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.log-player-ip-addresses";
        };
        console = {
          enable-brigadier-highlighting = mkOption {
            default = false;
            type = types.bool;
            description = "Console.enable-brigadier-highlighting";
          };
          enable-brigadier-completion = mkOption {
            default = true;
            type = types.bool;
            description = "Console.enable-brigadier-completion";
          };
        };
        suggest-player-names-when-null-tab-completions = mkOption {
          default = true;
          type = types.bool;
          description = "Settings.suggest-player-names-when-null-tab-completions";
        };
        watchdog = {
          early-warning-every = mkOption {
            default = 5000;
            type = types.int;
            description = "Watchdog.early-warning-every";
          };
          early-warning-delay = mkOption {
            default = 10000;
            type = types.int;
            description = "Watchdog.early-warning-delay";
          };
        };
        spam-limiter = {
          tab-spam-increment = mkOption {
            default = 1;
            type = types.int;
            description = "Spam-limiter.tab-spam-increment";
          };
          tab-spam-limit = mkOption {
            default = 500;
            type = types.int;
            description = "Spam-limiter.tab-spam-limit";
          };
          recipe-spam-increment = mkOption {
            default = 1;
            type = types.int;
            description = "Spam-limiter.recipe-spam-increment";
          };
          recipe-spam-limit = mkOption {
            default = 20;
            type = types.int;
            description = "Spam-limiter.recipe-spam-limit";
          };
        };
        book-size = {
          page-max = mkOption {
            default = 2560;
            type = types.int;
            description = "Book-size.page-max";
          };
          total-multiplier = mkOption {
            default = 0.98;
            type = types.float;
            description = "Book-size.total-multiplier";
          };
        };
        loggers = {
          deobfuscate-stacktraces = mkOption {
            default = true;
            type = types.bool;
            description = "Loggers.deobfuscate-stacktraces";
          };
        };
        item-validation = {
          display-name = mkOption {
            default = 8192;
            type = types.int;
            description = "Item-validation.display-name";
          };
          loc-name = mkOption {
            default = 8192;
            type = types.int;
            description = "Item-validation.loc-name";
          };
          lore-line = mkOption {
            default = 8192;
            type = types.int;
            description = "Item-validation.lore-line";
          };
          book = {
            title = mkOption {
              default = 8192;
              type = types.int;
              description = "Item-validation.book.title";
            };
            author = mkOption {
              default = 8192;
              type = types.int;
              description = "Item-validation.book.author";
            };
            page = mkOption {
              default = 16384;
              type = types.int;
              description = "Item-validation.book.page";
            };
          };
        };
        chunk-loading = {
          min-load-radius = mkOption {
            default = 2;
            type = types.int;
            description = "Chunk-loading.min-load-radius";
          };
          max-concurrent-sends = mkOption {
            default = 2;
            type = types.int;
            description = "Chunk-loading.max-concurrent-sends";
          };
          autoconfig-send-distance = mkOption {
            default = true;
            type = types.bool;
            description = "Chunk-loading.autoconfig-send-distance";
          };
          target-player-chunk-send-rate = mkOption {
            default = 100.0;
            type = types.float;
            description = "Chunk-loading.target-player-chunk-send-rate";
          };
          global-max-chunk-send-rate = mkOption {
            default = -1.0;
            type = types.float;
            description = "Chunk-loading.global-max-chunk-send-rate";
          };
          enable-frustum-priority = mkOption {
            default = true;
            type = types.bool;
            description = "Chunk-loading.enable-frustum-priority";
          };
          global-max-chunk-load-rate = mkOption {
            default = -1.0;
            type = types.float;
            description = "Chunk-loading.global-max-chunk-load-rate";
          };
          player-max-concurrent-loads = mkOption {
            default = 20.0;
            type = types.float;
            description = "Chunk-loading.player-max-concurrent-loads";
          };
          global-max-concurrent-loads = mkOption {
            default = 500.0;
            type = types.float;
            description = "Chunk-loading.global-max-concurrent-loads";
          };
        };
        async-chunks = {
          threads = mkOption {
            default = -1;
            type = types.int;
            description = "Async-chunks.threads";
          };
        };
        packet-limiter = {
          kick-message = mkOption {
            default = "&cSent too many packets";
            type = types.str;
            description = "Packet-limiter.kick-message";
          };
          limits = {
            all = {
              interval = mkOption {
                default = 7.0;
                type = types.float;
                description = "Packet-limiter.limits.all.interval";
              };
              max-packet-rate = mkOption {
                default = 500.0;
                type = types.float;
                description = "Packet-limiter.limits.all.max-packet-rate";
              };
            };
            PacketPlayInAutoRecipe = {
              interval = mkOption {
                default = 4.0;
                type = types.float;
                description = "Packet-limiter.limits.PcketPlayInAutoRecipe.interval";
              };
              max-packet-rate = mkOption {
                default = 5.0;
                type = types.float;
                description = "Packet-limiter.limits.PcketPlayInAutoRecipe.max-packet-rate";
              };
              action = mkOption {
                default = "DROP";
                type = types.str;
                description = "Packet-limiter.limits.PcketPlayInAutoRecipe.action";
              };
            };
          };
        };
      };
      world-settings = mkOption {
        default = {
          default = { };
        };
        type = types.attrsOf (types.submodule {
          options = {
            water-over-lava-flow-speed = mkOption {
              default = 5;
              type = types.int;
              description = "World-settings.type.options.water-over-lava-flow-speed";
            };
            grass-spread-tick-rate = mkOption {
              default = 1;
              type = types.int;
              description = "World-settings.type.options.grass-spread-tick-rate";
            };
            game-mechanics = {
              disable-chest-cat-detection = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-chest-cat-detection";
              };
              nerf-pigmen-from-nether-portals = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.nerf-pigmen-from-nether-portals";
              };
              disable-player-crits = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-player-crits";
              };
              disable-sprint-interruption-on-attack = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-sprint-interruption-on-attack";
              };
              shield-blocking-delay = mkOption {
                default = 5;
                type = types.int;
                description = "World-settings.type.options.game-mechanics.shield-blocking-delay";
              };
              disable-end-credits = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-end-credits";
              };
              disable-unloaded-chunk-enderpearl-exploit = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-unloaded-chunk-enderpearl-exploit";
              };
              disable-relative-projectile-velocity = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-relative-projectile-velocity";
              };
              disable-mob-spawner-spawn-egg-transformation = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-mob-spawner-spawn-egg-transformation";
              };
              scan-for-legacy-ender-dragon = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.scan-for-legacy-ender-dragon";
              };
              fix-curing-zombie-villager-discount-exploit = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.fix-curing-zombie-villager-discount-exploit";
              };
              disable-pillager-patrols = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.game-mechanics.disable-pillager-patrols";
              };
              pillager-patrols = {
                spawn-chance = mkOption {
                  default = 0.2;
                  type = types.float;
                  description = "World-settings.type.options.game-mechanics.pillager-patrols.spawn-chance";
                };
                spawn-delay = {
                  per-player = mkOption {
                    default = false;
                    type = types.bool;
                    description = "World-settings.type.options.game-mechanics.pillager-patrols.spawn-delay.per-player";
                  };
                  ticks = mkOption {
                    default = 12000;
                    type = types.int;
                    description = "World-settings.type.options.game-mechanics.pillager-patrols.spawn-delay.ticks";
                  };
                };
                start = {
                  per-player = mkOption {
                    default = false;
                    type = types.bool;
                    description = "World-settings.type.options.game-mechanics.pillager-patrols.start.per-player";
                  };
                  day = mkOption {
                    default = 5;
                    type = types.int;
                    description = "World-settings.type.options.game-mechanics.pillager-patrols.start.day";
                  };
                };
              };
            };
            use-faster-eigencraft-redstone = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.use-faster-eigencraft-redstone";
            };
            nether-ceiling-void-damage-height = mkOption {
              default = 0;
              type = types.int;
              description = "World-settings.type.options.nether-ceiling-void-damage-height";
            };
            only-players-collide = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.only-players-collide";
            };
            allow-vehicle-collisions = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.allow-vehicle-collisions";
            };
            fix-items-merging-through-walls = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.fix-items-merging-through-walls";
            };
            keep-spawn-loaded = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.keep-spawn-loaded";
            };
            parrots-are-unaffected-by-player-movement = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.parrots-are-unaffected-by-player-movement";
            };
            disable-explosion-knockback = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.disable-explosion-knockback";
            };
            allow-non-player-entities-on-scoreboards = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.allow-non-player-entities-on-scoreboards";
            };
            portal-search-radius = mkOption {
              default = 128;
              type = types.int;
              description = "World-settings.type.options.portal-search-radius";
            };
            portal-create-radius = mkOption {
              default = 16;
              type = types.int;
              description = "World-settings.type.options.portal-create-radius";
            };
            portal-search-vanilla-dimension-scaling = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.portal-search-vanilla-dimension-scaling";
            };
            anti-xray = {
              enabled = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.anti-xray.enabled";
              };
              engine-mode = mkOption {
                default = 1;
                type = types.int;
                description = "World-settings.type.options.anti-xray.engine-mode";
              };
              max-block-height = mkOption {
                default = 64;
                type = types.int;
                description = "World-settings.type.options.anti-xray.max-block-height";
              };
              update-radius = mkOption {
                default = 2;
                type = types.int;
                description = "World-settings.type.options.anti-xray.update-radius";
              };
              lava-obscures = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.anti-xray.lava-obscures";
              };
              use-permissions = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.anti-xray.use-permissions";
              };
              hidden-blocks = mkOption {
                default = [
                  "copper_ore"
                  "deepslate_copper_ore"
                  "gold_ore"
                  "deepslate_gold_ore"
                  "iron_ore"
                  "deepslate_iron_ore"
                  "coal_ore"
                  "deepslate_coal_ore"
                  "lapis_ore"
                  "deepslate_lapis_ore"
                  "mossy_cobblestone"
                  "obsidian"
                  "chest"
                  "diamond_ore"
                  "deepslate_diamond_ore"
                  "redstone_ore"
                  "deepslate_redstone_ore"
                  "clay"
                  "emerald_ore"
                  "deepslate_emerald_ore"
                  "ender_chest"
                ];
                type = types.listOf types.str;
                description = "World-settings.type.options.anti-xray.hidden-blocks";
              };
              replacement-blocks = mkOption {
                default = [ "stone" "oak_planks" "deepslate" ];
                type = types.listOf types.str;
                description = "World-settings.type.options.anti-xray.replacement-blocks";
              };
            };
            armor-stands-do-collision-entity-lookups = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.armor-stands-do-collision-entity-lookups";
            };
            disable-thunder = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.disable-thunder";
            };
            skeleton-horse-thunder-spawn-rate = mkOption {
              default = 0.01;
              type = types.float;
              description = "World-settings.type.options.skeleton-horse-thunder-spawn-rate";
            };
            disable-ice-and-snow = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.disable-ice-and-snow";
            };
            keep-spawn-loaded-range = mkOption {
              default = 10;
              type = types.int;
              description = "World-settings.type.options.keep-spawn-loaded-range";
            };
            fix-climbing-bypassing-cramming-rule = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.fix-climbing-bypassing-cramming-rule";
            };
            container-update-tick-rate = mkOption {
              default = 1;
              type = types.int;
              description = "World-settings.type.options.container-update-tick-rate";
            };
            fixed-chunk-inhabited-time = mkOption {
              default = -1;
              type = types.int;
              description = "World-settings.type.options.fixed-chunk-inhabited-time";
            };
            remove-corrupt-tile-entities = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.remove-corrupt-tile-entities";
            };
            prevent-tnt-from-moving-in-water = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.prevent-tnt-from-moving-in-water";
            };
            iron-golems-can-spawn-in-air = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.iron-golems-can-spawn-in-air";
            };
            show-sign-click-command-failure-msgs-to-player = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.show-sign-click-command-failure-msgs-to-player";
            };
            max-leash-distance = mkOption {
              default = 10.0;
              type = types.float;
              description = "World-settings.type.options.max-leash-distance";
            };
            armor-stands-tick = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.armor-stand-tick";
            };
            non-player-arrow-despawn-rate = mkOption {
              default = -1;
              type = types.int;
              description = "World-settings.type.options.non-player-arrow-despawn-rate";
            };
            creative-arrow-despawn-rate = mkOption {
              default = -1;
              type = types.int;
              description = "World-settings.type.options.create-arrow-despawn-rate";
            };
            spawner-nerfed-mobs-should-jump = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.spawner-nerfed-mobs-should-jump";
            };
            entities-target-with-follow-range = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.entities-target-with-follow-range";
            };
            wateranimal-spawn-height = {
              maximum = mkOption {
                default = "default";
                type = types.oneOf [ types.int types.str ];
                description = "World-settings.type.options.wateranimal-spawn-height.maximum";
              };
              minimum = mkOption {
                default = "default";
                type = types.oneOf [ types.int types.str ];
                description = "World-settings.type.options.wateranimal-spawn-height.minimum";
              };
            };
            zombies-target-turtle-eggs = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.zombies-target-turtle-eggs";
            };
            zombie-villager-infection-chance = mkOption {
              default = -1.0;
              type = types.float;
              description = "World-settings.type.options.zombie-villager-infection-chance";
            };
            all-chunks-are-slime-chunks = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.all-chunks-are-slime-chunks";
            };
            mob-spawner-tick-rate = mkOption {
              default = 1;
              type = types.int;
              description = "World-settings.type.options.mob-spawner-tick-rate";
            };
            per-player-mob-spawns = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.per-player-mob-spawns";
            };
            light-queue-size = mkOption {
              default = 20;
              type = types.int;
              description = "World-settings.type.options.light-queue-size";
            };
            auto-save-interval = mkOption {
              default = -1;
              type = types.int;
              description = "World-settings.type.options.auto-save-interval";
            };
            enable-treasure-maps = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.enable-treasure-maps";
            };
            treasure-maps-return-already-discovered = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.treasure-maps-return-already-discovered";
            };
            split-overstacked-loot = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.split-overstacked-loot";
            };
            delay-chunk-unloads-by = mkOption {
              default = 16;
              type = types.int;
              description = "World-settings.type.options.delay-chunk-unloads-by";
            };
            disable-teleportation-suffocation-check = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.disable-teleportation-suffocation-check";
            };
            generator-settings = {
              flat-bedrock = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.generator-settings.flat-bedrock";
              };
            };
            piglins-guard-chests = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.piglins-guard-chests";
            };
            should-remove-dragon = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.should-remove-dragon";
            };
            max-auto-save-chunks-per-tick = mkOption {
              default = 24;
              type = types.int;
              description = "World-settings.type.options.max-auto-save-chunks-per-tick";
            };
            baby-zombie-movement-modifier = mkOption {
              default = 0.5;
              type = types.float;
              description = "World-settings.type.options.baby-zombie-movement-modifier";
            };
            optimize-explosions = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.optimize-explosions";
            };
            use-vanilla-world-scoreboard-name-coloring = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.use-vanilla-world-scoreboard-name-coloring";
            };
            prevent-moving-into-unloaded-chunks = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.prevent-moving-into-unloaded-chunks";
            };
            count-all-mobs-for-spawning = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.count-all-mobs-for-spawning";
            };
            spawn-limits = {
              monster = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.monster";
              };
              creature = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.creature";
              };
              ambient = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.ambient";
              };
              axolotls = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.axolotls";
              };
              underground_water_creature = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.underground_water_creature";
              };
              water_creature = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.water_creature";
              };
              water_ambient = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.spawn-limits.water_ambient";
              };
            };
            ender-dragons-death-always-places-dragon-egg = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.ender-dragons-death-always-places-dragon-egg";
            };
            experience-merge-max-value = mkOption {
              default = -1;
              type = types.int;
              description = "World-settings.type.options.experience-merge-max-value";
            };
            allow-using-signs-inside-spawn-protection = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.allow-using-signs-inside-spawn-protection";
            };
            wandering-trader = {
              spawn-minute-length = mkOption {
                default = 1200;
                type = types.int;
                description = "World-settings.type.options.wandering-trader.spawn-minute-length";
              };
              spawn-day-length = mkOption {
                default = 24000;
                type = types.int;
                description = "World-settings.type.options.wandering-trader.spawn-day-length";
              };
              spawn-chance-failure-increment = mkOption {
                default = 25;
                type = types.int;
                description = "World-settings.type.options.wandering-trader.spawn-chance-failure-increment";
              };
              spawn-chance-min = mkOption {
                default = 25;
                type = types.int;
                description = "World-settings.type.options.wandering-trader.spawn-chance-min";
              };
              spawn-chance-max = mkOption {
                default = 75;
                type = types.int;
                description = "World-settings.type.options.wandering-trader.spawn-chance-max";
              };
            };
            door-breaking-difficulty = {
              zombie = mkOption {
                default = [ "HARD" ];
                type = types.listOf (types.enum [ "EASY" "NORMAL" "HARD" ]);
              };
              vindicator = mkOption {
                default = [ "NORMAL" "HARD" ];
                type = types.listOf (types.enum [ "EASY" "NORMAL" "HARD" ]);
              };
            };
            max-growth-height = {
              cactus = mkOption {
                default = 3;
                type = types.int;
                description = "World-settings.type.options.max-growth-height.cactus";
              };
              reeds = mkOption {
                default = 3;
                type = types.int;
                description = "World-settings.type.options.max-growth-height.reeds";
              };
              bamboo = {
                max = mkOption {
                  default = 16;
                  type = types.int;
                  description = "World-settings.type.options.max-growth-height.bamboo.max";
                };
                min = mkOption {
                  default = 11;
                  type = types.int;
                  description = "World-settings.type.options.max-growth-height.bamboo.min";
                };
              };
            };
            fishing-time-range = {
              MinimumTicks = mkOption {
                default = 100;
                type = types.int;
                description = "World-settings.type.options.fishing-time-range.MinimumTicks";
              };
              MaximumTicks = mkOption {
                default = 600;
                type = types.int;
                description = "World-settings.type.options.fishing-time-range.MaximumTicks";
              };
            };
            despawn-ranges = {
              monster = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              creature = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              ambient = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              axolotls = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              underground_water_creature = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              water_creature = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              water_ambient = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 64;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
              misc = {
                soft = mkOption {
                  default = 32;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.soft";
                };
                hard = mkOption {
                  default = 128;
                  type = types.int;
                  description = "World-settings.type.options.despawn-ranges.monster.hard";
                };
              };
            };
            falling-block-height-nerf = mkOption {
              default = 0;
              type = types.int;
              description = "World-settings.type.options.falling-block-height-nerf";
            };
            tnt-entity-height-nerf = mkOption {
              default = 0;
              type = types.int;
              description = "World-settings.type.options.tnt-entity-height-nerf";
            };
            slime-spawn-height = {
              swamp-biome = {
                maximum = mkOption {
                  default = 70.0;
                  type = types.float;
                  description = "World-settings.type.options.slime-spawn-height.swamp-biome.maximum";
                };
                minimum = mkOption {
                  default = 50.0;
                  type = types.float;
                  description = "World-settings.type.options.slime-spawn-height.swamp-biome.minimum";
                };
              };
              slime-chunk = {
                maximum = mkOption {
                  default = 40.0;
                  type = types.float;
                  description = "World-settings.type.options.slime-spawn-height.slime-chunk.maximum";
                };
              };
            };
            frosted-ice = {
              enabled = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.frosted-ice.enabled";
              };
              delay = {
                min = mkOption {
                  default = 20;
                  type = types.int;
                  description = "World-settings.type.options.frosted-ice.delay.min";
                };
                max = mkOption {
                  default = 40;
                  type = types.int;
                  description = "World-settings.type.options.frosted-ice.delay.max";
                };
              };
            };
            lootables = {
              auto-replenish = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.lootables.auto-replenish";
              };
              restrict-player-reloot = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.lootables.restrict-player-reloot";
              };
              reset-seed-on-fill = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.lootables.reset-seed-on-fill";
              };
              max-refills = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.lootables.max-refills";
              };
              refresh-min = mkOption {
                default = "12h";
                type = types.str;
                description = "World-settings.type.options.lootables.refresh-min";
              };
              refresh-max = mkOption {
                default = "2d";
                type = types.str;
                description = "World-settings.type.options.lootables.refresh-max";
              };
            };
            filter-nbt-data-from-spawn-eggs-and-related = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.filter-nbt-data-from-spawn-eggs-and-related";
            };
            max-entity-collisions = mkOption {
              default = 8;
              type = types.int;
              description = "World-settings.type.options.max-entity-collisions";
            };
            disable-creeper-lingering-effect = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.disable-creeper-lingering-effect";
            };
            duplicate-uuid-resolver = mkOption {
              default = "saferegen";
              type = types.str;
              description = "World-settings.type.options.duplicate-uuid-resolver";
            };
            duplicate-uuid-safegen-delete-range = mkOption {
              default = 32;
              type = types.int;
              description = "World-settings.type.options.duplicate-uuid-safegen-delete-range";
            };
            hopper = {
              cooldown-when-full = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.hopper.cooldown-when-full";
              };
              disable-move-event = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.hopper.disable-move-event";
              };
              ignore-occluding-blocks = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.hopper.ignore-occluding-blocks";
              };
            };
            mob-effects = {
              undead-immune-to-certain-effects = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.mob-effects.undead-immune-to-certain-effects";
              };
              spiders-immune-to-poison-effect = mkOption {
                default = true;
                type = types.bool;
                description = "World-settings.type.options.mob-effects.spiders-immune-to-poison-effect";
              };
              immune-to-wither-effects = {
                wither = mkOption {
                  default = true;
                  type = types.bool;
                  description = "World-settings.type.options.mob-effects.immune-to-wither-effects.wither";
                };
                wither-skeleton = mkOption {
                  default = true;
                  type = types.bool;
                  description = "World-settings.type.options.mob-effects.immune-to-wither-effects.wither-skeleton";
                };
              };
            };
            update-pathfinding-on-block-update = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.update-pathfinding-on-block-update";
            };
            phantoms-do-not-spawn-on-creative-players = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.phantoms-do-not-spawn-on-creative-players";
            };
            phantoms-only-attack-insomniacs = mkOption {
              default = true;
              type = types.bool;
              description = "World-settings.type.options.phantoms-only-attack-insomniacs";
            };
            mobs-can-always-pick-up-loot = {
              zombies = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.mobs-can-always-pick-up-loot.zombies";
              };
              skeletons = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.mobs-can-always-pick-up-loot.skeletons";
              };
            };
            map-item-frame-cursor-update-interval = mkOption {
              default = 10;
              type = types.int;
              description = "World-settings.type.options.map-item-frame-cursor-update-interval";
            };
            allow-player-cramming-damage = mkOption {
              default = false;
              type = types.bool;
              description = "World-settings.type.options.allow-player-cramming-damage";
            };
            anticheat = {
              obfuscation = {
                hide-itemmeta = mkOption {
                  default = false;
                  type = types.bool;
                  description = "World-settings.type.options.anticheat.obfuscation.hide-itemmeta";
                };
                hide-durability = mkOption {
                  default = false;
                  type = types.bool;
                  description = "World-settings.type.options.anticheat.obfuscation.hide-durability";
                };
              };
            };
            monster-spawn-max-light-level = mkOption {
              default = -1;
              type = types.int;
              description = "World-settings.type.options.monster-spawn-max-light-level";
            };
            map-item-frame-cursor-limit = mkOption {
              default = 128;
              type = types.int;
              description = "World-settings.type.options.map-item-frame-cursor-limit";
            };
            feature-seeds = {
              generate-random-seeds-for-all = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.feature-seeds.generate-random-seeds-for-all";
              };
            };
            entity-per-chunk-save-limit = {
              experience_orb = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.entity-per-chunk-save-limit.experience-orb";
              };
              snowball = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.entity-per-chunk-save-limit.snowball";
              };
              ender_pearl = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.entity-per-chunk-save-limit.ender_pearl";
              };
              arrow = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.entity-per-chunk-save-limit.arrow";
              };
              fireball = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.entity-per-chunk-save-limit.fireball";
              };
              small_fireball = mkOption {
                default = -1;
                type = types.int;
                description = "World-settings.type.options.entity-per-chunk-save-limit.small_fireball";
              };
            };
            alt-item-despawn-rate = {
              enabled = mkOption {
                default = false;
                type = types.bool;
                description = "World-settings.type.options.alt-item-despawn-rate.enabled";
              };
              items = mkOption {
                default = { };
                type = types.attrsOf types.int;
                description = "World-settings.type.options.alt-item-despawn-rate.items";
              };
            };
            tick-rates = {
              sensor = {
                villager = {
                  secondarypoisensor = mkOption {
                    default = 40;
                    type = types.int;
                    description = "World-settings.type.options.tick-rates.sensor.villager.secondarypoisensor";
                  };
                };
              };
              behavior = {
                villager = {
                  validatenearbypoi = mkOption {
                    default = -1;
                    type = types.int;
                    description = "World-settings.type.options.tick-rates.behavior.villager.validatenearbypoi";
                  };
                };
              };
            };
          };
        });
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
    plugins = mkOption {
      default = [ ];
      type = types.listOf (types.submodule {
        options = {
          package = mkOption {
            type = types.package;
            description = "Package name of the plugin";
          };
          startScript = mkOption {
            type = types.nullOr (types.oneOf [ types.str types.package ]);
            description = "Start script of the plugin";
          };
        };
      });
      description = "List of plugins to load";
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
      preStart =
        let
          plugins = builtins.map
            (plugin: ''
              cp ${plugin.package} plugins
                  ${if plugin.startScript != null then ''
                    ${plugin.startScript}
                '' else ""}
            '')
            cfg.plugins;
        in
        ''
          cd $HOME
          # Agree to the EULA
          echo "eula=true" > eula.txt
          # Update the server properties
          cat ${serverProperties} > server.properties
          ${if cfg.properties.rcon-password-file != null then ''
            echo "rcon.password=$(cat ${builtins.toString cfg.properties.rcon-password-file})" >> server.properties
          '' else "" }
          # Update the whitelist
          cat ${whitelistJson} > whitelist.json
          # Update the bukkit yml
          cat ${bukkitYaml} > bukkit.yml
          # Update the spigot yml
          cat ${spigotYaml} > spigot.yml
          # Update the paper yml
          cat ${paperYaml} > paper.yml
          # Update the plugins
          mkdir -p plugins
          rm -rf plugins/*.jar
          ${builtins.toString plugins}
        '';
      serviceConfig = {
        Type = "simple";
        User = "minecraft";
        Group = "minecraft";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${papermc}/bin/minecraft-server -Xms1G -Xmx1G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
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

