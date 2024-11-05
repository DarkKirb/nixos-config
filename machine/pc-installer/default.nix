{
  config,
  nixos-config,
  ...
}: {
  networking.hostName = "pc-installer";
  imports = [
    "${nixos-config}/config"
    ./disko.nix
    ./grub.nix
  ];
  system.stateVersion = config.system.nixos.version;
  specialisation.graphical = {
    configuration.imports = [
      ./graphical.nix
    ];
  };
}
