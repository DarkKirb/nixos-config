{
  config,
  pkgs,
  modulesPath,
  lib,
  nixos-hardware,
  system,
  nix-packages,
  ...
}: {
  networking.hostName = "devterm";
  networking.hostId = "b83a2c93";

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor nix-packages.packages.${system}.rpi4Kernel);

  boot.kernelPatches = [
    {
      name = "devterm-cm4";
      patch = ./workarounds/devterm-kernel.patch;
    }
  ];

  imports = [
    ./desktop.nix
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    dwc2.enable = true;
    i2c1.enable = true;
    apply-overlays-dtmerge.enable = true;
    pwm0.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
  system.stateVersion = "22.11";
  nix.settings.cores = 4;
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = ["networkmanager"];
  nix.settings.max-jobs = 4;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  services.joycond.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.tailscale.useRoutingFeatures = "client";
}
