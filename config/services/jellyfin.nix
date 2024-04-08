{pkgs, ...}: {
  services.jellyfin.enable = true;
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
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
}
