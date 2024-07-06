{
  config,
  pkgs,
  modulesPath,
  lib,
  nixos-hardware,
  ...
}: {
  networking.hostName = "rainbow-resort";
  networking.hostId = "776736c6";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
    ./services/tpm2.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    ./users/remote-build.nix
    #./services/kubernetes.nix
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "k10temp"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd" "i2c-dev" "i2c-piix4"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "amd";
  };

  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linux_xanmod_latest);

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/23690ff2-7a65-431e-a6ee-fea0878e0bb1";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B6BA-BE40";
    fsType = "vfat";
  };

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = ["/"];
  };
  services.snapper.configs.main = {
    SUBVOLUME = "/";
    TIMELINE_LIMIT_HOURLY = "5";
    TIMELINE_LIMIT_DAILY = "7";
    TIMELINE_LIMIT_WEEKLY = "4";
    TIMELINE_LIMIT_MONTHLY = "12";
    TIMELINE_LIMIT_YEARLY = "0";
  };
  services.beesd.filesystems.root = {
    spec = "/";
    hashTableSizeMB = 2048;
    verbosity = "crit";
    extraOptions = ["--loadavg-target" "5.0"];
  };

  networking.interfaces.enp13s0.useDHCP = true;

  system.stateVersion = "23.11";

  services.xserver.videoDrivers = ["amdgpu"];

  nix.settings.cores = 16;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "wasm32-wasi"
    "riscv32-linux"
    "riscv64-linux"
  ];
  hardware.enableRedistributableFirmware = true;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-znver4"
    "gccarch-znver3"
    "gccarch-znver2"
    "gccarch-znver1"
    "gccarch-skylake"
    "gccarch-skylake-avx512"
    "ca-derivations"
  ];

  services.tailscale.useRoutingFeatures = "client";
  home-manager.users.darkkirb._module.args.withNSFW = lib.mkForce true;
  system.autoUpgrade.allowReboot = true;
  services.prometheus.exporters.node.enabledCollectors = ["drm"];
  services.k3s.role = lib.mkForce "agent";

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    # Thank you amd for not supporting 11.0.1
    environmentVariables.HCC_AMDGPU_TARGET = "gfx1100";
    rocmOverrideGfx = "11.0.0";
  };
}
