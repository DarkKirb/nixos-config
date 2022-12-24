{
  services.nginx = {
    enable = true;
    commonHttpConfig = "proxy_cache_path /var/cache/mediacache levels=2:2:2 keys_zone=akkoma_media_cache:25m inactive=1y use_temp_path=off min_free=10G;";
    virtualHosts."mail.chir.rs".listen = [
      {
        addr = "127.0.0.1";
        port = 24153;
      }
    ];
    virtualHosts."mediaproxy.int.chir.rs" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 24154;
        }
      ];
      extraConfig = ''
        location ~ ^/(media|proxy) {
          proxy_cache        akkoma_media_cache;
          proxy_cache_key    $host$uri$is_args$args;
          proxy_http_version 1.1;
          proxy_cache_valid  206 301 302 304 1h;
          proxy_cache_valid  200 1y;
          proxy_cache_use_stale error timeout invalid_header updating;
          proxy_ignore_client_abort on;
          proxy_buffering    on;
          proxy_cache_lock on;
          proxy_pass         http://127.0.0.1:4000;
        }
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d '/var/cache/mediacache' 0750 nginx nginx - -"
  ];
  systemd.services.nginx.serviceConfig.ReadWritePaths = ["/var/cache/mediacache"];
  services.nginx.validateConfig = false;
}
