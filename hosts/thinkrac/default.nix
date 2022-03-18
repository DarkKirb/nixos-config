{ ... }: {
  imports = [
    ../../config/boot/systemd-boot.nix
    ./cpu.nix
    ./fs.nix
    ./luks.nix
  ];
  networking.hostId = "2bfaea87";
}
