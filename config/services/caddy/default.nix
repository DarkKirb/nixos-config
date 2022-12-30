_: {
  services.caddy = {
    enable = true;
    group = "acme";
    globalConfig = ''
      admin off
      storage file_system /var/lib/caddy
      auto_https disable_certs
      log {
        output file /var/log/caddy/access.log {
          roll_keep_for 7d
        }
        format filter {
          wrap json
          fields {
            request>remote_addr ip_mask {
              ipv4 0
              ipv6 0
            }
            request>headers>Cf-Connecting-Ip ip_mask {
              ipv4 0
              ipv6 0
            }
            request>headers>X-Forwarded-For ip_mask {
              ipv4 0
              ipv6 0
            }
          }
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
