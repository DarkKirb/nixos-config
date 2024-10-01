{
  callPackage,
  buildLinux,
  lib,
  linuxKernel,
  ...
} @ args:
buildLinux (
  args
  // {
    src = linuxKernel.packages.linux_rpi4.kernel.src;
    version = linuxKernel.packages.linux_rpi4.kernel.modDirVersion + "-v8";
    defconfig = "bcm2711_defconfig";
    autoModules = false;
    kernelPatches =
      linuxKernel.packages.linux_rpi4.kernel.kernelPatches
      ++ [
        {
          name = "devterm";
          patch = ./linux-devterm.patch;
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
      ];
    enableCommonConfig = false;
  }
)
