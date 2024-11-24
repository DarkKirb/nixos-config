{ nixos-config, config, ... }:
{
  time.timeZone = "Etc/GMT-1";
  isGraphical = true;
  imports = [
    ./kde
    ./documentation.nix
    ./graphical/fonts.nix
    "${nixos-config}/services/security-key"
  ];
  home-manager.users.darkkirb.imports =
    if config.isSway then
      [
        ./sway
        ./graphical/gtk-fixes
      ]
    else
      [ ./graphical/gtk-fixes ];
}
