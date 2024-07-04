{
  pkgs,
  lib,
  ...
} @ args: {
  networking.hostName = "rpi2";
  networking.hostId = "29d7b964";
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  system.stateVersion = "24.05";
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix {
    desktop = false;
    inherit args;
  };
  nix.settings.cores = 4;
  nixpkgs.crossSystem = {
    config = "armv7l-unknown-linux-gnueabihf";
    system = "armv7l-linux";
  };
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi2;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      generationsDir.enable = lib.mkDefault false;
      raspberryPi = {
        enable = lib.mkDefault true;
        version = lib.mkDefault 2;
      };
    };
  };
  nixpkgs.config.platform = lib.systems.platforms.raspberrypi2;
  powerManagement.enable = lib.mkDefault false;
}
