{lib, ...}: {
  imports = [
    ./hostName.nix
  ];

  networking.hostName = lib.mkOverride 1100 "container";
  boot.isContainer = true;
}
