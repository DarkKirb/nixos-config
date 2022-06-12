{
  lib,
  pkgs,
  ...
}: {
  config = {
    services.nginx = {
      additionalModules = [pkgs.nginxModules.brotli];
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
        proxy_ssl_protocols TLSv1.2 TLSv1.3;
        set_real_ip_from fd0d:a262:1fa6:e621:b4e1:8ff:e658:6f49/128;
        real_ip_header    X-Forwarded-For;
        real_ip_recursive on;
      '';
      package = pkgs.nginxQuic;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      resolver.addresses = ["127.0.0.1" "[::1]"];
      sslProtocols = "TLSv1.2 TLSv1.3";
    };
    networking.firewall.allowedTCPPorts = [80 443];
    networking.firewall.allowedUDPPorts = [443];
    security.acme.certs."darkkirb.de".reloadServices = ["nginx.service"];
    security.acme.certs."chir.rs".reloadServices = ["nginx.service"];
    security.acme.certs."int.chir.rs".reloadServices = ["nginx.service"];
    security.acme.certs."miifox.net".reloadServices = ["nginx.service"];
  };

  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      config.listenAddresses = lib.mkDefault [
        "0.0.0.0"
        "[::]"
      ];
      config.forceSSL = lib.mkDefault true;
      config.http2 = lib.mkDefault true;
      config.extraConfig = lib.mkDefault ''
        listen 0.0.0.0:443 http3;
        listen [::]:443 http3;
        add_header Alt-Svc 'h3=":443"';
      '';
    });
  };
}
