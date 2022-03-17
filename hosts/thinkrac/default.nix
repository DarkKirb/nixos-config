{ ... }: {
  imports = [
    ../../config/boot/systemd-boot.nix
    ./fs.nix
    ./luks.nix
  ];
  networking.hostId = "2bfaea87";
}
