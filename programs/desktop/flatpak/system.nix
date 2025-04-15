{ config, nix-flatpak, ... }:
{
  services.flatpak.enable = config.system.isGraphical;
  imports = [
    nix-flatpak.nixosModules.nix-flatpak
  ];
  environment.persistence."/persistent".directories = [ "/var/lib/flatpak" ];
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly"; # Default value
  };
}
