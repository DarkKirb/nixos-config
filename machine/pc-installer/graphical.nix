{
  config,
  nixos-config,
  ...
}: {
  nix.auto-update.specialisation = "graphical";
  imports = [
    "${nixos-config}/config/graphical.nix"
  ];
}
