{
  lib,
  nix-packages,
  config,
  pkgs,
  nixpkgs,
  ...
} @ args: {
  networking.hostName = "vf2";
  networking.hostId = "ad325df9";
  imports = [
    ./services/caddy
    ./services/acme.nix
    ./users/remote-build.nix
    ./systemd-boot.nix
  ];

  environment.noXlibs = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.overlays = [
    (import ../overlays/riscv.nix)
  ];

  nix.settings.substituters = ["https://beam.attic.rs/riscv"];
  boot = {
    supportedFilesystems = lib.mkForce ["vfat" "ext4" "nfs"];
    kernelPackages = pkgs.linuxPackagesFor (pkgs.vf2Kernel.override {
      kernelPatches = with pkgs; [
        # https://lore.kernel.org/all/20230524000012.15028-1-andre.przywara@arm.com/
        rec {
          name = "axp15060-1.patch";
          patch = fetchpatch {
            inherit name;
            url = "https://lore.kernel.org/all/20230524000012.15028-2-andre.przywara@arm.com/raw";
            hash = "sha256-kj4vQaT4CV29EHv8MtuTgM/semIPDdv2dmveo/X27vU=";
          };
        }
        rec {
          name = "axp15060-2.patch";
          patch = fetchpatch {
            inherit name;
            url = "https://lore.kernel.org/all/20230524000012.15028-3-andre.przywara@arm.com/raw";
            hash = "sha256-QCPQyKqoapMtqEDB9QgAuXA7n8e1OtG+YlIgeSQBxXM=";
          };
        }
        rec {
          name = "axp15060-3.patch";
          patch = fetchpatch {
            inherit name;
            url = "https://lore.kernel.org/all/20230524000012.15028-4-andre.przywara@arm.com/raw";
            hash = "sha256-SpKDm4PXR6qs7kX5SGVpFF/EPBijMhX1NsFUHrlCynM=";
          };
        }
      ];
      argsOverride = {
        structuredExtraConfig = with lib.kernel; {
          CPU_FREQ = yes;
          CPUFREQ_DT = yes;
          CPUFREQ_DT_PLATDEV = yes;
          DMADEVICES = yes;
          GPIO_SYSFS = yes;
          HIBERNATION = yes;
          NO_HZ_IDLE = yes;
          POWER_RESET_GPIO_RESTART = yes;
          PROC_KCORE = yes;
          PWM = yes;
          PWM_STARFIVE_PTC = yes;
          RD_GZIP = yes;
          SENSORS_SFCTEMP = yes;
          SERIAL_8250_DW = yes;
          SIFIVE_CCACHE = yes;
          SIFIVE_PLIC = yes;

          RTC_DRV_STARFIVE = yes;
          SPI_PL022 = yes;
          SPI_PL022_STARFIVE = yes;

          I2C = yes;
          MFD_AXP20X = yes;
          MFD_AXP20X_I2C = yes;
          REGULATOR_AXP20X = yes;

          # FATAL: modpost: drivers/gpu/drm/verisilicon/vs_drm: struct of_device_id is not terminated with a NULL entry!
          DRM_VERISILICON = no;

          PL330_DMA = no;
        };
        preferBuiltin = true;
      };
    });
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200"
      "earlycon=sbi"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 7;
    initrd.availableKernelModules = [
      "dw_mmc-starfive"
      "motorcomm"
      "dwmac-starfive"
      "cdns3-starfive"
      "jh7110-trng"
      "jh7110-crypto"
      "phy-jh7110-usb"
      "phy-starfive-dphy-rx"
      "clk-starfive-jh7110-aon"
      "clk-starfive-jh7110-stg"
      # "clk-starfive-jh7110-vout"
      "clk-starfive-jh7110-isp"
      # "clk-starfive-jh7100-audio"
      "phy-jh7110-pcie"
      "pcie-starfive"
      "nvme"
      "nfsv4"
    ];
    initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.nfs-utils}/bin/mount.nfs
    '';
    blacklistedKernelModules = [
      "clk-starfive-jh7110-vout"
    ];
    loader.systemd-boot.extraInstallCommands = ''
      set -euo pipefail
      cp --no-preserve=mode -r ${config.hardware.deviceTree.package} ${config.boot.loader.efi.efiSysMountPoint}/
      for filename in ${config.boot.loader.efi.efiSysMountPoint}/loader/entries/nixos*-generation-[1-9]*.conf; do
        if ! ${pkgs.gnugrep}/bin/grep -q 'devicetree' $filename; then
          echo "devicetree /dtbs/${config.hardware.deviceTree.name}" >> $filename
        fi
      done
    '';
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = ["nofail"];
    };
    "/" = {
      device = "192.168.2.1:/export/vf2";
      fsType = "nfs";
      options = ["nofail" "local_lock=all" "nfsvers=4.2"];
    };
  };
  boot.initrd.network.enable = true;
  boot.initrd.network.flushBeforeStage2 = false;
  hardware.deviceTree.name = "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";
  system.stateVersion = "23.05";
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix {
    desktop = false;
    inherit args;
  };
  nix.settings.cores = 4;
  nix.settings.max-jobs = 4;
  nix.settings.system-features = [
    "nixos-test"
    "big-parallel"
    "benchmark"
    "ca-derivations"
    "gccarch-riscv-i"
    "gccarch-riscv-m"
    "gccarch-riscv-a"
    "gccarch-riscv-f"
    "gccarch-riscv-d"
    "gccarch-riscv-c"
  ];
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  sops.secrets."root/.ssh/id_ed25519" = {
    owner = "root";
    path = "/root/.ssh/id_ed25519";
  };
  system.autoUpgrade.allowReboot = true;
  services.tailscale.useRoutingFeatures = "server";
  boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

  nixpkgs = {
    buildPlatform.config = "x86_64-linux";
    hostPlatform.config = "riscv64-linux";
    pkgs = lib.mkForce (import nixpkgs {
      system = "x86_64-linux";
      crossSystem = "riscv64-linux";
      inherit (config.nixpkgs) config overlays;
    });
  };

  nix.settings.post-build-hook = lib.mkForce "true";
}
