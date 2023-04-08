{
  config,
  pkgs,
  modulesPath,
  lib,
  nixos-hardware,
  ...
}: {
  networking.hostName = "nutty-noon";
  networking.hostId = "e77e1829";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./systemd-boot.nix
    ./desktop.nix
    ./services/tpm2.nix
    ./secureboot.nix
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    ./services/postgres.nix
    ./services/woodpecker-agent.nix
    ./users/remote-build.nix
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "k10temp"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.zenpower
  ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing_bcachefs;
  boot.supportedFilesystems = lib.mkForce ["bcachefs" "vfat"];

  fileSystems."/" = {
    device = "/dev/disk/by-partuuid/d4c6a94f-2ae9-e446-9613-2596c564078c:/dev/disk/by-partuuid/53773b73-fb8a-4de8-ac58-d9d8ff1be430";
    fsType = "bcachefs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CA0B-E049";
    fsType = "vfat";
  };

  networking.interfaces.enp34s0.useDHCP = true;

  system.stateVersion = "21.11";

  networking.wireguard.interfaces."wg0".ips = ["fd0d:a262:1fa6:e621:47e6:24d4:2acb:9437/64"];

  services.xserver.videoDrivers = ["amdgpu"];

  environment.etc."sysconfig/lm_sensors".text = ''
    # Generated by sensors-detect on Tue Aug  7 10:54:09 2018
    # This file is sourced by /etc/init.d/lm_sensors and defines the modules to
    # be loaded/unloaded.
    #
    # The format of this file is a shell script that simply defines variables:
    # HWMON_MODULES for hardware monitoring driver modules, and optionally
    # BUS_MODULES for any required bus driver module (for example for I2C or SPI).

    HWMON_MODULES="nct6775"
  '';

  nix.settings.cores = 16;
  boot.binfmt.emulatedSystems = [
    "armv7l-linux"
    "aarch64-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
    "wasm32-wasi"
  ];
  hardware.enableRedistributableFirmware = true;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
  networking.wireguard.interfaces.wg0.peers = [
    # nas
    {
      publicKey = "RuQImASPojufJMoJ+zZ4FceC+mMN5vhxNR+i+m7g9Bc=";
      allowedIPs = [
        "fd0d:a262:1fa6:e621:bc9b:6a33:86e4:873b/128"
      ];
      endpoint = "192.168.2.1:51820";
    }
  ];

  nix.settings.system-features = [
    "kvm"
    "nixos-test"
    "big-parallel"
    "benchmark"
    "gccarch-znver2"
    "gccarch-znver1"
    "gccarch-skylake"
    "ca-derivations"
  ];
  networking.firewall.allowedTCPPorts = [58913];

  environment.etc."pipewire/pipewire.conf.d/hi-res.conf".text = ''
    context.properties = {
      default.clock.rate = 384000
      default.clock.allowedRates = [
        44100
        48000
        88200
        96000
        176400
        192000
        352800
        384000
      ]
      default.clock.quantum = 8192
    }
  '';
  nix.settings.substituters = lib.mkForce [
    "https://hydra.int.chir.rs/"
    "https://cache.nixos.org/"
  ];
  services.tailscale.useRoutingFeatures = "client";
}
