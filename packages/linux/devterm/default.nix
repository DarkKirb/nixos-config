{
  callPackage,
  buildLinux,
  lib,
  ...
}@args:
let
  devterm = callPackage ./devterm.nix { };
in
buildLinux (
  args
  // {
    src = callPackage ./kernel-source.nix { };
    version = "5.10.17-v8";
    defconfig = "bcm2711_defconfig";
    autoModules = false;
    kernelPatches = [
      {
        name = "devterm";
        patch = "${devterm}/Code/patch/cm4/cm4_kernel_0704.patch";
        extraStructuredConfig = with lib.kernel; {
          AXP20X_ADC = module;
          AXP20X_POWER = module;
          BATTERY_AXP20X = module;
          CHARGER_AXP20X = module;
          INPUT_AXP20X_PEK = yes;
          MFD_AXP20X = yes;
          MFD_AXP20X_I2C = yes;
          REGULATOR_AXP20X = yes;
          BACKLIGHT_OCP8178 = module;
          DRM_PANEL_CWD686 = module;
          TI_ADC081C = module;
          I2C_BCM2835 = yes;
          FW_LOADER_COMPRESS = yes;
        };
      }
      {
        name = "subcmd-util";
        patch = ./subcmd-util.patch;
        extraConfig = "";
      }
    ];
    ignoreConfigErrors = true;
    enableCommonConfig = false;
  }
)
