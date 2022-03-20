{ ... }: {
  imports = [
    ../../config/boot/systemd-boot.nix
    ./cpu.nix
    ./fs.nix
    ./luks.nix
    ../../config/desktop
  ];
  networking.hostId = "e77e1829";
}
