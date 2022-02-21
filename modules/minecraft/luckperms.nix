{ config, lib, options, pkgs, ... }:
with lib;
let
  luckperms = pkgs.callPackage ../../packages/minecraft/luckperms.nix { };
  cfg = config.services.minecraft.luckperms;
  opt = options.services.minecraft.luckperms;
  luckperms-yml = pkgs.writeText "luckperms.yml" (generators.toYAML { } cfg.config);
  groups = builtins.mapAttrs (name: value: pkgs.writeText "${name}.yml" (generators.toYAML { } value)) cfg.groups;
  users = builtins.mapAttrs (name: value: pkgs.writeText "${name}.yml" (generators.toYAML { } value)) cfg.users;
  groupPermCopy = builtins.map
    (group: ''
      cat ${groups.${group}} > plugins/LuckPerms/yaml-storage/groups/${group}.yml
    '')
    (builtins.attrNames groups);
  userPermCopy = builtins.map
    (user: ''
      cat ${users.${user}} > plugins/LuckPerms/yaml-storage/users/${user}.yml
    '')
    (builtins.attrNames users);
  startScript = pkgs.writeScript "luckperms" ''
    mkdir -p plugins/LuckPerms
    cat ${luckperms-yml} > plugins/LuckPerms/config.yml
    mkdir -p plugins/LuckPerms/yaml-storage/groups/
    ${builtins.toString groupPermCopy}
    mkdir -p plugins/LuckPerms/yaml-storage/users/
    ${builtins.toString userPermCopy}
  '';
in
{
  imports = [
    ./vault.nix
  ];
  options.services.minecraft.luckperms = {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = "Enable LuckPerms";
    };

    config = {
      server = mkOption {
        default = "global";
        type = types.str;
        description = "Server Name to use for LuckPerms";
      };
      use-server-uuid-cache = mkOption {
        default = false;
        type = types.bool;
        description = "Use the server UUID cache";
      };
      storage-method = mkOption {
        default = "yaml";
        type = types.str;
        description = "Storage method to use for LuckPerms";
      };
      sync-minutes = mkOption {
        default = -1;
        type = types.int;
        description = "How often to sync with the database";
      };
      watch-files = mkOption {
        default = true;
        type = types.bool;
        description = "Watch for changes";
      };
      messaging-service = mkOption {
        default = "auto";
        type = types.str;
        description = "Messaging service to use for LuckPerms";
      };
      auto-push-updates = mkOption {
        default = true;
        type = types.bool;
        description = "Automatically push updates to the database";
      };
      push-log-entries = mkOption {
        default = true;
        type = types.bool;
        description = "Push log entries to the database";
      };
      broadcast-received-log-entries = mkOption {
        default = true;
        type = types.bool;
        description = "Broadcast log entries to the server";
      };
      temporary-add-behaviour = mkOption {
        default = "deny";
        type = types.enum [ "accumulate" "replace" "deny" ];
        description = "How to handle temporary permissions";
      };
      primary-group-calculation = mkOption {
        default = "parents-by-weight";
        type = types.enum [ "stored" "parents-by-weight" "all-parents-by-weight" ];
        description = "How to calculate the primary group";
      };
      argument-based-command-permissions = mkOption {
        default = false;
        type = types.bool;
        description = "Enable argument-based command permissions";
      };
      require-sender-group-membership-to-modify = mkOption {
        default = false;
        type = types.bool;
        description = "Require sender group membership to modify permissions";
      };
      log-notify = mkOption {
        default = true;
        type = types.bool;
        description = "Log notifications";
      };
      log-notify-filtered-descriptions = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "Log filtered descriptions";
      };
      auto-install-translations = mkOption {
        default = true;
        type = types.bool;
        description = "Automatically install translations";
      };
      inheritance-traversal-algorithm = mkOption {
        default = "depth-first-pre-order";
        type = types.enum [ "breadth-first" "depth-first-pre-order" "depth-first-post-order" ];
        description = "Inheritance traversal algorithm";
      };
      post-traversal-inheritance-sort = mkOption {
        default = false;
        type = types.bool;
        description = "Sort post-traversal inheritance";
      };
      context-satisfy-mode = mkOption {
        default = "at-least-one-value-per-key";
        type = types.enum [ "at-least-one-value-per-key" "all-values-per-key" ];
        description = "Context satisfy mode";
      };
      disabled-contexts = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "Disabled contexts";
      };
      include-global = mkOption {
        default = true;
        type = types.bool;
        description = "Include global permissions";
      };
      include-global-world = mkOption {
        default = true;
        type = types.bool;
        description = "Include global world permissions";
      };
      apply-global-groups = mkOption {
        default = true;
        type = types.bool;
        description = "Apply global groups";
      };
      apply-global-world-groups = mkOption {
        default = true;
        type = types.bool;
        description = "Apply global world groups";
      };
      meta-value-selection-default = mkOption {
        default = "inheritance";
        type = types.enum [ "inheritance" "highest-number" "lowest-number" ];
        description = "Meta value selection default";
      };
      meta-value-selection = mkOption {
        default = { };
        type = types.attrsOf (types.enum [ "inheritance" "highest-number" "lowest-number" ]);
        description = "Meta value selection";
      };
      apply-wildcards = mkOption {
        default = true;
        type = types.bool;
        description = "Apply wildcards";
      };
      apply-sponge-implicit-wildcards = mkOption {
        default = false;
        type = types.bool;
        description = "Apply Sponge implicit wildcards";
      };
      apply-default-negated-permissions-before-wildcards = mkOption {
        default = false;
        type = types.bool;
        description = "Apply default negated permissions before wildcards";
      };
      apply-regex = mkOption {
        default = true;
        type = types.bool;
        description = "Apply regex";
      };
      apply-shorthand = mkOption {
        default = true;
        type = types.bool;
        description = "Apply shorthand";
      };
      apply-bukkit-child-permissions = mkOption {
        default = true;
        type = types.bool;
        description = "Apply Bukkit child permissions";
      };
      apply-bukkit-default-permissions = mkOption {
        default = true;
        type = types.bool;
        description = "Apply Bukkit default permissions";
      };
      apply-bukkit-attachment-permissions = mkOption {
        default = true;
        type = types.bool;
        description = "Apply Bukkit attachment permissions";
      };
      disabled-context-calculators = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "Disabled context calculators";
      };
      world-rewrite = mkOption {
        default = { };
        type = types.attrsOf types.str;
        description = "World rewrite";
      };
      group-weight = mkOption {
        default = { };
        type = types.attrsOf types.int;
        description = "Group weight";
      };
      enable-ops = mkOption {
        default = true;
        type = types.bool;
        description = "Enable ops";
      };
      auto-op = mkOption {
        default = false;
        type = types.bool;
        description = "Automatically op players";
      };
      commands-allow-op = mkOption {
        default = false;
        type = types.bool;
        description = "Commands allow op";
      };
      vault-unsafe-lookups = mkOption {
        default = false;
        type = types.bool;
        description = "Vault unsafe lookups";
      };
      vault-group-use-displaynames = mkOption {
        default = true;
        type = types.bool;
        description = "Vault group use displaynames";
      };
      vault-npc-group = mkOption {
        default = "default";
        type = types.str;
        description = "Vault NPC group";
      };
      vault-npc-op-status = mkOption {
        default = false;
        type = types.bool;
        description = "Vault NPC op status";
      };
      use-vault-server = mkOption {
        default = false;
        type = types.bool;
        description = "Use Vault server";
      };
      vault-server = mkOption {
        default = "global";
        type = types.str;
        description = "Vault server";
      };
      vault-include-global = mkOption {
        default = true;
        type = types.bool;
        description = "Vault include global";
      };
      vault-ignore-world = mkOption {
        default = false;
        type = types.bool;
        description = "Vault ignore world";
      };
      debug-logins = mkOption {
        default = false;
        type = types.bool;
        description = "Debug logins";
      };
      allow-invalid-usernames = mkOption {
        default = false;
        type = types.bool;
        description = "Allow invalid usernames";
      };
      skip-bulkupdate-confirmation = mkOption {
        default = false;
        type = types.bool;
        description = "Skip bulkupdate confirmation";
      };
      prevent-primary-group-removal = mkOption {
        default = false;
        type = types.bool;
        description = "Prevent primary group removal";
      };
      update-client-command-list = mkOption {
        default = true;
        type = types.bool;
        description = "Update client command list";
      };
      register-command-list-data = mkOption {
        default = true;
        type = types.bool;
        description = "Register command list data";
      };
      resolve-command-selectors = mkOption {
        default = false;
        type = types.bool;
        description = "Resolve command selectors";
      };
    };
    groups = mkOption {
      default = {
        default = {
          name = "default";
        };
      };
      type = types.attrsOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          parents = mkOption {
            default = [ ];
            type = types.listOf types.str;
          };
          permissions = mkOption {
            default = [ ];
            type = types.listOf (types.oneOf [
              types.str
              (types.attrsOf (types.submodule {
                options = {
                  value = mkOption {
                    type = types.bool;
                    default = true;
                  };
                  context = mkOption {
                    default = { };
                    type = types.attrsOf types.str;
                  };
                };
              }))
            ]);
          };
          prefixes = mkOption {
            default = [ ];
            type = types.listOf (types.attrsOf types.anything);
          };
          meta = mkOption {
            default = { };
            type = types.attrsOf types.anything;
          };
        };
      });
      description = "Group configuration";
    };
    users = mkOption {
      default = { };
      type = types.attrsOf (types.submodule {
        options = {
          uuid = mkOption {
            type = types.str;
          };
          name = mkOption {
            type = types.str;
          };
          primary-group = mkOption {
            type = types.str;
            default = "default";
          };
          parents = mkOption {
            default = [ "default" ];
            type = types.listOf types.str;
          };
          permissions = mkOption {
            default = [ ];
            type = types.listOf types.str;
          };
          prefixes = mkOption {
            default = [ ];
            type = types.listOf (types.attrsOf types.anything);
          };
          meta = mkOption {
            default = { };
            type = types.attrsOf types.anything;
          };
        };
      });
    };
  };
  config = mkIf cfg.enable {
    services.minecraft.plugins = [{
      package = luckperms;
      startScript = startScript;
    }];
  };
}

