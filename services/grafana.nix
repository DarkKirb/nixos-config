{
  config,
  ...
}:
{
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.int.chir.rs";
      http_port = 2342;
      http_addr = "127.0.0.1";
    };
  };

  services.caddy.virtualHosts.${config.services.grafana.settings.server.domain} = {
    useACMEHost = "int.chir.rs";
    extraConfig = ''
      import baseConfig

      reverse_proxy http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}
    '';
  };
}
