{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../modules/minecraft/server.nix
    ../../modules/minecraft/luckperms.nix
    ../../modules/minecraft/essentialsx.nix
    ../../modules/minecraft/multiverse.nix
  ];

  services.minecraft = {
    enable = true;
    stateDir = "/persist/var/lib/minecraft";
    whitelist = [
      {
        uuid = "74e2502d-64db-4ac4-bac7-a0a2bc50ec9f";
        name = "DragonKing1337";
      }
      {
        uuid = "a6578f9a-288d-44af-8f43-e6402b126bb6";
        name = "DarkKirb";
      }
      {
        uuid = "5c29f08d-bc6f-4e3f-a83f-9454c5543d49";
        name = "Hrothiwulfus";
      }
      {
        uuid = "6253c244-cdf6-41b9-9187-62ad7552ca5c";
        name = "BL4CKM1ND";
      }
      {
        uuid = "7ee66be7-c8a7-44c9-8f2b-8dae22afbf09";
        name = "blackmind";
      }
      {
        uuid = "64315aa6-b996-4e9a-95d0-c6b567c2a2e6";
        name = "_KleineMio_";
      }
      {
        uuid = "7df86b33-1987-4b99-8290-d23440c13bc2";
        name = "DaTsHeePiii";
      }
      {
        name = "crafted2cc";
        uuid = "894a8cfe-4066-4a68-be7d-2b01a62a1ed6";
      }
      {
        name = "blackghost4";
        uuid = "4a8b0dbb-7239-4b5b-8a59-e5d6ce728299";
      }
    ];
    properties.server-ip = "172.16.154.251"; # death
    paper-yml = {
      world-settings.default = {
        max-auto-save-chunks-per-tick = 8;
        optimize-explosions = true;
        mob-spawner-tick-rate = 2;
        game-mechanics.disable-chest-cat-detection = true;
        container-update-tick-rate = 3;
        max-entity-collisions = 2;
        grass-spread-tick-rate = 4;
        non-player-arrow-despawn-rate = 60;
        creative-arrow-despawn-rate = 60;
        despawn-ranges = rec {
          monster = {
            soft = 28;
            hard = 96;
          };
          creature = monster;
          ambient = monster;
          axolotls = monster;
          underground_water_creature = monster;
          water_creature = monster;
          water_ambient = {
            soft = 28;
            hard = 32;
          };
          misc = monster;
        };
        hopper = {
          disable-move-event = true;
        };
        prevent-moving-into-unloaded-chunks = true;
        use-faster-eigencraft-redstone = true;
        armor-stands-tick = false;
        per-player-mob-spawns = true;
      };
    };
    luckperms = {
      enable = true;
      config = {
        enable-ops = false;
      };
      groups = {
        admin = {
          name = "admin";
          permissions = [
            "*"
            {
              "essentials.hat.prevent-type.*" = {
                value = false;
              };
            }
            {
              "mv.bypass.gamemode.*" = {
                value = false;
              };
            }
          ];
          prefixes = [
            {
              "&d@" = {
                priority = 1;
              };
            }
          ];
        };
        default = {
          name = "default";
          permissions = [
            "bukkit.command.help"
            "bukkit.commit.mspt"
            "bukkit.command.plugins"
            "bukkit.command.version"

            "essentials.balance"
            "essentials.book"
            "essentials.compass"
            "essentials.delhome"
            "essentials.depth"
            "essentials.editsign"
            "essentials.gc"
            "essentials.getpos"
            "essentials.help"
            "essentials.helpop"
            "essentials.ignore"
            "essentials.info"
            "essentials.itemdb"
            "essentials.itemlore"
            "essentials.keepinv"
            "essentials.keepxp"
            "essentials.list"
            "essentials.mail"
            "essentials.me"
            "essentials.motd"
            "essentials.msgtoggle"
            "essentials.pay"
            "essentials.payconfirmtoggle"
            "essentials.paytoggle"
            "essentials.ping"
            "essentials.playtime"
            "essentials.realname"
            "essentials.recipe"
            "essentials.rtoggle"
            "essentials.rules"
            {
              "essentials.sell" = {
                value = true;
                context = {
                  gamemode = "survival";
                };
              };
            }
            "essentials.sell.hand"
            "essentials.skull"
            "essentials.sleepingignored"
            "essentials.tpa"
            "essentials.tpacancel"
            "essentials.tpaccept"
            "essentials.tpahere"
            "essentials.tpauto"
            "essentials.tpdeny"
            "essentials.warp"
            "essentials.warpinfo"
            "essentials.world"
            "essentials.whois"
            "essentials.worth"
            "essentials.afk"
            "essentials.afk.auto"
            "essentials.balancetop"
            "essentials.hat"
            "essentials.home"
            "essentials.near"
            "essentials.nick"
            "essentials.seen"
            "essentials.seen.extra"
            "essentials.sethome"
            "essentials.sethome.bed"

            "multiverse.access.*"
          ];
        };
      };
      users = {
        a6578f9a-288d-44af-8f43-e6402b126bb6 = {
          uuid = "a6578f9a-288d-44af-8f43-e6402b126bb6";
          name = "DarkKirb";
          primary-group = "admin";
          parents = [
            "admin"
            "default"
          ];
        };
      };
    };
    essentialsx = {
      enable = true;
      config = {
        change-playerlist = true;
        change-tab-complete-name = true;
        add-prefix-in-playerlist = true;
        add-suffix-in-playerlist = true;
        respawn-at-home = true;
        currency-symbol = "€";
        currency-symbol-suffix = true;
        chat.format = "{DISPLAYNAME}&r: {MESSAGE}";
        enabled-signs = [
          "color"
          "balance"
          "buy"
          "sell"
          "trade"
          "free"
          "disposal"
          "warp"
          "mail"
        ];
      };
      worth-yml = ../../extra/worth.yml;
    };
    multiverse = {
      enable = true;
      netherportals = true;
      signportals = true;
      inventories = true;
    };
  };
  networking.firewall.allowedTCPPorts = [
    config.services.minecraft.properties.server-port
  ];
  services.minecraft.plugins = [
    {
      package = (pkgs.callPackage ../../packages/minecraft/dynmap.nix {}).core;
      startScript = "";
    }
  ];
  services.caddy.virtualHosts."mc.chir.rs" = {
    useACMEHost = "chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://172.16.154.251:8123 {
        trusted_proxies private_ranges
      }
    '';
  };
}
