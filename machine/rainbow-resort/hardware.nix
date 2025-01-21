{
  modulesPath,
  nixos-hardware,
  config,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-cpu-amd-pstate
    nixos-hardware.nixosModules.common-cpu-amd-zenpower
    nixos-hardware.nixosModules.common-gpu-amd
    nixos-hardware.nixosModules.common-pc
    nixos-hardware.nixosModules.common-pc-ssd
    ./postgresql.nix
  ];
  hardware.cpu.amd.updateMicrocode = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
    "k10temp"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [
    "kvm-amd"
    "i2c-dev"
    "i2c-piix4"
  ];
  boot.extraModulePackages = [ ];
  nix.settings.cores = 16;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "wasm32-wasi"
    "riscv32-linux"
    "riscv64-linux"
  ];
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
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = config.isSway;
  services.joycond.enable = true;
  hardware.graphics.extraPackages = [ pkgs.amf ];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="e621", ATTRS{idProduct}=="0000", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="e621", ATTRS{idProduct}=="0000", TAG+="uaccess"
  '';
  users.users.darkkirb.extraGroups = [ "dialout" ];
}
