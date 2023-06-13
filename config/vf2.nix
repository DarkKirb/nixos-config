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
  ];

  environment.noXlibs = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.overlays = [
    (import ../overlays/riscv.nix)
  ];

  nix.settings.substituters = ["https://beam.attic.rs/riscv"];
  boot = {
    supportedFilesystems = lib.mkForce ["vfat" "ext4"];
    kernelPackages = pkgs.linuxPackagesFor (pkgs.vf2Kernel.override {
      structuredExtraConfig = with lib.kernel; {
        DRM_VERISILICON = no;
      };
    });
    initrd.includeDefaultModules = false;
    initrd.availableKernelModules = [
      "dw_mmc-pltfm"
      "dw_mmc-starfive"
      "dwmac-starfive"
      "spi-dw-mmio"
      "mmc_block"
      "nvme"
      "sdhci"
      "sdhci-pci"
      "sdhci-of-dwcmshc"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = ["nofail" "noauto"];
    };
    "/" = {
      device = "192.168.2.1:/export/vf2";
      fsType = "nfs";
      options = ["nofail" "local_lock=all" "nfsvers=4.2"];
    };
  };
  boot.initrd.network.enable = true;
  hardware.deviceTree.name = "starfive/jh7110-visionfive-v2.dtb";
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

  systemd.services."serial-getty@hvc0".enable = false;

  # If getty is not explicitly enabled, it will not start automatically.
  # https://github.com/NixOS/nixpkgs/issues/84105
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = ["getty.target"];
    serviceConfig.Restart = "always";
  };

  nixpkgs = {
    buildPlatform.config = "x86_64-linux";
    hostPlatform.config = "riscv64-linux";
    pkgs = lib.mkForce (import nixpkgs {
      system = "x86_64-linux";
      crossSystem = "riscv64-linux";
      inherit (config.nixpkgs) config overlays;
    });
  };
}
