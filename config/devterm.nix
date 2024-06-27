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
  ];
  boot.loader = {
    grub.enable = lib.mkDefault false;
    generic-extlinux-compatible.enable = lib.mkDefault true;
  };
  boot.initrd = {
    includeDefaultModules = false;
    availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb" # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
      "mmc_block"
      "usbhid"
      "hid_generic"
      "panel_cwd686"
      "ocp8178_bl"
      "ti_adc081c"
    ];
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
  security.pam = {
    services.login.u2fAuth = lib.mkForce false;
    services.swaylock.u2fAuth = lib.mkForce false;
    u2f.enable = lib.mkForce false;
    services.sddm.u2fAuth = lib.mkForce false;
  };
  console.keyMap = lib.mkForce "us";
  services.xserver.layout = lib.mkForce "us";
  services.xserver.xkbVariant = lib.mkForce "";
  services.displayManager.sddm = {
    autoLogin.enable = true;
    autoLogin.user = "darkkirb";
  };
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = ["networkmanager"];
}
