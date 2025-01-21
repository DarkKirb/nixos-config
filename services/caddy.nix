{ lib, config, ... }:
{
  security.acme.enable = lib.mkIf config.services.caddy.enable true;
  services.caddy = {
    group = "acme";
    globalConfig = ''
      admin off
      storage file_system /var/lib/caddy
      auto_https disable_certs
    '';
    logFormat = lib.mkForce ''
      output stdout
      format filter {
        request>remote_ip ip_mask 16 32
        request>client_ip ip_mask 16 32
        request>headers>X-Forwarded-For ip_mask 16 32
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
  systemd.tmpfiles.rules = lib.mkIf config.services.caddy.enable [
    "d '/var/lib/caddy' 0750 caddy acme - -"
  ];
  networking.firewall.allowedTCPPorts = lib.mkIf config.services.caddy.enable [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = lib.mkIf config.services.caddy.enable [ 443 ];
  security.acme.defaults.reloadServices = lib.mkIf config.services.caddy.enable [ "caddy" ];
}
