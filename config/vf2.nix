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
    (import ../overlays/riscv.nix args)
  ];

  nix.settings.substituters = lib.mkForce [
    "https://beam.attic.rs/riscv"
    "https://cache.ztier.in"
    "https://hydra.int.chir.rs"
  ];
  boot = {
    supportedFilesystems = lib.mkForce ["vfat" "ext4"];
    kernelPackages = pkgs.linuxPackagesFor pkgs.vf2Kernel;
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200"
      "earlycon=sbi"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 7;
    initrd = {
      network.enable = true;
      network.flushBeforeStage2 = false;
      availableKernelModules = [
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
    };
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
    iscsi-initiator = {
      discoverPortal = "192.168.2.1";
      name = "iqn.2023-06.rs.chir:rs.chir.int.vf2";
      target = "iqn.2023-06.rs.chir:rs.chir.int.nas.vf2";
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/1234-ABCD";
      fsType = "vfat";
      options = ["nofail"];
    };
    "/" = {
      device = "/dev/disk/by-uuid/b4e8cbe8-a233-444f-920b-c253339a44d6";
      fsType = "ext4";
    };
  };
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
    # There are many more combinations but i simply do not care lol
    "gccarch-rv64gc_zba_zbb"
    "gccarch-rv64gc_zba"
    "gccarch-rv64gc_zbb"
    "gccarch-rv64gc"
    "gccarch-rv32gc_zba_zbb"
    "gccarch-rv32gc_zba"
    "gccarch-rv32gc_zbb"
    "gccarch-rv32gc"
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
  networking.useNetworkd = lib.mkForce false;
  networking.interfaces.end0.useDHCP = true;

  services.openiscsi = {
    name = "iqn.2023-06.rs.chir:rs.chir.int.vf2";
    discoverPortal = "192.168.2.1";
    enable = true;
  };

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
  ];
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  system.requiredKernelConfig = lib.mkForce [];
}
