{
  lib,
  pkgs,
  nixos-hardware,
  ...
}:
{
  imports = [
    "${nixos-hardware}/raspberry-pi/4"
  ];
  #boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux-devterm);
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  boot.kernelPatches = [

    {
      name = "AXP20x clockwork pi support";
      patch = ./patches/0002-mfd-axp20x-add-clockworkpi-a06-power-support.patch;
    }

    /*
      {
        name = "CWD686 drm panel";
        patch = ./patches/0004-gpu-drm-panel-add-cwd686-driver.patch;
        extraStructuredConfig.DRM_PANEL_CWD686 = lib.kernel.module;
      }
    */
    {
      name = "CWD686 drm panel";
      patch = ./patches/0003-cwd686.patch;
      extraStructuredConfig.DRM_PANEL_CLOCKWORKPI_CWD686 = lib.kernel.module;
    }
    {
      name = "OCP8178 backlight";
      patch = ./patches/0005-video-backlight-add-ocp8178-driver.patch;
      extraStructuredConfig.BACKLIGHT_OCP8178 = lib.kernel.module;
    }
  ];
  boot.kernelParams = [
    "fbcon=rotate:1"
    "earlycon=uart8250,mmio32,0xfe215040"
    "console=serial0,115200"
    "8250.nr_uarts=1"
  ];
  boot.initrd = {
    #includeDefaultModules = false;
    availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb" # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
      "mmc_block"
      "usbhid"
      "hid_generic"
      "panel_clockworkpi_cwd686"
      "ocp8178_bl"
      "ti_adc081c"
    ];
  };
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];
  hardware.deviceTree.name = "broadcom/bcm2711-rpi-cm4.dtb";
  hardware.deviceTree.filter = "bcm2711-rpi-cm4.dtb";
  hardware.raspberry-pi."4" = {
    #audio.enable = true;
    dwc2 = {
      enable = true;
      dr_mode = "host";
    };
    apply-overlays-dtmerge.enable = true;
  };

  hardware.deviceTree.overlays = [
    /*
      {
        name = "dwc2";
        dtsFile = ./dts/dwc2-overlay.dts;
      }
    */
    {
      name = "cma";
      dtsFile = ./dts/cma-overlay.dts;
    }
    {
      name = "devterm-fan";
      dtsFile = ./dts/devterm-fan-overlay.dts;
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
  services.xserver.videoDrivers = lib.mkBefore [
    "modesetting" # Prefer the modesetting driver in X11
    "fbdev" # Fallback to fbdev
  ];
}
