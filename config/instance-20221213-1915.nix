{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
} @ args: {
  networking.hostName = "instance-20221213-1915";
  networking.hostId = "746d4523";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./systemd-boot.nix
    ./server.nix
    ./wireguard/public-server.nix
    ./services/named-submissive.nix
    ./services/shitalloverme.nix
    ./services/chir.rs
    ./users/remote-build.nix
    ./services/atticd.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "tank/local/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6557-C4A0";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "tank/local/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "tank/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "tank/safe/home";
    fsType = "zfs";
  };

  networking.useDHCP = lib.mkDefault true;

  # https://grahamc.com/blog/erase-your-darlings
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r tank/local/root@blank
  '';

  services.openssh = {
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/acme - - - - /persist/var/lib/acme"
    "L /var/lib/tailscale - - - - /persist/var/lib/tailscale"
    "D /build - - - - -"
  ];

  networking.wireguard.interfaces."wg0".ips = ["fd0d:a262:1fa6:e621:746d:4523:5c04:1453/64"];
  home-manager.users.darkkirb = import ./home-manager/darkkirb.nix {
    desktop = false;
    inherit args;
  };
  nix.settings.cores = 2;
  nix.settings.max-jobs = 2;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  system.stateVersion = "22.11";

  sops.secrets."root/.ssh/id_ed25519" = {
    owner = "root";
    path = "/root/.ssh/id_ed25519";
  };
  sops.secrets."services/ssh/host-key" = {
    owner = "root";
    path = "/etc/secrets/initrd/ssh_host_ed25519_key";
  };
  sops.age.sshKeyPaths = lib.mkForce ["/persist/ssh/ssh_host_ed25519_key"];
  services.bind.forwarders = lib.mkForce [];
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;
  system.autoUpgrade.allowReboot = true;
  services.tailscale.useRoutingFeatures = "server";
}
