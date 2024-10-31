{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.nix.auto-update = {
    enable = mkEnableOption "enable automatic updates";
    reboot = mkEnableOption "Reboot if kernel change";
    hydraServer = mkOption {
      type = types.str;
      description = "Location of hydra server";
      default = "https://hydra.chir.rs";
    };
    source = mkOption {
      type = types.str;
      description = "Source to update from";
      default = "${config.nix.auto-update.hydraServer}/jobset/nixos-config/pr618/evals";
    };
    attr = mkOption {
      type = types.str;
      description = "Attribute to update from";
      default = "nixosConfigurations.${config.networking.hostName}";
    };
  };

  config.nix.auto-update.enable = mkDefault config.nix.enable;
  config.nix.auto-update.reboot = mkDefault true;
  config.systemd.services.nixos-upgrade = mkIf config.nix.enable {
    description = "NixOS Upgrade";
    restartIfChanged = false;
    unitConfig.X-StopOnRemoval = false;

    wants = ["network-online.target"];
    after = ["network-online.target"];

    serviceConfig.Type = "oneshot";

    script = ''
      #!${pkgs.bash}/bin/bash
      set -euxo pipefail
      builds=$(${pkgs.curl}/bin/curl -H "accept: application/json" ${config.nix.auto-update.source} | ${pkgs.jq}/bin/jq -r '.evals[0].builds[]')
      for build in $builds; do
        doc=$(${pkgs.curl}/bin/curl -H "accept: application/json" ${config.nix.auto-update.hydraServer}/build/$build)
        jobname=$(echo $doc | ${pkgs.jq}/bin/jq -r '.job')
        if [ "$jobname" = "${config.nix.auto-update.attr}" ]; then
          drvname=$(echo $doc | ${pkgs.jq}/bin/jq -r '.drvpath')
          output=$(${pkgs.nix}/bin/nix-store -r $drvname)
          ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set $output
          ${
        if config.nix.auto-update.reboot
        then ''
          $output/bin/switch-to-configuration boot
          booted="$(${pkgs.coreutils}/bin/readlink /run/booted-system/{initrd,kernel,kernel-modules})"
          built="$(${pkgs.coreutils}/bin/readlink $output/{initrd,kernel,kernel-modules})"
          if [ "$booted" = "$built" ]; then
            $output/bin/switch-to-configuration switch
          else
              ${pkgs.systemd}/bin/shutdown -r +1
          fi
          exit
        ''
        else ''
          $output/bin/switch-to-configuration switch
        ''
      }
        fi
      done
    '';
  };

  config.systemd.timers.nixos-upgrade = {
    enable = config.nix.auto-update.enable;
    description = "Automatically update nixos";
    requires = ["nixos-upgrade.service"];
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    timerConfig = {
      OnUnitActiveSec = "30min";
      RandomizedDelaySec = "1h";
    };
  };
  config.assertions = [
    {
      assertion = config.nix.auto-update.enable -> config.nix.enable;
      message = "Auto updating will only work when nix itself is enabled.";
    }
  ];
}
