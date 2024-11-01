{
  nixos-config,
  nixos-hardware,
  ...
}: {
  networking.hostName = "not522";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    ./cross-packages.nix
  ];
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnsupportedSystem = true;
  boot.initrd.timesync.enable = true;
}
