{
  config,
  lib,
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

  config = mkIf config.environment.impermanence.enable {
    systemd.services = listToAttrs (flatten (map (name: let
        cfg = config.users.users.${name};
      in [
        {
          name = "cleanup-home-${name}";
          description = "Clean home directory for ${name}";
          value = {
            wantedBy = [
              "user-${toString cfg.uid}.slice"
            ];
            before = [
              "user-${toString cfg.uid}.slice"
              "home-manager-${name}.service"
            ];
            serviceConfig.Type = "oneshot";
            script = ''
              if [[ -e ${cfg.home} ]]; then
                timestamp=$(date --date="@$(stat -c %X ${cfg.home})" "+%Y-%m-%d_%H:%M:%S")
                mkdir - p /persistent/old-homedirs/${name}
                mv ${cfg.home} /home/old-homedirs/${name}/$timestamp
              fi

              delete_subvolume_recursively() {
                IFS=$'\n'
                for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                  delete_subvolume_recursively "/persistent/old-homedirs/${name}/$i"
                done
                btrfs subvolume delete "$1"
              }

              for i in $(find /persistent/old-homedirs/${name} -maxdepth 1 -mtime +30); do
                delete_subvolume_recursively "$i"
              done

              btrfs subvolume create ${cfg.home}
            '';
          };
        }
        {
          name = "home-manager-${name}";
          value = {
            wantedBy = mkForce [
              "user-${toString cfg.uid}.slice"
            ];
            after = [
              "cleanup-home-${name}.service"
            ];
            before = [
              "user-${toString cfg.uid}.slice"
            ];
          };
        }
      ])
      config.environment.impermanence.users));
  };
}
