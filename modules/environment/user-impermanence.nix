{
  config,
  lib,
  pkgs,
  inTester,
  ...
}:
with lib; {
  options = {
    environment.impermanence.users = mkOption {
      description = "Which users to clean up the home directory for";
      default = [];
      type = types.listOf types.str;
    };
  };

  config = mkIf (config.environment.impermanence.enable && config.environment.impermanence.users != []) {
    programs.fuse.userAllowOther = true;
    home-manager.users = listToAttrs (map (name: {
        inherit name;
        value.home.persistence.default = {
          persistentStoragePath = "/persistent/home/${name}";
          allowOther = true;
          directories = [
            "Downloads"
            "Music"
            "Pictures"
            "Documents"
            "Videos"
            ".cache"
          ];
        };
      })
      config.environment.impermanence.users);
    systemd.tmpfiles.rules = map (name: "d /persistent/home/${name}/.cache 700 ${name} ${name} 7d -") config.environment.impermanence.users;
    systemd.services = listToAttrs (flatten (map (name: let
        cfg = config.users.users.${name};
      in [
        {
          name = "cleanup-home-${name}";
          description = "Clean home directory for ${name}";
          value = {
            before = [
              "user@${toString cfg.uid}.service"
              "home-manager-${name}.service"
            ];
            partOf = [
              "home-manager-${name}.service"
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
                for i in $(${pkgs.btrfs-progs}/bin/btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/persistent/old-homedirs/${name}/$i"
                done
                ${pkgs.btrfs-progs}/bin/btrfs subvolume delete "$1" || rm -rf "$1"
              }

              for i in $(find /persistent/old-homedirs/${name} -maxdepth 1 -atime +30); do
                delete_subvolume_recursively "$i"
              done

              ${pkgs.btrfs-progs}/bin/btrfs subvolume create ${cfg.home}
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
              "cleanup-home-${name}.service"
            ];
            wantedBy = mkForce [
              "user@${toString cfg.uid}.service"
            ];
            after = [
              "cleanup-home-${name}.service"
            ];
            before = [
              "user@${toString cfg.uid}.service"
            ];
            partOf = [
              "user@${toString cfg.uid}.service"
            ];
          };
        }
      ])
      config.environment.impermanence.users));
  };
}
