{
  config,
  inputs,
  ...
}: {
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
  networking.domain = "int.chir.rs";
  boot.initrd.systemd.enable = true;

  imports = [
    ./nix.nix
  ];

  zfs.enable = true;
}
