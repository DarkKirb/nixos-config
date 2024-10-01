{
  nixos-hardware,
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux-devterm;
  boot.kernelParams = ["fbcon=rotate:1"];
  networking.hostName = "devterm";
  imports = [
    ./desktop.nix
    "${nixos-hardware}/raspberry-pi/4/pkgs-overlays.nix"
  ];
  boot.loader = {
    grub.enable = lib.mkDefault false;
    generic-extlinux-compatible.enable = lib.mkDefault true;
  };
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
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
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = ["networkmanager"];
  hardware.deviceTree.filter = "bcm2711-rpi-cm4.dtb";
  hardware.deviceTree.overlays = [
    {
      name = "dwc2";
      dtsFile = ./devterm/dwc2-overlay.dts;
    }
    {
      name = "cma";
      dtsFile = ./devterm/cma-overlay.dts;
    }
    {
      name = "i2c0-overlay";
      dtsFile = ./devterm/i2c0-overlay.dts;
    }
    /*
      {
      name = "vc4-kms-v3d-pi4";
      dtsFile = ./devterm/vc4-kms-v3d-pi4-overlay.dts;
    }
    */
    {
      name = "devterm-pmu";
      dtsFile = ./devterm/devterm-pmu-overlay.dts;
    }
    {
      name = "devterm-panel";
      dtsFile = ./devterm/devterm-panel-overlay.dts;
    }
    {
      name = "devterm-misc";
      dtsFile = ./devterm/devterm-misc-overlay.dts;
    }
    {
      name = "audremap";
      dtsFile = ./devterm/audremap-overlay.dts;
    }
    {
      name = "spi";
      dtsFile = ./devterm/spi0-overlay.dts;
    }
    {
      name = "devterm-overlay";
      dtsFile = ./devterm/devterm-overlay.dts;
    }
  ];
  hardware.enableRedistributableFirmware = true;
  services.xserver.xkbVariant = lib.mkForce "us";
  console.keyMap = lib.mkForce "us";
  home-manager.users.darkkirb.wayland.windowManager.sway.config.input."*" = lib.mkForce {
    xkb_layout = "us";
    xkb_variant = "altgr-intl";
  };
  boot.initrd.systemd.tpm2.enable = lib.mkForce false;
  systemd.tpm2.enable = lib.mkForce false;
}
