{
  lib,
  config,
  pkgs,
  nixpkgs,
  nixos-hardware,
  riscv-overlay,
  lix,
  ...
} @ args: let
  pkgs_x86_64 = import nixpkgs {
    system = "x86_64-linux";
    crossSystem.system = "riscv64-linux";
    overlays = [lix.overlays.default];
  };
in {
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
    riscv-overlay.overlays.default
    (self: super: {
      inherit (pkgs_x86_64) lix;
      nixos-option = super.nixos-option.override {
        nix = self.nixVersions.stable_upstream;
      };
    })
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
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.generic-extlinux-compatible.enable = false;
  #system.requiredKernelConfig = lib.mkForce [];

  system.stateVersion = "24.05";

  boot.loader.systemd-boot.extraInstallCommands = ''
    set -euo pipefail
    ${pkgs.coreutils}/bin/cp --no-preserve=mode -r ${config.hardware.deviceTree.package} ${config.boot.loader.efi.efiSysMountPoint}/
    for filename in ${config.boot.loader.efi.efiSysMountPoint}/loader/entries/nixos*-generation-[1-9]*.conf; do
      if ! ${pkgs.gnugrep}/bin/grep -q 'devicetree' $filename; then
        ${pkgs.coreutils}/bin/echo "devicetree /dtbs/${config.hardware.deviceTree.name}" >> $filename
      fi
    done
  '';
  hardware.deviceTree.name = "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";
  boot.initrd.kernelModules = [
    "dw_mmc-starfive"
    "motorcomm"
    "dwmac-starfive"
    "cdns3-starfive"
    "jh7110-trng"
    "phy-jh7110-usb"
    "clk-starfive-jh7110-aon"
    "clk-starfive-jh7110-stg"
    "clk-starfive-jh7110-vout"
    "clk-starfive-jh7110-isp"
    "clk-starfive-jh7100-audio"
    "phy-jh7110-pcie"
    "pcie-starfive"
    "nvme"
  ];
  systemd.network.enable = true;
  networking.useNetworkd = true;
}
