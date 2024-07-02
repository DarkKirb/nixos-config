{
  lib,
  config,
  pkgs,
  nixpkgs,
  nixos-hardware,
  ...
} @ args: {
  networking.hostName = "vf2";
  networking.hostId = "ad325df9";
  imports = [
    ./services/caddy
    ./services/acme.nix
    ./users/remote-build.nix
    ./systemd-boot.nix
    "${nixos-hardware}/starfive/visionfive/v2/default.nix"
  ];

  environment.noXlibs = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  nixpkgs.overlays = [
    (import ../overlays/riscv.nix args)
  ];

  nix.settings.substituters = lib.mkForce [
    "https://beam.attic.rs/riscv"
    "https://cache.ztier.in"
    "https://hydra.int.chir.rs"
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/nvme0n1p1";
      fsType = "vfat";
      options = ["nofail"];
    };
    "/" = {
      device = "/dev/nvme0n1p2";
      fsType = "btrfs";
      options = ["compress=zstd"];
    };
  };
  swapDevices = [
    {
      device = "/dev/nvme0n1p3";
    }
  ];
  #  hardware.deviceTree.name = "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";
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
    # There are many more combinations but i simply do not care lol
    "gccarch-rv64gc_zba_zbb"
    "gccarch-rv64gc_zba"
    "gccarch-rv64gc_zbb"
    "gccarch-rv64gc"
    "gccarch-rv32gc_zba_zbb"
    "gccarch-rv32gc_zba"
    "gccarch-rv32gc_zbb"
    "gccarch-rv32gc"
    "native-riscv"
  ];
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  services.tailscale.useRoutingFeatures = "server";

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
  ];
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.generic-extlinux-compatible.enable = false;
  #system.requiredKernelConfig = lib.mkForce [];
  system.autoUpgrade.allowReboot = true;
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.crossSystem = {
    config = "riscv64-unknown-linux-gnu";
    system = "riscv64-linux";
  };

  system.stateVersion = "24.05";
}
