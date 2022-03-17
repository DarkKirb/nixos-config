{ ... }: {
  imports = [
    ./fs.nix
    ./grub.nix
    ./luks.nix
  ];
  networking.hostId = "73561e1f";
}
