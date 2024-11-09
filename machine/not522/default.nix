{
  nixos-config,
  nixpkgs,
  ...
}:
{
  networking.hostName = "not522";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./hardware.nix
    ./cross-packages.nix
    "${nixpkgs}/nixos/modules/profiles/minimal.nix"
  ];
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnsupportedSystem = true;
  nix.settings.system-features = [ "native-riscv" ];
}
