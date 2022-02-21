{ config, lib, options, pkgs, ... }:
with lib;
let
  essentialsx = pkgs.callPackage ../../packages/minecraft/essentialsx.nix { };
  cfg = config.services.minecraft.essentialsx;
  opt = options.services.minecraft.essentialsx;
  config-yml = pkgs.writeText "config.yml" (generators.toYAML { } cfg.config);
in
{
  options.services.minecraft.essentialsx = {
    enable = mkOption {
      default = false;
      description = "Enable EssentialsX";
      type = types.bool;
    };
    chat = mkOption {
      default = true;
      description = "Enable EssentialsX Chat";
      type = types.bool;
    };
    spawn = mkOption {
      default = true;
      description = "Enable EssentialsX Spawn";
      type = types.bool;
    };

    config = {
      ops-name-color = mkOption {
        default = "4";
        description = "Ops name color";
        type = types.str;
      };
      nickname-prefix = mkOption {
        default = "~";
        description = "Nickname prefix";
        type = types.str;
      };
      max-nick-length = mkOption {
        default = 15;
        description = "Max nickname length";
        type = types.int;
      };
      nick-blacklist = mkOption {
        default = [ ];
        description = "Nickname blacklist";
        type = types.listOf types.str;
      };
      ignore-colors-in-max-nick-length = mkOption {
        default = false;
        description = "Ignore colors in max nickname length";
        type = types.bool;
      };
      hide-displayname-in-vanish = mkOption {
        default = true;
        description = "Hide displayname in vanish";
        type = types.bool;
      };
      change-displayname = mkOption {
        default = true;
        description = "Change displayname";
        type = types.bool;
      };
      change-tab-complete-name = mkOption {
        default = false;
        description = "Change tab complete name";
        type = types.bool;
      };
      change-playerlist = mkOption {
        default = false;
        description = "Change playerlist";
        type = types.bool;
      };
      add-prefix-in-playerlist = mkOption {
        default = false;
        description = "Add prefix in playerlist";
        type = types.bool;
      };
      add-suffix-in-playerlist = mkOption {
        default = false;
        description = "Add suffix in playerlist";
        type = types.bool;
      };
      teleport-safety = mkOption {
        default = true;
        description = "Teleport safety";
        type = types.bool;
      };
      force-disable-teleport-safety = mkOption {
        default = false;
        description = "Force disable teleport safety";
        type = types.bool;
      };
      force-safe-teleport-location = mkOption {
        default = false;
        description = "Force safe teleport location";
        type = types.bool;
      };
      teleport-passenger-dismount = mkOption {
        default = true;
        description = "Teleport passenger dismount";
        type = types.bool;
      };
      teleport-cooldown = mkOption {
        default = 0;
        description = "Teleport cooldown";
        type = types.int;
      };
      teleport-delay = mkOption {
        default = 0;
        description = "Teleport delay";
        type = types.int;
      };
      teleport-invulnerability = mkOption {
        default = 4;
        description = "Teleport invulnerability";
        type = types.int;
      };
      teleport-to-center = mkOption {
        default = true;
        description = "Teleport to center";
        type = types.bool;
      };
      heal-cooldown = mkOption {
        default = 60;
        description = "Heal cooldown";
        type = types.int;
      };
      remove-effects-on-heal = mkOption {
        default = true;
        description = "Remove effects on heal";
        type = types.bool;
      };
      near-radius = mkOption {
        default = 200;
        description = "Near radius";
        type = types.int;
      };
      item-spawn-blacklist = mkOption {
        default = [ ];
        description = "Item spawn blacklist";
        type = types.listOf types.str;
      };
      permission-based-item-spawn = mkOption {
        default = false;
        description = "Permission based item spawn";
        type = types.bool;
      };
      spawnmob-limit = mkOption {
        default = 10;
        description = "Spawnmob limit";
        type = types.int;
      };
      warn-on-smite = mkOption {
        default = true;
        description = "Warn on smite";
        type = types.bool;
      };
      drop-items-if-full = mkOption {
        default = false;
        description = "Drop items if full";
        type = types.bool;
      };
      notify-no-new-mail = mkOption {
        default = true;
        description = "Notify no new mail";
        type = types.bool;
      };
      notify-player-of-mail-cooldown = mkOption {
        default = 60;
        description = "Notify player of mail cooldown";
        type = types.int;
      };
      ovverridden-commands = mkOption {
        default = [ ];
        description = "Ovverridden commands";
        type = types.listOf types.str;
      };
      disabled-commands = mkOption {
        default = [ ];
        description = "Disabled commands";
        type = types.listOf types.str;
      };
      verbose-command-usages = mkOption {
        default = true;
        description = "Verbose command usages";
        type = types.bool;
      };
      socialspy-commands = mkOption {
        default = [
          "msg"
          "w"
          "r"
          "mail"
          "m"
          "t"
          "whisper"
          "emsg"
          "tell"
          "er"
          "reply"
          "ereply"
          "email"
          "action"
          "describe"
          "eme"
          "eaction"
          "edescribe"
          "etell"
          "ewhisper"
          "pm"
        ];
        description = "Socialspy commands";
        type = types.listOf types.str;
      };
      socialspy-listen-muted-players = mkOption {
        default = true;
        description = "Socialspy listen muted players";
        type = types.bool;
      };
      socialspy-messages = mkOption {
        default = true;
        description = "Socialspy messages";
        type = types.bool;
      };
      world-change-fly-reset = mkOption {
        default = true;
        description = "World change=ly reset";
        type = types.bool;
      };
      world-change-speed-reset = mkOption {
        default = true;
        description = "World change=ly reset";
        type = types.bool;
      };
      mute-commands = mkOption {
        default = [ ];
        description = "Mute commands";
        type = types.listOf types.str;
      };
      player-commands = mkOption {
        default = [ ];
        description = "Player commands";
        type = types.listOf types.str;
      };
      use-bukkit-permissions = mkOption {
        default = true;
        description = "Use bukkit permissions";
        type = types.bool;
      };
      skip-used-one-time-kits-from-kit-list = mkOption {
        default = false;
        description = "Skip used one time kits from kit list";
        type = types.bool;
      };
      kit-auto-equip = mkOption {
        default = false;
        description = "Kit auto equip";
        type = types.bool;
      };
      pastebin-createkit = mkOption {
        default = false;
        description = "Pastebin createkit";
        type = types.bool;
      };
      use-nbt-serialization-in-createkit = mkOption {
        default = false;
        description = "Use nbt serialization in createkit";
        type = types.bool;
      };
      enabled-signs = mkOption {
        default = [ ];
        description = "Enabled signs";
        type = types.listOf types.str;
      };
      sign-use-per-second = mkOption {
        default = 4;
        description = "Sign use per second";
        type = types.int;
      };
      allow-old-id-signs = mkOption {
        default = false;
        description = "Allow old id signs";
        type = types.bool;
      };
      unprotected-sign-names = mkOption {
        default = [ ];
        description = "Unprotected sign names";
        type = types.listOf types.str;
      };
      backup = {
        interval = mkOption {
          default = 30;
          description = "Backup interval";
          type = types.int;
        };
        always-run = mkOption {
          default = false;
          description = "Always run";
          type = types.bool;
        };
        command = mkOption {
          default = null;
          description = "Command";
          type = types.nullOr types.str;
        };
      };
      per-warp-permission = mkOption {
        default = false;
        description = "Per warp permission";
        type = types.bool;
      };
      real-names-on-list = mkOption {
        default = false;
        description = "Real names on list";
        type = types.bool;
      };
      debug = mkOption {
        default = false;
        description = "Debug";
        type = types.bool;
      };
      remove-god-on-disconnect = mkOption {
        default = false;
        description = "Remove god on disconnect";
        type = types.bool;
      };
      auto-afk = mkOption {
        default = 300;
        description = "Auto afk";
        type = types.int;
      };
      auto-afk-kick = mkOption {
        default = -1;
        description = "Auto afk kick";
        type = types.int;
      };
      freeze-afk-players = mkOption {
        default = false;
        description = "Freeze afk players";
        type = types.bool;
      };
      disable-item-pickup-while-afk = mkOption {
        default = false;
        description = "Disable item pickup while afk";
        type = types.bool;
      };
      cancel-afk-on-interact = mkOption {
        default = true;
        description = "Cancel afk on interact";
        type = types.bool;
      };
      cancel-afk-on-move = mkOption {
        default = true;
        description = "Cancel afk on move";
        type = types.bool;
      };
      cancel-afk-on-chat = mkOption {
        default = true;
        description = "Cancel afk on chat";
        type = types.bool;
      };
      sleep-ignores-afk-players = mkOption {
        default = true;
        description = "Sleep ignores afk players";
        type = types.bool;
      };
      sllep-ignores-vanished-players = mkOption {
        default = true;
        description = "Sleep ignores vanished players";
        type = types.bool;
      };
      afk-list-name = mkOption {
        default = "none";
        description = "Afk list name";
        type = types.str;
      };
      broadcast-afk-message = mkOption {
        default = true;
        description = "Broadcast afk message";
        type = types.bool;
      };
      death-messages = mkOption {
        default = true;
        description = "Death messages";
        type = types.bool;
      };
      vanishing-items-policy = mkOption {
        default = "keep";
        description = "Vanishing items policy";
        type = types.str;
      };
      binding-items-policy = mkOption {
        default = "keep";
        description = "Binding items policy";
        type = types.str;
      };
      send-info-after-death = mkOption {
        default = false;
        description = "Send info after death";
        type = types.bool;
      };
      allow-silent-join-quit = mkOption {
        default = false;
        description = "Allow silent join quit";
        type = types.bool;
      };
      custom-join-message = mkOption {
        default = "none";
        description = "Custom join message";
        type = types.str;
      };
      custom-quit-message = mkOption {
        default = "none";
        description = "Custom quit message";
        type = types.str;
      };
      custom-new-username-message = mkOption {
        default = "none";
        description = "Custom new username message";
        type = types.str;
      };
      use-custom-server-full-message = mkOption {
        default = true;
        description = "Use custom server full message";
        type = types.bool;
      };
      hide-join-quit-messages-above = mkOption {
        default = -1;
        description = "Hide join quit messages above";
        type = types.int;
      };
      no-god-in-worlds = mkOption {
        default = [ ];
        description = "No god in worlds";
        type = types.listOf types.str;
      };
      world-teleport-permissions = mkOption {
        default = false;
        description = "World teleport permissions";
        type = types.bool;
      };
      default-stack-size = mkOption {
        default = -1;
        description = "Default stack size";
        type = types.int;
      };
      oversized-stacksize = mkOption {
        default = 64;
        description = "Oversized stacksize";
        type = types.int;
      };
      repair-enchanted = mkOption {
        default = true;
        description = "Repair enchanted";
        type = types.bool;
      };
      unsafe-enchantments = mkOption {
        default = false;
        description = "Unsafe enchantments";
        type = types.bool;
      };
      tree-command-range-limit = mkOption {
        default = 300;
        description = "Tree command range limit";
        type = types.int;
      };
      register-back-in-listener = mkOption {
        default = false;
        description = "Register back in listener";
        type = types.bool;
      };
      login-attack-delay = mkOption {
        default = 5;
        description = "Login attack delay";
        type = types.int;
      };
      max-fly-speed = mkOption {
        default = 0.8;
        description = "Max fly speed";
        type = types.float;
      };
      max-walk-speed = mkOption {
        default = 0.8;
        description = "Max walk speed";
        type = types.float;
      };
      mails-per-minute = mkOption {
        default = 1000;
        description = "Mails per minute";
        type = types.int;
      };
      max-mute-time = mkOption {
        default = -1;
        description = "Max mute time";
        type = types.int;
      };
      max-tempban-time = mkOption {
        default = -1;
        description = "Max tempban time";
        type = types.int;
      };
      last-message-reply-recipient = mkOption {
        default = true;
        description = "Last message reply recipient";
        type = types.bool;
      };
      last-message-reply-recipient-timeout = mkOption {
        default = 180;
        description = "Last message reply recipient timeout";
        type = types.int;
      };
      last-message-reply-vanished = mkOption {
        default = true;
        description = "Last message reply vanished";
        type = types.bool;
      };
      milk-bucket-easter-egg = mkOption {
        default = true;
        description = "Milk bucket easter egg";
        type = types.bool;
      };
      send-fly-enable-on-join = mkOption {
        default = true;
        description = "Send fly enable on join";
        type = types.bool;
      };
      world-time-permissions = mkOption {
        default = false;
        description = "World time permissions";
        type = types.bool;
      };
      command-cooldowns = mkOption {
        default = { };
        description = "Command cooldowns";
        type = types.attrsOf types.int;
      };
      command-cooldown-persistence = mkOption {
        default = true;
        description = "Command cooldown persistence";
        type = types.bool;
      };
      npcs-in-balance-ranking = mkOption {
        default = false;
        description = "Npcs in balance ranking";
        type = types.bool;
      };
      allow-bulk-buy-sell = mkOption {
        default = true;
        description = "Allow bulk buy sell";
        type = types.bool;
      };
      allow-selling-named-items = mkOption {
        default = false;
        description = "Allow selling named items";
        type = types.bool;
      };
      delay-motd = mkOption {
        default = 0;
        description = "Delay motd";
        type = types.int;
      };
      default-enabled-confirm-commands = mkOption {
        default = [ ];
        description = "Default enabled confirm commands";
        type = types.listOf types.str;
      };
      teleport-when-freed = mkOption {
        default = "back";
        description = "Teleport when freed";
        type = types.str;
      };
      jail-online-time = mkOption {
        default = false;
        description = "Jail online time";
        type = types.bool;
      };
      tpa-accept-cancellation = mkOption {
        default = 120;
        description = "Tpa accept cancellation";
        type = types.int;
      };
      tpa-max-request = mkOption {
        default = 5;
        description = "Tpa max request";
        type = types.int;
      };
      allow-direct-hat = mkOption {
        default = true;
        description = "Allow direct hat";
        type = types.bool;
      };
      allow-world-in-broadcastworld = mkOption {
        default = true;
        description = "Allow world in broadcastworld";
        type = types.bool;
      };
      is-water-safe = mkOption {
        default = false;
        description = "Is water safe";
        type = types.bool;
      };
      safe-usermap-names = mkOption {
        default = true;
        description = "Safe usermap names";
        type = types.bool;
      };
      log-command-block-commands = mkOption {
        default = true;
        description = "Log command block commands";
        type = types.bool;
      };
      max-projectile-speed = mkOption {
        default = 8;
        description = "Max projectile speed";
        type = types.int;
      };
      update-check = mkOption {
        default = true;
        description = "Update check";
        type = types.bool;
      };
      update-bed-at-daytime = mkOption {
        default = true;
        description = "Update bed at daytime";
        type = types.bool;
      };
      world-home-permission = mkOption {
        default = false;
        description = "World home permission";
        type = types.bool;
      };

      sethome-multiple = mkOption {
        default = {
          default = 3;
          vip = 5;
          staff = 10;
        };
        description = "Sethome multiple";
        type = types.attrsOf types.int;
      };
      compass-towards-home-perm = mkOption {
        default = false;
        description = "Compass towards home perm";
        type = types.bool;
      };
      spawn-if-no-home = mkOption {
        default = true;
        description = "Spawn if no home";
        type = types.bool;
      };
      confirm-home-overwrite = mkOption {
        default = false;
        description = "Confirm home overwrite";
        type = types.bool;
      };
      starting-balance = mkOption {
        default = 0;
        description = "Starting balance";
        type = types.int;
      };
      command-costs = mkOption {
        default = { };
        description = "Command costs";
        type = types.attrsOf types.int;
      };
      currency-symbol = mkOption {
        default = "$";
        description = "Currency symbol";
        type = types.str;
      };
      currency-symbol-suffix = mkOption {
        default = false;
        description = "Currency symbol suffix";
        type = types.bool;
      };
      max-money = mkOption {
        default = 10000000000000;
        description = "Max money";
        type = types.int;
      };
      min-money = mkOption {
        default = -10000;
        description = "Min money";
        type = types.int;
      };
      economy-log-enabled = mkOption {
        default = false;
        description = "Economy log enabled";
        type = types.bool;
      };
      economy-log-update-enabled = mkOption {
        default = false;
        description = "Economy log update enabled";
        type = types.bool;
      };
      minimum-pay-amount = mkOption {
        default = 0.001;
        description = "Minimum pay amount";
        type = types.float;
      };
      pay-excludes-ignore-list = mkOption {
        default = false;
        description = "Pay excludes ignore list";
        type = types.bool;
      };
      show-zero-baltop = mkOption {
        default = true;
        description = "Show zero baltop";
        type = types.bool;
      };
      currency-format = mkOption {
        default = "#,##0.00";
        description = "Currency format";
        type = types.str;
      };
      non-ess-in-help = mkOption {
        default = true;
        description = "Non ess in help";
        type = types.bool;
      };
      hide-permissionless-help = mkOption {
        default = true;
        description = "Hide permissionless help";
        type = types.bool;
      };
      chat = {
        radius = mkOption {
          default = 0;
          description = "Radius";
          type = types.int;
        };
        format = mkOption {
          default = "{PREFIX}{DISPLAYNAME}{SUFFIX}&r: {MESSAGE}";
          description = "Format";
          type = types.str;
        };
        group-formats = mkOption {
          default = { };
          description = "Group formats";
          type = types.attrsOf types.str;
        };
        world-aliases = mkOption {
          default = { };
          description = "World aliases";
          type = types.attrsOf types.str;
        };
        shout-default = mkOption {
          default = false;
          description = "Shout default";
          type = types.bool;
        };
        persist-shout = mkOption {
          default = false;
          description = "Persist shout";
          type = types.bool;
        };
        question-enabled = mkOption {
          default = true;
          description = "Question enabled";
          type = types.bool;
        };
      };
      respawn-listener-priority = mkOption {
        default = "high";
        description = "Respawn listener priority";
        type = types.str;
      };
      spawn-join-listener-priority = mkOption {
        default = "high";
        description = "Spawn join listener priority";
        type = types.str;
      };
      respawn-at-home = mkOption {
        default = false;
        description = "Respawn at home";
        type = types.bool;
      };
      respawn-at-home-bed = mkOption {
        default = true;
        description = "Respawn at home bed";
        type = types.bool;
      };
      respawn-anchor = mkOption {
        default = false;
        description = "Respawn anchor";
        type = types.bool;
      };
      spawn-on-join = mkOption {
        default = false;
        description = "Spawn on join";
        type = types.oneOf [ types.bool types.str (types.listOf types.str) ];
      };
    };
  };

  config = mkIf cfg.enable
    {
      assertions = [
        {
          assertion = cfg.config.change-playerlist -> cfg.config.change-tab-complete-name;
          message = "change-playerlist can only be on if change-tab-complete-name is on";
        }
        {
          assertion = cfg.config.add-prefix-in-playerlist -> cfg.config.change-playerlist;
          message = "add-prefix-in-playerlist can only be on if change-playerlist is on";
        }
        {
          assertion = cfg.config.add-suffix-in-playerlist -> cfg.config.change-playerlist;
          message = "add-suffix-in-playerlist can only be on if change-playerlist is on";
        }
        {
          assertion = cfg.config.force-disable-teleport-safety -> cfg.config.teleport-safety;
          message = "force-disable-teleport-safety can only be on if teleport-safety is on";
        }
      ];
      warnings = optional (!(cfg.config.respawn-at-home -> cfg.config.respawn-at-home-bed)) "respawn-at-home is off, the setting of respawn-at-home-bed is ignored.";
      services.minecraft = {
        vault.enable = config.services.minecraft.luckperms.enable;
      };
      services.minecraft.plugins = lib.mkMerge [
        [{
          package = essentialsx.essentialsx;
          startScript = pkgs.writeScript "essentialsx" ''
            mkdir -pv plugins/Essentials
            cat ${config-yml} > plugins/Essentials/config.yml
          '';
        }]
        (
          mkIf cfg.chat
            [{
              package = essentialsx.essentialsx-chat;
              startScript = pkgs.writeScript "dummy" "";
            }]
        )
        (
          mkIf cfg.spawn
            [{
              package = essentialsx.essentialsx-spawn;
              startScript = pkgs.writeScript "dummy" "";
            }]
        )
      ];
    };
}
