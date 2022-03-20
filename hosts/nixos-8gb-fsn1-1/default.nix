{ ... }: {
  imports = [
    ./cpu.nix
    ./fs.nix
    ./grub.nix
    ./luks.nix
    ../../config/server
  ];
  networking.hostId = "73561e1f";
}
