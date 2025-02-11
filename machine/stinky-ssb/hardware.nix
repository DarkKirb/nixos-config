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
  hardware.deviceTree.name = "broadcom/bcm2711-rpi-cm4.dtb";
  hardware.deviceTree.filter = "*rpi-cm4*.dtb";
  hardware.deviceTree.overlays = [
    {
      name = "dwc2";
      dtsFile = ./dts/dwc2-overlay.dts;
    }
    {
      name = "cma";
      dtsFile = ./dts/cma-overlay.dts;
    }
    {
      name = "vc4-kms-v3d-pi4";
      dtsFile = ./dts/vc4-kms-v3d-pi4-overlay.dts;
    }
    {
      name = "devterm-pmu";
      dtsFile = ./dts/devterm-pmu-overlay.dts;
    }
    {
      name = "devterm-panel";
      dtsFile = ./dts/devterm-panel-overlay.dts;
    }
    {
      name = "devterm-misc";
      dtsFile = ./dts/devterm-misc-overlay.dts;
    }
    {
      name = "audremap";
      dtsFile = ./dts/audremap-overlay.dts;
    }
    {
      name = "spi";
      dtsFile = ./dts/spi0-overlay.dts;
    }
  ];
  services.xserver.xkb.variant = lib.mkForce "us";
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
  boot.initrd.systemd.tpm2.enable = lib.mkForce false;
  systemd.tpm2.enable = lib.mkForce false;
  nixpkgs.overlays = [
    (_final: prev: {
      deviceTree = prev.deviceTree // {
        applyOverlays = _final.callPackage ./apply-overlays-dtmerge.nix { };
      };
    })
  ];
  boot.initrd.systemd.enable = lib.mkForce false;
}
