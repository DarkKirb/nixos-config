{
  nixos-config,
  nixos-hardware,
  ...
}: {
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
  ];
  system.stateVersion = "24.11";
}
