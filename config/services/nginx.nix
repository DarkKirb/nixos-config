{ pkgs, ... }: {
  services.nginx = {
    additionalModules = [ pkgs.nginxModules.brotli ];
    clientMaxBodySize = "10g";
    enable = true;
    appendHttpConfig = ''
      brotli on;
      brotli_types
                application/atom+xml
                application/javascript
                application/json
                application/xml
                application/xml+rss
                image/svg+xml
                text/css
                text/javascript
                text/plain
                text/xml;
    '';
    # package = pkgs.nginxQuic;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    resolver.addresses = [ "127.0.0.1" "[::1]" ];
    sslProtocols = "TLSv1.3";
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];
}
