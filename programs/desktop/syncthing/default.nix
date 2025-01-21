{ ... }:
{
  services.syncthing = {
    enable = true;
  };
  home.persistence.default.directories = [ ".local/state/syncthing" ];
}
