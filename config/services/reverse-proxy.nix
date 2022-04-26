{ config, ... }: {
  services.nginx.virtualHosts."hydra.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "https://hydra.int.chir.rs";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_ssl_server_name on;
      '';
    };
  };
  services.nginx.virtualHosts."mastodon.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      proxyPass = "https://mastodon.int.chir.rs";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_ssl_server_name on;
      '';
    };
  };
  services.nginx.virtualHosts."mastodon-assets.chir.rs" = {
    sslCertificate = "/var/lib/acme/chir.rs/cert.pem";
    sslCertificateKey = "/var/lib/acme/chir.rs/key.pem";
    locations."/" = {
      tryFiles = "$uri @s3";
    };
    locations."@s3" = {
      extraConfig = ''
        limit_except GET {
          deny all;
        }
        proxy_set_header Host 's3.us-west-000.backblazeb2.com';
        proxy_set_header Connection ${"''"};
        proxy_set_header Authorization ${"''"};
        proxy_hide_header Set-Cookie;
        proxy_hide_header 'Access-Control-Allow-Origin';
        proxy_hide_header 'Access-Control-Allow-Methods';
        proxy_hide_header 'Access-Control-Allow-Headers';
        proxy_hide_header x-amz-id-2;
        proxy_hide_header x-amz-request-id;
        proxy_hide_header x-amz-meta-server-side-encryption;
        proxy_hide_header x-amz-server-side-encryption;
        proxy_hide_header x-amz-bucket-region;
        proxy_hide_header x-amzn-requestid;
        proxy_ignore_headers Set-Cookie;
        proxy_intercept_errors off;
        proxy_cache CACHE;
        proxy_cache_valid 200 48h;
        proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
        proxy_cache_lock on;
        expires 1y;
        add_header Cache-Control public;
        add_header 'Access-Control-Allow-Origin' '*';
        add_header X-Cache-Status $upstream_cache_status;
      '';
      proxyPass = "https://s3.us-west-000.backblazeb2.com";
    };
  };
  services.nginx.appendHttpConfig = ''
    proxy_cache_path /var/tmp/nginx levels=1:2 keys_zone=CACHE:10m max_size=10g
                 inactive=60m use_temp_path=off;
  '';
}
