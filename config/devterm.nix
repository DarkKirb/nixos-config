{
  nixos-hardware,
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux-devterm;
  networking.hostName = "devterm";
  imports = [
    ./desktop.nix
    nixos-hardware.nixosModules.raspberry-pi-4
  ];
  hardware = {
    raspberry-pi."4" = {
      #apply-overlays-dtmerge.enable = true;
      #fkms-3d.enable = true;
      #audio.enable = true;
    };
    deviceTree = {
      enable = true;
      #filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];
  system.stateVersion = "24.05";
  fileSystems."/" = {
    device = "/dev/mmcblk0p2";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/mmcblk0p1";
    fsType = "vfat";
  };
}
