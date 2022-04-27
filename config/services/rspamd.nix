{ config, ... }: {
  services.rspamd = {
    enable = true;
    locals."dkim_signing.conf".text = ''
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
    workers = {
      normal = {
        includes = [ "$CONFDIR/worker-normal.inc" ];
        bindSockets = [ "[::1]:11332" ];
      };
      controller = {
        includes = [ "$CONFDIR/worker-controller.inc" ];
        bindSockets = [ "[::1]:11334" ];
      };
    };
  };
  sops.secrets."services/rspamd/dkim/darkkirb.de" = { owner = "rspamd"; };
  sops.secrets."services/rspamd/dkim/miifox.net" = { owner = "rspamd"; };
  sops.secrets."services/rspamd/dkim/chir.rs" = { owner = "rspamd"; };
}
