{ ... }:
{
  networking.networkmanager.enable = true;
  users.users.darkkirb.extraGroups = [ "networkmanager" ];
  environment.persistence."/persistent".directories = [
    "/var/lib/NetworkManager"
    "/etc/NetworkManager"
  ];
}
