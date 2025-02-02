{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nix.auto-update;
in
with lib;
{
  options.nix.auto-update = {
    enable = mkEnableOption "enable automatic updates";
    reboot = mkEnableOption "Reboot if kernel change";
    hydraServer = mkOption {
      type = types.str;
      description = "Location of hydra server";
      default = "https://hydra.chir.rs";
    };
    project = mkOption {
      type = types.str;
      description = "Project name to use";
      default = "flakes";
    };
    jobset = mkOption {
      type = types.str;
      description = "Jobset name to use";
      default = "nixos-config";
    };
    job = mkOption {
      type = types.str;
      description = "Job name to use";
      default = "nixosConfigurations.${config.networking.hostName}";
      defaultText = literalExpression ''"nixosConfigurations.''${config.networking.hostName}"'';
    };
    specialisation = mkOption {
      type = types.nullOr types.str;
      description = "specialisation to switch into";
      default = null;
    };
  };

  config.nix.auto-update.enable = mkDefault config.nix.enable;
  config.nix.auto-update.reboot = mkDefault true;
  config.systemd.services.nixos-upgrade = mkIf config.nix.enable {
    description = "NixOS Upgrade";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig.Type = "oneshot";

    script =
      let
        output =
          if cfg.specialisation == null then "$output" else "$output/specialisation/${cfg.specialisation}";
        switchToConfiguration = "${output}/bin/switch-to-configuration";
      in
      ''
        #!${lib.getExe pkgs.bash}
        set -euxo pipefail
        build=$(${lib.getExe pkgs.curl} -H "accept: application/json" -G ${cfg.hydraServer}/api/latestbuilds -d "nr=10" -d "project=${cfg.project}" -d "jobset=${cfg.jobset}" -d "job=${cfg.job}" | ${lib.getExe pkgs.jq} -r '[.[]|select(.buildstatus==0)][0].id')
        doc=$(${lib.getExe pkgs.curl} -H "accept: application/json" ${cfg.hydraServer}/build/$build)
        drvname=$(echo $doc | ${lib.getExe pkgs.jq} -r '.drvpath')
        output=$(${lib.getExe' pkgs.nix "nix-store"} -r $drvname)
        if [ "$(${lib.getExe' pkgs.coreutils "readlink"} -f /nix/var/nix/profiles/system)" = "$output" ]; then
          echo "still up-to-date!"
          exit 0
        fi
        ${lib.getExe' pkgs.nix "nix-env"} -p /nix/var/nix/profiles/system --set $output
        ${
          if cfg.reboot then
            ''
              ${switchToConfiguration} boot
              booted="$(${lib.getExe' pkgs.coreutils "readlink"} /run/booted-system/{kernel,kernel-modules})"
              built="$(${lib.getExe' pkgs.coreutils "readlink"} ${output}/{kernel,kernel-modules})"
              if [ "$booted" = "$built" ]; then
                ${switchToConfiguration} switch
              else
                ${lib.getExe' pkgs.systemd "shutdown"} -r +1
              fi
              exit
            ''
          else
            ''
              ${switchToConfiguration} switch
            ''
        }
      '';
  };

  config.systemd.timers.nixos-upgrade = {
    enable = cfg.enable;
    description = "Automatically update nixos";
    requires = [ "nixos-upgrade.service" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = "30min";
      RandomizedDelaySec = "1h";
    };
  };
  config.assertions = [
    {
      assertion = cfg.enable -> config.nix.enable;
      message = "Auto updating will only work when nix itself is enabled.";
    }
    {
      assertion = (cfg.specialisation != null) -> config.isSpecialisation;
      message = "Automatic update switching to specialisation is only allowed in specialisations";
    }
    {
      assertion = config.isSpecialisation -> (cfg.specialisation != null);
      message = "Specifying the specialization name is required for autoupdate to work!";
    }
  ];
}
