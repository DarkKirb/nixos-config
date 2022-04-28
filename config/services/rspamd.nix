{ config, ... }: {
  services = {
    rspamd = {
      enable = true;
      locals = {
        "dkim_signing.conf".text = ''
          domain {
            darkkirb.de {
              selector = "dkim";
              path = "${config.sops.secrets."services/rspamd/dkim/darkkirb.de".path}";
            }
            miifox.net {
              selector = "dkim";
              path = "${config.sops.secrets."services/rspamd/dkim/miifox.net".path}";
            }
            chir.rs {
              selector = "dkim";
              path = "${config.sops.secrets."services/rspamd/dkim/chir.rs".path}";
            }
          }
          allow_hdrfrom_mismatch = true;
          allow_hdrfrom_mismatch_sign_networks = true;
          allow_username_mismatch = true;
          use_domain = "header";
          sign_authenticated = true;
          use_esld = true;
        '';
        "redis.conf" = builtns.toJSON {
          servers = "${config.services.redis.rspamd.bind}:${toString config.services.redis.rspamd.port}";
        };
      };
      workers = {
        normal = {
          includes = [ "$CONFDIR/worker-normal.inc" ];
          bindSockets = [ "*:11332" ];
        };
        controller = {
          includes = [ "$CONFDIR/worker-controller.inc" ];
          bindSockets = [ "*:11334" ];
        };
      };

    };
    redis.servers.rspamd = {
      enable = true;
      bind = "127.0.0.1";
      databases = 1;
      port = 6380;
    };
    nginx.virtualHosts."rspamd.int.chir.rs" =
      let
        listenIPs = (import ../../utils/getInternalIP.nix config).listenIPs;
        listenStatements = lib.concatStringsSep "\n" (builtins.map (ip: "listen ${ip}:443 http3;") listenIPs) + ''
          add_header Alt-Svc 'h3=":443"';
        '';
      in
      {
        listenAddresses = listenIPs;
        sslCertificate = "/var/lib/acme/int.chir.rs/cert.pem";
        sslCertificateKey = "/var/lib/acme/int.chir.rs/key.pem";
        locations."/" = {
          proxyPass = "http://127.0.0.1:11334/";
          proxyWebsockets = true;
        };
      };
  };
  sops.secrets."services/rspamd/dkim/darkkirb.de" = { owner = "rspamd"; };
  sops.secrets."services/rspamd/dkim/miifox.net" = { owner = "rspamd"; };
  sops.secrets."services/rspamd/dkim/chir.rs" = { owner = "rspamd"; };
}
