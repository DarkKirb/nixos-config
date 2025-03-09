{ pkgs, ... }:
{
  imports = [
    ./caddy.nix
  ];
  services.jellyfin.enable = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.yt-dlp
  ];
  systemd.services.jellyfin.path = [ pkgs.yt-dlp ];
  services.caddy.virtualHosts."jellyfin.int.chir.rs" = {
    useACMEHost = "int.chir.rs";
    logFormat = pkgs.lib.mkForce "";
    extraConfig = ''
      import baseConfig

      reverse_proxy {
        to http://localhost:8096
        trusted_proxies private_ranges
      }
    '';
  };
  environment.persistence."/persistent".directories = [
    "/var/lib/jellyfin"
  ];
}
