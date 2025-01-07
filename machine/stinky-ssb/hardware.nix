{ lib, pkgs, ... }:
{
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux-devterm);
  boot.kernelParams = [ "fbcon=rotate:1" ];
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
  hardware.deviceTree.filter = "*rpi*.dtb";
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
      name = "vc4-kms-v3d-pi4";
      dtsFile = ./devterm/vc4-kms-v3d-pi4-overlay.dts;
    }
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
  services.xserver.xkbVariant = lib.mkForce "us";
  console.keyMap = lib.mkForce "us";
  home-manager.users.darkkirb.wayland.windowManager.sway.config.input."*" = lib.mkForce {
    xkb_layout = "us";
    xkb_variant = "altgr-intl";
  };
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "darkkirb";
    };
    sddm = {
      autoLogin.relogin = true;
    };
  };
}
