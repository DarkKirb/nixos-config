{ nixos-config, ... }:
{
  time.timeZone = "Etc/GMT-1";
  isGraphical = true;
  imports = [
    ./kde
    ./documentation.nix
    ./graphical/fonts.nix
    "${nixos-config}/services/security-key"
  ];
}
