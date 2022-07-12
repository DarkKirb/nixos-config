{
  config,
  inputs,
  ...
}: {
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);

  imports = [
    ./nix.nix
  ];

  zfs.enable = true;
}
