_: {
  services.caddy = {
    enable = true;
    group = "acme";
    globalConfig = ''
      admin off
      storage file_system /var/lib/caddy
      auto_https disable_certs
      servers {
        protocol {
          experimental_http3
          strict_sni_host on
        }
      }
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
