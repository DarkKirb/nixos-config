{ pkgs, ... }:
{
  virtualisation.docker = {
    autoPrune = {
      dates = "weekly";
      enable = true;
      flags = [ "--all" ];
    };
    enable = true;
  };
  users.users.darkkirb.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [
    docker
    runc
  ];
  environment.persistence."/persistent".directories = [
    "/var/lib/docker"
  ];
}
