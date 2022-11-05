{
  services.nginx = {
    enable = true;
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
        proxy_cache_path /var/cache/mediacache levels=1:2 keys_zone=akkoma_media_cache:10m inactive=1y use_temp_path=off;
        location ~ ^/(media|proxy) {
          proxy_cache        akkoma_media_cache;
          slice              1m;
          proxy_cache_key    $host$uri$is_args$args$slice_range;
          proxy_set_header   Range $slice_range;
          proxy_http_version 1.1;
          proxy_cache_valid  206 301 302 304 1h;
          proxy_cache_valid  200 1y;
          proxy_cache_use_stale error timeout invalid_header updating;
          proxy_ignore_client_abort on;
          proxy_buffering    on;
          chunked_transfer_encoding on;
          proxy_ignore_headers Cache-Control Expires;
          proxy_hide_header  Cache-Control Expires;
          proxy_pass         http://127.0.0.1:4000;
        }
      '';
    };
  };
  systemd.tmpfiles.rules = [
    "d '/var/cache/mediacache' 0750 nginx nginx - -"
  ];
}
