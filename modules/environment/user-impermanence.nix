{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  persistName = ent: if builtins.isAttrs ent then ent.directory else ent;
  tmpfiles_rule =
    user: ent:
    let
      name = persistName ent;
    in
    if name == ".cache" then
      "d /persistent/home/${user}/.cache 700 ${user} ${config.users.users.${user}.group} 7d -"
    else
      "d /persistent/home/${user}/${name} 700 ${user} ${config.users.users.${user}.group} - -";
in
{
  options = {
    environment.impermanence.users = mkOption {
      description = "Which users to clean up the home directory for";
      default = [ ];
      type = types.listOf types.str;
    };
  };

  config =
    mkIf (config.environment.impermanence.enable && config.environment.impermanence.users != [ ])
      {
        programs.fuse.userAllowOther = true;
        home-manager.users = listToAttrs (
          map (name: {
            inherit name;
            value =
              { config, ... }:
              {
                home.file."${config.home.homeDirectory}/.cache/.keep" = {
                  enable = false;
                };
                home.persistence.default = {
                  persistentStoragePath = "/persistent/home/${name}";
                  allowOther = true;
                  defaultMethod = "symlink";
                  directories = [
                    "Downloads"
                    "Music"
                    "Pictures"
                    "Documents"
                    "Videos"
                    ".cache"
                    "Data"
                    ".local/state/wireplumber"
                  ];
                };
              };
          }) config.environment.impermanence.users
        );
        systemd.tmpfiles.rules = mkMerge (
          map (
            user:
            map (tmpfiles_rule user) (
              [ "" ] ++ config.home-manager.users.darkkirb.home.persistence.default.directories
            )
          ) config.environment.impermanence.users
        );
        systemd.services = listToAttrs (
          flatten (
            map (
              name:
              let
                cfg = config.users.users.${name};
              in
              [
                {
                  name = "cleanup-home-${name}";
                  description = "Clean home directory for ${name}";
                  value = {
                    before = [
                      "user@${toString cfg.uid}.service"
                      "home-manager-${name}.service"
                    ];
                    partOf = [
                      "user@${toString cfg.uid}.service"
                    ];
                    conflicts = [
                      "home-darkkirb-.mozilla.mount"
                      "home-darkkirb-.thunderbird.mount"
                    ];
                    serviceConfig.Type = "oneshot";
                    script = ''
                      if [[ -e ${cfg.home} ]]; then
                        timestamp=$(date --date="@$(stat -c %X ${cfg.home})" "+%Y-%m-%d_%H:%M:%S")
                        mkdir -p /persistent/old-homedirs/${name}
                        mv ${cfg.home} /persistent/old-homedirs/${name}/$timestamp
                      fi

                      delete_subvolume_recursively() {
                        IFS=$'\n'
                        for i in $(${lib.getExe' pkgs.btrfs-progs "btrfs"} subvolume list -o "$1" | cut -f 9- -d ' '); do
                          delete_subvolume_recursively "/persistent/old-homedirs/${name}/$i"
                        done
                        ${lib.getExe' pkgs.btrfs-progs "btrfs"} subvolume delete "$1" || rm -rf "$1"
                      }

                      for i in $(find /persistent/old-homedirs/${name} -maxdepth 1 -atime +30); do
                        delete_subvolume_recursively "$i"
                      done

                      ${lib.getExe' pkgs.btrfs-progs "btrfs"} subvolume create ${cfg.home}
                      chown -R ${name}:${cfg.group} ${cfg.home}

                      mkdir -p /persistent/home/${name}
                      chown -R ${name}:${cfg.group} /persistent/home/${name}
                    '';
                  };
                }
                {
                  name = "home-manager-${name}";
                  value = {
                    wants = [
                      "home-darkkirb-.mozilla.mount"
                      "home-darkkirb-.thunderbird.mount"
                    ];
                    wantedBy = [
                      "user@${toString cfg.uid}.service"
                    ];
                    after = [
                      "cleanup-home-${name}.service"
                      "home-darkkirb-.mozilla.mount"
                      "home-darkkirb-.thunderbird.mount"
                    ];
                    before = [
                      "user@${toString cfg.uid}.service"
                    ];
                    partOf = [
                      "user@${toString cfg.uid}.service"
                    ];
                  };
                }
              ]
            ) config.environment.impermanence.users
          )
        );
      };
}
