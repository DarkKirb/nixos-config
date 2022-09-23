_: {
  services.caddy = {
    enable = true;
    group = "acme";
    globalConfig = ''
      admin off
      storage file_system /var/lib/caddy
      auto_https disable_certs
    '';
    extraConfig = ''
      (baseConfig) {
        encode {
          gzip
          zstd
          # TODO: support for brotli
        }
      }
    '';
  };
  systemd.tmpfiles.rules = [
    "d '/var/lib/caddy' 0750 caddy acme - -"
  ];
  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [443];
}
