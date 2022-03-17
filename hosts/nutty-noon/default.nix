{ ... }: {
  imports = [
    ../../config/boot/systemd-boot.nix
    ./fs.nix
    ./luks.nix
  ];
  networking.hostId = "e77e1829";
}
