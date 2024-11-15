{
  config,
  nixos-config,
  pkgs,
  ...
}:
{
  networking.hostName = "pc-installer";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./grub.nix
    ./hardware.nix
    "${nixos-config}/config/networkmanager.nix"
  ];
  system.stateVersion = config.system.nixos.version;
  specialisation.graphical = {
    configuration.imports = [
      ./graphical.nix
      "${nixos-config}/config/graphical/plymouth.nix"
      {
        nix.auto-update.specialisation = "graphical";
      }
    ];
  };
  specialisation.graphical-verbose = {
    configuration.imports = [
      ./graphical.nix
      {
        nix.auto-update.specialisation = "graphical-verbose";
      }
    ];
  };
  isInstaller = true;
  /*
    environment.etc."system/rainbow-resort".source = "${nixos-config.nixosConfigurations.rainbow-resort.config.system.build.toplevel
    }";
    environment.etc."system/rainbow-resort-disko".source = "${nixos-config.nixosConfigurations.rainbow-resort.config.system.build.diskoScript
    }";
    environment.etc."system/thinkrac".source = "${nixos-config.nixosConfigurations.thinkrac.config.system.build.toplevel
    }";
    environment.etc."system/thinkrac-disko".source = "${nixos-config.nixosConfigurations.thinkrac.config.system.build.diskoScript
    }";
  */
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "install-thinkrac-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#thinkrac" --disk main "${nixos-config.nixosConfigurations.thinkrac.config.disko.devices.disk.main.device}"
    '')
    (pkgs.writeShellScriptBin "install-rainbow-resort-unattended" ''
      set -eux
      exec ${pkgs.disko}/bin/disko-install --flake "${nixos-config}#rainbow-resort" --disk main "${nixos-config.nixosConfigurations.rainbow-resort.config.disko.devices.disk.main.device}"
    '')
  ];
}
