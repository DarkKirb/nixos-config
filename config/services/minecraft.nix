{ config, ... }: {
  imports = [
    ../../modules/minecraft/server.nix
    ../../modules/minecraft/luckperms.nix
    ../../modules/minecraft/essentialsx.nix
  ];

  services.minecraft = {
    enable = true;
    whitelist = [
      {
        uuid = "45821aee-c1f4-4a47-af23-6e2983f37ce6";
        name = "DragonKing337";
      }
      {
        uuid = "a6578f9a-288d-44af-8f43-e6402b126bb6";
        name = "DarkKirb";
      }
      {
        uuid = "5c29f08d-bc6f-4e3f-a83f-9454c5543d49";
        name = "Hrothiwulfus";
      }
    ];
    properties.server-ip = "138.201.155.128"; # death
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
            "essentials.sell"
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
      };
      worth-yml = ../../extra/worth.yml;
    };
  };
  networking.firewall.allowedTCPPorts = [
    config.services.minecraft.properties.server-port
  ];
}
