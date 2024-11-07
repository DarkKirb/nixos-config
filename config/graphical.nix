{config, ...}: {
  time.timeZone = "Etc/GMT-1";
  isGraphical = true;
  imports = [
    ./kde
    ./graphical/plymouth.nix
  ];
}
